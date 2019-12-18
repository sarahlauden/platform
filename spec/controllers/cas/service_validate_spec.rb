require "rails_helper"
require "capybara_helper"
require "platform_helper"

include ERB::Util
include Rack::Utils

RSpec.describe CasController, type: :routing do
  describe "RubyCAS routing" do
    let(:valid_user) {{ email: 'platform_user', password: 'rspec_test' }}
    let(:host_servers) {{ join_server: "#{ENV['VCR_JOIN_SERVER']}", canvas_server: "#{ENV['VCR_CANVAS_SERVER']}" }}
  
    let(:return_service) { 'http://braven/' }
    let(:proxy_service) { 'http://bravenproxy/' }

    describe "/cas/serviceValidate" do
      let(:join_cassette) { "join_auth_valid" }
      let(:username) { valid_user[:email] }
      let(:password) { valid_user[:password] }

      context "without a login ticket" do 
        it "fails validate a service" do
          visit "/cas/serviceValidate"

          expect(page.body).to include("cas:authenticationFailure")
          expect(page.body).to include("INVALID_REQUEST")
          expect(page.body).to include("Ticket or service parameter was missing in the request.")
        end
      end

      context "with valid user" do
        before(:each) do
          visit "/cas/login?service=#{url_encode(return_service)}"
          VCR.use_cassette(join_cassette, :erb => host_servers) do
            fill_and_submit_login(username, password)
          end
        end

        context "with a valid login ticket" do 
          before(:each) do
            @params = parse_query(current_url, "&?,")
          end
          it "logs in successfully and validates service" do
            visit "/cas/serviceValidate?ticket=#{@params['ticket']}&service=#{url_encode(return_service)}"
            expect(page.body).to include("cas:authenticationSuccess>")
            expect(page.body).to include('platform_user')
          end

          it "logs in successfully and validates service with proxy url" do
            pending "Need to get proxy service set up"

            visit "/cas/serviceValidate?ticket=#{@params['ticket']}&service=#{url_encode(return_service)}&pgtUrl=#{proxy_service}"
            expect(page.body).to include("cas:authenticationSuccess>")
            expect(page.body).to include('platform_usr')
          end

          it "fails validate a service because no service specified" do
            # Attempt to validate the service
            visit "/cas/serviceValidate?ticket=#{@params['ticket']}"
            expect(page.body).to include("cas:authenticationFailure")
            expect(page.body).to include("INVALID_REQUEST")
            expect(page.body).to include("Ticket or service parameter was missing in the request.")
          end

          it "fails validate a service because ticket is consumed" do
            # Validate service ticket
            visit "/cas/serviceValidate?ticket=#{@params["ticket"]}&service=#{return_service}"

            # Should be consumed
            visit "/cas/serviceValidate?ticket=#{@params["ticket"]}&service=#{return_service}"

            expect(page.body).to include("cas:authenticationFailure")
            expect(page.body).to include("INVALID_TICKET")
            expect(page.body).to include("as already been used up")
          end
        end

      end
    end
  end
end