require 'rubycas-server-core/util'
require 'rubycas-server-core/tickets'
require 'rubycas-server-core/tickets/validations'
require 'rubycas-server-core/tickets/generations'

class CasController < ApplicationController
  include RubyCAS::Server::Core::Util
  include RubyCAS::Server::Core::Tickets
  include RubyCAS::Server::Core::Tickets::Validations
  include RubyCAS::Server::Core::Tickets::Generations

  def login
    # make sure there's no caching
    headers['Pragma'] = 'no-cache'
    headers['Cache-Control'] = 'no-store'
    headers['Expires'] = (Time.now - 1.year).rfc2822

    c = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']

    # optional params
    @service = Utils.clean_service_url(params['service'])
    @renew = params['renew']
    @gateway = params['gateway'] == 'true' || params['gateway'] == '1'

    if tgc = request.cookies['tgt']
      tgt, tgt_error = validate_ticket_granting_ticket(tgc)
    end

    if tgt && !tgt_error
      @authenticated = true
      @authenticated_username = tgt.username
      @message = {:type => 'notice',
        :message => "You are currently logged in as '#{tgt.username}'. If this is not you, please log in below."}
    elsif tgt_error
      logger.debug("Ticket granting cookie could not be validated: #{tgt_error}")
    elsif !tgt
      logger.debug("No ticket granting ticket detected.")
    end

    if params['redirection_loop_intercepted']
      @message = {:type => 'mistake',
        :message => "The client and server are unable to negotiate authentication. Please try logging in again later."}
    end

    begin
      if @service
        if @renew
          logger.info("Authentication renew explicitly requested. Proceeding with CAS login for service #{@service.inspect}.")
        elsif tgt && !tgt_error
          logger.debug("Valid ticket granting ticket detected.")
          st = ST.generate_service_ticket(@service, tgt.username, tgt, c)
          service_with_ticket = service_uri_with_ticket(@service, st)
          logger.info("User '#{tgt.username}' authenticated based on ticket granting cookie. Redirecting to service '#{@service}'.")
          redirect_to service_with_ticket, status: 303 # response code 303 means "See Other" (see Appendix B in CAS Protocol spec)
          return
        elsif @gateway
          logger.info("Redirecting unauthenticated gateway request to service '#{@service}'.")
          redirect_to @service, status: 303
          return
        else
          logger.info("Proceeding with CAS login for service #{@service.inspect}.")
        end
      elsif @gateway
          logger.error("This is a gateway request but no service parameter was given!")
          @message = {:type => 'mistake',
            :message => "The server cannot fulfill this gateway request because no service parameter was given."}
      else
        logger.info("Proceeding with CAS login without a target service.")
      end
    rescue URI::InvalidURIError
      logger.error("The service '#{@service}' is not a valid URI!")
      @message = {:type => 'mistake',
        :message => "The target service your browser supplied appears to be invalid. Please contact your system administrator for help."}
    end

    c = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']
    lt = LT.generate_login_ticket(c)

    logger.debug("Rendering login form with lt: #{lt}, service: #{@service}, renew: #{@renew}, gateway: #{@gateway}")

    @lt = lt.ticket


    # If the 'onlyLoginForm' parameter is specified, we will only return the
    # login form part of the page. This is useful for when you want to
    # embed the login form in some external page (as an IFRAME, or otherwise).
    # The optional 'submitToURI' parameter can be given to explicitly set the
    # action for the form, otherwise the server will try to guess this for you.
    if params.has_key? 'onlyLoginForm'
      if request.env['HTTP_HOST']
        guessed_login_uri = "#{request.env['HTTPS']}://#{request.env['REQUEST_URI']}#{self / '/login'}"
      else
        guessed_login_uri = nil
      end

      @form_action = params['submitToURI'] || guessed_login_uri

      if @form_action
        return render :_login_form
      else
        return render :json => {:response => "Could not guess the CAS login URI. Please supply a submitToURI parameter with your request."}, status: :internal_server_error
      end
    else
      render :login
    end
  end

  def loginpost
    @service = Utils.clean_service_url(params['service'])
    @username = params['username'].downcase # this ensures we always use lowercase for ease of case comparison throughout the system
    @password = params['password']
    @lt = params['lt']

    c = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']

    # Remove leading and trailing widespace from username.
    @username.strip! if @username

    if !result = validate_login_ticket(@lt)
      @message = {:type => 'mistake', :message => error}
      # generate another login ticket to allow for re-submitting the form
      @lt = LT.generate_login_ticket(c).ticket
      return render :login, status: :unauthorized
    end

    # generate another login ticket to allow for re-submitting the form after a post
    @lt = LT.generate_login_ticket(c).ticket

    settings = RubyCAS::Server::Core::Settings._settings
    logger.debug("Logging in with username: #{@username}, lt: #{@lt}, service: #{@service}, auth: #{settings.inspect}")

    credentials_are_valid = false
    extra_attributes = {}
    successful_authenticator = nil
    begin
      auth_index = 0
      settings[:auth].each do |auth_class|
        auth = auth_class.new

        auth_config = settings[:authenticator]
        # pass the authenticator index to the configuration hash in case the authenticator needs to know
        # it splace in the authenticator queue
        auth.configure(auth_config.merge('auth_index' => auth_index))

        credentials_are_valid = auth.validate(
          :username => @username,
          :password => @password,
          :service => @service,
          :request => request.env
        )
        if credentials_are_valid
          @authenticated = true
          @authenticated_username = @username
          extra_attributes.merge!(auth.extra_attributes) unless auth.extra_attributes.blank?
          successful_authenticator = auth
          break
        end

        auth_index += 1
      end

      if credentials_are_valid
        logger.info("Credentials for username '#{@username}' successfully validated using #{successful_authenticator.class.name}.")
        logger.debug("Authenticator provided additional user attributes: #{extra_attributes.inspect}") unless extra_attributes.blank?

        tgt = generate_ticket_granting_ticket(@username, extra_attributes)
        response.set_cookie('tgt', tgt.to_s)

        logger.debug("Ticket granting cookie '#{tgt.inspect}' granted to #{@username.inspect}")

        if @service.blank?
          logger.info("Successfully authenticated user '#{@username}' at '#{tgt.client_hostname}'. No service param was given, so we will not redirect.")
          @message = {:type => 'confirmation', :message => "You have successfully logged in."}
        else
          @st = ST.generate_service_ticket(@service, @username, tgt, c)

          begin
            service_with_ticket = service_uri_with_ticket(@service, @st)
            logger.info("Redirecting authenticated user '#{@username}' at '#{@st.client_hostname}' to service '#{@service}'")
            redirect_to service_with_ticket, status: 303 # response code 303 means "See Other" (see Appendix B in CAS Protocol spec)
            return
          rescue URI::InvalidURIError
            logger.error("The service '#{@service}' is not a valid URI!")
            @message = {
              :type => 'mistake',
              :message => "The target service your browser supplied appears to be invalid. Please contact your system administrator for help."
            }
          end
        end
      else
        logger.warn("Invalid credentials given for user '#{@username}'")
        @message = {
          :type => 'mistake', :message => "Incorrect username or password."
        }
        return render :login, status: :unauthorized
      end
    rescue RubyCAS::Server::Core::AuthenticatorError => e
      logger.error(e)
      # generate another login ticket to allow for re-submitting the form
      @lt = LT.generate_login_ticket(c).ticket
      @message = {:type => 'mistake', :message => e.to_s}
      return render :login , status: :unauthorized
    end

    render :login
  end

  def logout
    # The behaviour here is somewhat non-standard. Rather than showing just a blank
    # "logout" page, we take the user back to the login page with a "you have been logged out"
    # message, allowing for an opportunity to immediately log back in. This makes it
    # easier for the user to log out and log in as someone else.

    # BZ modification: always use default service so logout/login goes back to our main
    # site (which can redirect) regardless of where they came from
    settings = RubyCAS::Server::Core::Settings._settings
    @service = Utils.clean_service_url(params['service'] || settings[:default_service]) # params['service'] || params['destination'])
    @continue_url = params['url']

    @gateway = params['gateway'] == 'true' || params['gateway'] == '1'

    tgt = LT.find_by(ticket: request.cookies['tgt'])

    response.delete_cookie 'tgt'

    if tgt
      LT.transaction do
        logger.debug("Deleting Service/Proxy Tickets for '#{tgt}' for user '#{tgt.username}'")
        tgt.granted_service_tickets.each do |st|
          send_logout_notification_for_service_ticket(st) if config[:enable_single_sign_out]
          # TODO: Maybe we should do some special handling if send_logout_notification_for_service_ticket fails?
          #       (the above method returns false if the POST results in a non-200 HTTP response).
          logger.debug "Deleting #{st.class.name.demodulize} #{st.ticket.inspect} for service #{st.service}."
          st.destroy
        end

        # Not implemented....yet
        # pgts = CASServer::Model::ProxyGrantingTicket.find(:all,
        #   :conditions => [CASServer::Model::ServiceTicket.quoted_table_name+".username = ?", tgt.username],
        #   :include => :service_ticket)
        # pgts.each do |pgt|
        #   logger.debug("Deleting Proxy-Granting Ticket '#{pgt}' for user '#{pgt.service_ticket.username}'")
        #   pgt.destroy
        # end

        logger.debug("Deleting #{tgt.class.name.demodulize} '#{tgt}' for user '#{tgt.username}'")
        tgt.destroy
      end

      logger.info("User '#{tgt.username}' logged out.")
    else
      logger.warn("User tried to log out without a valid ticket-granting ticket.")
    end

    @message = {:type => 'confirmation', :message => "You have successfully logged out."}

    @message[:message] +=  "Please click on the following link to continue:" if @continue_url

    @log_out_of_services = true

    c = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR'] 
    @lt = generate_login_ticket(c)

    if @gateway && @service
      return render :login
    elsif @continue_url
      return render :logout
    end
    render :login
  end

  def loginTicket
    logger.error("Tried to use login ticket dispenser with get method!")

    render :json => {:response => "To generate a login ticket, you must make a POST request."}, status: :unprocessable_entity
  end
  
  # Renders a page with a login ticket (and only the login ticket)
  # in the response body.
  def loginTicketPost
    c = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']
    lt = LT.generate_login_ticket(c)

    logger.debug("Dispensing login ticket #{lt} to host #{(request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']).inspect}")

    @lt = lt.ticket

    @lt
  end

  def validate
    # required
    @service = Utils.clean_service_url(params['service'])
    @ticket = params['ticket']
    # optional
    @renew = params['renew']

    st, @error = validate_service_ticket(@service, @ticket)
    @success = st && !@error

    @username = st.username if @success

    if @error
      render :json => {:response => @error}, status: 422
    end 

    render :validate, :layout => false
  end
  
  def serviceValidate
    # required
    @service = Utils.clean_service_url(params['service'])
    @ticket = params['ticket']
    # optional
    @pgt_url = params['pgtUrl']
    @renew = params['renew']

    st, @error = validate_service_ticket(@service, @ticket)
    @success = st && !@error

    if @success
      @username = st.username
      if @pgt_url
        pgt = generate_proxy_granting_ticket(@pgt_url, st, c)
        @pgtiou = pgt.iou if pgt
      end
      @extra_attributes = st.granted_by_tgt.extra_attributes || {}
    end

    if @error
      render :json => {:response => @error}, status: 422
    end 

    render :builder, content_type: 'text/xml'
  end
  
  def proxyValidate
    # force xml content type
    @headers = {
      content_type: 'text/xml',
      charset: 'utf-8'
    }

    # required
    @service = Utils.clean_service_url(params['service'])
    @ticket = params['ticket']
    # optional
    @pgt_url = params['pgtUrl']
    @renew = params['renew']

    @proxies = []

    t, @error = validate_proxy_ticket(@service, @ticket)
    @success = t && !@error

    @extra_attributes = {}
    if @success
      @username = t.username

      if t.kind_of? CASServer::Model::ProxyTicket
        raise NotImplementedError
        @proxies << t.granted_by_pgt.service_ticket.service
      end

      if @pgt_url
        pgt = generate_proxy_granting_ticket(@pgt_url, t, c)
        @pgtiou = pgt.iou if pgt
      end

      @extra_attributes = t.granted_by_tgt.extra_attributes || {}
    end

    if @error
      render :json => {:response => @error}, status: 422
    end 

    render :builder, :proxy_validate
  end

  def proxy
    # required
    @ticket = params['pgt']
    @target_service = params['targetService']

    pgt, @error = validate_proxy_granting_ticket(@ticket)
    @success = pgt && !@error

    if @success
      @pt = generate_proxy_ticket(@target_service, pgt)
    end

    if @error
      render :json => {:response => @error}, status: 422
    end 

    render :builder, :proxy
  end

end
