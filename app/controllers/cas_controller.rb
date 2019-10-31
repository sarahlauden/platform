require 'rubycas-server-core/util'
require 'rubycas-server-core/tickets'
require 'rubycas-server-core/tickets/validations'
require 'rubycas-server-core/tickets/generations'

class CasController < ApplicationController
  $LOG = Logger.new(STDOUT)
  include RubyCAS::Server::Core::Util
  include RubyCAS::Server::Core::Tickets
  include RubyCAS::Server::Core::Tickets::Validations
  include RubyCAS::Server::Core::Tickets::Generations

  def login
    # make sure there's no caching
    headers['Pragma'] = 'no-cache'
    headers['Cache-Control'] = 'no-store'
    headers['Expires'] = (Time.now - 1.year).rfc2822

    # optional params
    @service = clean_service_url(params['service'])
    @renew = params['renew']
    @gateway = params['gateway'] == 'true' || params['gateway'] == '1'

    if tgc = request.cookies['tgt']
      tgt, tgt_error = validate_ticket_granting_ticket(tgc)
    end

    if tgt and !tgt_error
      @authenticated = true
      @authenticated_username = tgt.username
      @message = {:type => 'notice',
        :message => "You are currently logged in as '#{tgt.username}'. If this is not you, please log in below."}
    elsif tgt_error
      $LOG.debug("Ticket granting cookie could not be validated: #{tgt_error}")
    elsif !tgt
      $LOG.debug("No ticket granting ticket detected.")
    end

    if params['redirection_loop_intercepted']
      @message = {:type => 'mistake',
        :message => "The client and server are unable to negotiate authentication. Please try logging in again later."}
    end

    begin
      if @service
        if @renew
          $LOG.info("Authentication renew explicitly requested. Proceeding with CAS login for service #{@service.inspect}.")
        elsif tgt && !tgt_error
          $LOG.debug("Valid ticket granting ticket detected.")
          st = ST.generate_service_ticket(@service, tgt.username, tgt)
          service_with_ticket = service_uri_with_ticket(@service, st)
          $LOG.info("User '#{tgt.username}' authenticated based on ticket granting cookie. Redirecting to service '#{@service}'.")
          redirect service_with_ticket, 303 # response code 303 means "See Other" (see Appendix B in CAS Protocol spec)
        elsif @gateway
          $LOG.info("Redirecting unauthenticated gateway request to service '#{@service}'.")
          redirect @service, 303
        else
          $LOG.info("Proceeding with CAS login for service #{@service.inspect}.")
        end
      elsif @gateway
          $LOG.error("This is a gateway request but no service parameter was given!")
          @message = {:type => 'mistake',
            :message => "The server cannot fulfill this gateway request because no service parameter was given."}
      else
        $LOG.info("Proceeding with CAS login without a target service.")
      end
    rescue URI::InvalidURIError
      $LOG.error("The service '#{@service}' is not a valid URI!")
      @message = {:type => 'mistake',
        :message => "The target service your browser supplied appears to be invalid. Please contact your system administrator for help."}
    end

    c = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']
    lt = LT::generate_login_ticket(c)

    $LOG.debug("Rendering login form with lt: #{lt}, service: #{@service}, renew: #{@renew}, gateway: #{@gateway}")

    @lt = lt.ticket

    #$LOG.debug(env)

    # If the 'onlyLoginForm' parameter is specified, we will only return the
    # login form part of the page. This is useful for when you want to
    # embed the login form in some external page (as an IFRAME, or otherwise).
    # The optional 'submitToURI' parameter can be given to explicitly set the
    # action for the form, otherwise the server will try to guess this for you.
    if params.has_key? 'onlyLoginForm'
      if request.env['HTTP_HOST']
        guessed_login_uri = "http#{request.env['HTTPS'] && request.env['HTTPS'] == 'on' ? 's' : ''}://#{request.env['REQUEST_URI']}#{self / '/login'}"
      else
        guessed_login_uri = nil
      end

      @form_action = params['submitToURI'] || guessed_login_uri

      if @form_action
        render :login_form
      else
        status 500
        render "Could not guess the CAS login URI. Please supply a submitToURI parameter with your request."
      end
    else
      render :login
    end
  end

  def loginpost
    @service = clean_service_url(params['service'])

    @username = params['username'].downcase # this ensures we always use lowercase for ease of case comparison throughout the system
    @password = params['password']
    @lt = params['lt']

    # Remove leading and trailing widespace from username.
    @username.strip! if @username

    if @username && settings.config[:downcase_username]
      $LOG.debug("Converting username #{@username.inspect} to lowercase because 'downcase_username' option is enabled.")
      @username.downcase!
    end

    if error = validate_login_ticket(@lt)
      @message = {:type => 'mistake', :message => error}
      # generate another login ticket to allow for re-submitting the form
      @lt = LT.generate_login_ticket.ticket
      status 500
      return render :login
    end

    # generate another login ticket to allow for re-submitting the form after a post
    @lt = LT.generate_login_ticket.ticket

    $LOG.debug("Logging in with username: #{@username}, lt: #{@lt}, service: #{@service}, auth: #{settings.auth.inspect}")

    credentials_are_valid = false
    extra_attributes = {}
    successful_authenticator = nil
    begin
      auth_index = 0
      settings.auth.each do |auth_class|
        auth = auth_class.new

        auth_config = settings.config[:authenticator][auth_index]
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
        $LOG.info("Credentials for username '#{@username}' successfully validated using #{successful_authenticator.class.name}.")
        $LOG.debug("Authenticator provided additional user attributes: #{extra_attributes.inspect}") unless extra_attributes.blank?

        # 3.6 (ticket-granting cookie)
        tgt = generate_ticket_granting_ticket(@username, extra_attributes)
        response.set_cookie('tgt', tgt.to_s)

        $LOG.debug("Ticket granting cookie '#{tgt.inspect}' granted to #{@username.inspect}")

        if @service.blank?
          $LOG.info("Successfully authenticated user '#{@username}' at '#{tgt.client_hostname}'. No service param was given, so we will not redirect.")
          @message = {:type => 'confirmation', :message => "You have successfully logged in."}
        else
          @st = ST.generate_service_ticket(@service, @username, tgt)

          begin
            service_with_ticket = service_uri_with_ticket(@service, @st)

            $LOG.info("Redirecting authenticated user '#{@username}' at '#{@st.client_hostname}' to service '#{@service}'")
            redirect service_with_ticket, 303 # response code 303 means "See Other" (see Appendix B in CAS Protocol spec)
          rescue URI::InvalidURIError
            $LOG.error("The service '#{@service}' is not a valid URI!")
            @message = {
              :type => 'mistake',
              :message => "The target service your browser supplied appears to be invalid. Please contact your system administrator for help."
            }
          end
        end
      else
        $LOG.warn("Invalid credentials given for user '#{@username}'")
        @message = {:type => 'mistake', :message => "Incorrect username or password."}
        status 401
      end
    rescue Core::Authenticator::AuthenticatorError => e
      $LOG.error(e)
      # generate another login ticket to allow for re-submitting the form
      @lt = LT.generate_login_ticket.ticket
      @message = {:type => 'mistake', :message => e.to_s}
      status 401
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
    @service = clean_service_url(params['service'] || 'http://canvasweb/login/cas') # params['service'] || params['destination'])
    @continue_url = params['url']

    @gateway = params['gateway'] == 'true' || params['gateway'] == '1'

    tgt = LT.find_by(ticket: request.cookies['tgt'])

    response.delete_cookie 'tgt'

    if tgt
      LT.transaction do
        $LOG.debug("Deleting Service/Proxy Tickets for '#{tgt}' for user '#{tgt.username}'")
        tgt.granted_service_tickets.each do |st|
          send_logout_notification_for_service_ticket(st) if config[:enable_single_sign_out]
          # TODO: Maybe we should do some special handling if send_logout_notification_for_service_ticket fails?
          #       (the above method returns false if the POST results in a non-200 HTTP response).
          $LOG.debug "Deleting #{st.class.name.demodulize} #{st.ticket.inspect} for service #{st.service}."
          st.destroy
        end

        # Not implemented....yet
        # pgts = CASServer::Model::ProxyGrantingTicket.find(:all,
        #   :conditions => [CASServer::Model::ServiceTicket.quoted_table_name+".username = ?", tgt.username],
        #   :include => :service_ticket)
        # pgts.each do |pgt|
        #   $LOG.debug("Deleting Proxy-Granting Ticket '#{pgt}' for user '#{pgt.service_ticket.username}'")
        #   pgt.destroy
        # end

        $LOG.debug("Deleting #{tgt.class.name.demodulize} '#{tgt}' for user '#{tgt.username}'")
        tgt.destroy
      end

      $LOG.info("User '#{tgt.username}' logged out.")
    else
      $LOG.warn("User tried to log out without a valid ticket-granting ticket.")
    end

    @message = {:type => 'confirmation', :message => "You have successfully logged out."}

    @message[:message] +=  "Please click on the following link to continue:" if @continue_url

    @log_out_of_services = true

    c = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR'] 
    @lt = generate_login_ticket(c)

    if @gateway && @service
      # I'm changing this to render the logout instead of redirecting
      # because the redirection wouldn't give a chance for the logout
      # iframe trick to log out of the main site. Since we also have
      # a default service now in the configuration, it isn't as important
      # for that to be preserved anyway - it will send them back to the
      # default service which is good for us too as we can then handle
      # the redirect based on the user account type automatically.

      # redirect @service, 303
      render :login
    elsif @continue_url
      render :logout
    else
      render :login
    end
  end

  def loginTicket
    $LOG.error("Tried to use login ticket dispenser with get method!")

    render :json => {:response => "To generate a login ticket, you must make a POST request."},status: :unprocessable_entity

    
  end
  
  # Renders a page with a login ticket (and only the login ticket)
  # in the response body.
  def loginTicketPost

    c = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']
    lt = LT::generate_login_ticket(c)

    $LOG.debug("Dispensing login ticket #{lt} to host #{(request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']).inspect}")

    @lt = lt.ticket

    @lt
  end

  def validate
    if ip_allowed?(request.ip)
      # required
      @service = clean_service_url(params['service'])
      @ticket = params['ticket']
      # optional
      @renew = params['renew']

      st, @error = validate_service_ticket(@service, @ticket)
      @success = st && !@error

      @username = st.username if @success
    else
      @success = false
      @error = Error.new(:INVALID_REQUEST, 'The IP address of this service has not been allowed')
    end

    if @error
    end 

    render :validate, :layout => false
  end
  
  def serviceValidate
    # force xml content type
    content_type 'text/xml', :charset => 'utf-8'

    if ip_allowed?(request.ip)
      # required
      @service = clean_service_url(params['service'])
      @ticket = params['ticket']
      # optional
      @pgt_url = params['pgtUrl']
      @renew = params['renew']

      st, @error = validate_service_ticket(@service, @ticket)
      @success = st && !@error

      if @success
        @username = st.username
        # if @pgt_url
        #   pgt = generate_proxy_granting_ticket(@pgt_url, st)
        #   @pgtiou = pgt.iou if pgt
        # end
        @extra_attributes = st.granted_by_tgt.extra_attributes || {}
      end
    else
      @success = false
      @error = Error.new(:INVALID_REQUEST, 'The IP address of this service has not been allowed')
    end

    status response_status_from_error(@error) if @error

    render :builder
  end
  
  # def proxyValidate
  #   # force xml content type
  #   content_type 'text/xml', :charset => 'utf-8'

  #   if ip_allowed?(request.ip)

  #     # required
  #     @service = clean_service_url(params['service'])
  #     @ticket = params['ticket']
  #     # optional
  #     @pgt_url = params['pgtUrl']
  #     @renew = params['renew']

  #     @proxies = []

  #     t, @error = validate_proxy_ticket(@service, @ticket)
  #     @success = t && !@error

  #     @extra_attributes = {}
  #     if @success
  #       @username = t.username

  #       # if t.kind_of? CASServer::Model::ProxyTicket
  #       #   @proxies << t.granted_by_pgt.service_ticket.service
  #       # end

  #       # if @pgt_url
  #       #   pgt = generate_proxy_granting_ticket(@pgt_url, t)
  #       #   @pgtiou = pgt.iou if pgt
  #       # end

  #       @extra_attributes = t.granted_by_tgt.extra_attributes || {}
  #     end
  #   else
  #     @success = false
  #     @error = Error.new(:INVALID_REQUEST, 'The IP address of this service has not been allowed')
  #   end

  #   status response_status_from_error(@error) if @error

  #   render :builder, :proxy_validate
  # end

  # def proxy
  #   # required
  #   @ticket = params['pgt']
  #   @target_service = params['targetService']

  #   pgt, @error = validate_proxy_granting_ticket(@ticket)
  #   @success = pgt && !@error

  #   if @success
  #     @pt = generate_proxy_ticket(@target_service, pgt)
  #   end

  #   status response_status_from_error(@error) if @error

  #   render :builder, :proxy
  # end

  # Helpers
  def response_status_from_error(error)
    case error.code.to_s
    when /^INVALID_/, 'BAD_PGT'
      422
    when 'INTERNAL_ERROR'
      500
    else
      500
    end
  end

  def serialize_extra_attribute(builder, key, value)
    if value.kind_of?(String)
      builder.tag! key, value
    elsif value.kind_of?(Numeric)
      builder.tag! key, value.to_s
    else
      builder.tag! key do
        builder.cdata! value.to_yaml
      end
    end
  end

  def compile_template(engine, data, options, views)
    super engine, data, options, @custom_views || views
  rescue Errno::ENOENT
    raise unless @custom_views
    super engine, data, options, views
  end

  def ip_allowed?(ip)
    require 'ipaddr'
  end

  helpers do
    def authenticated?
      @authenticated
    end

    def authenticated_username
      @authenticated_username
    end
  end
end
