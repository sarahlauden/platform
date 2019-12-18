require "rails_helper"
require "capybara_helper"
require "platform_helper"
require "json"
include ERB::Util
include Rack::Utils


RSpec.describe CasController, type: :routing do
  describe "RubyCAS routing" do
    let(:valid_user) {{ email: 'platform_user', password: 'rspec_test' }}
    let(:host_servers) {{ join_server: "#{ENV['VCR_JOIN_SERVER']}", canvas_server: "#{ENV['VCR_CANVAS_SERVER']}" }}
    let(:return_service) { 'http://braven/' }

    it "fails validate a service ticket because no ticket specified" do
      # Attempt to validate the ticket
      visit "/cas/validate"
      result = JSON.parse(page.body)
      expect(result).to include("error")
      expect(result["error"]).to include("code")
      expect(result["error"]).to include("message")
      expect(result["error"]["code"]).to eq("INVALID_REQUEST")
      expect(result["error"]["message"]).to include("Ticket or service parameter was missing in the request.")
    end

    describe "/cas/validate" do
      before(:each) do 
        visit "/cas/login?service=#{url_encode(return_service)}"
        VCR.use_cassette(join_cassette, :erb => host_servers) do
          fill_and_submit_login(username, password)
        end
      end

      context "when username and password are valid" do
        let(:join_cassette) { "join_auth_valid" }
        let(:username) { valid_user[:email] }
        let(:password) { valid_user[:password] }

        it "contain a ticket" do
          expect(current_url).to include("ticket")
        end

        context "has validate service ticket" do
          before(:each) do
            @params = parse_query(current_url, "&?,")
          end
          it "validate a service ticket" do
            # Validate the ticket
            visit "/cas/validate?ticket=#{@params["ticket"]}&service=#{return_service}"
            result = JSON.parse(page.body)
            expect(result).to include("success")
            expect(result).to include("user")
            expect(result["success"]).to eq(true)
            expect(result["user"]).to eq(username)
          end

          it "fails validate a service ticket because no service specified" do
            # Attempt to validate the ticket
            visit "/cas/validate?ticket=#{@params["ticket"]}"
            result = JSON.parse(page.body)
            expect(result).to include("error")
            expect(result["error"]).to include("code")
            expect(result["error"]).to include("message")
            expect(result["error"]["code"]).to eq("INVALID_REQUEST")
            expect(result["error"]["message"]).to include("Ticket or service parameter was missing in the request.")
          end

          it "fails validate a service ticket because it is consumed" do
            # Validate service ticket
            visit "/cas/validate?ticket=#{@params["ticket"]}&service=#{return_service}"
  
            # Attempt to validate consumed service ticket
            visit "/cas/validate?ticket=#{@params["ticket"]}&service=#{return_service}"
            result = JSON.parse(page.body)
            expect(result).to include("error")
            expect(result["error"]).to include("code")
            expect(result["error"]).to include("message")
            expect(result["error"]["code"]).to eq("INVALID_TICKET")
            expect(result["error"]["message"]).to include("has already been used up")
          end
        end
      end
    end
  end
end