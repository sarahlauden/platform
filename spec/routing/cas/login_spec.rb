require "rails_helper"
require "capybara_helper"

include ERB::Util
include Rack::Utils


VALID_USERNAME = "platform_user"
VALID_PASSWORD = "rspec_test"

INVALID_USERNAME = "bad_user"
INVALID_PASSWORD = "bad_pass"

RETURN_SERVICE = "http://braven/"

RSpec.describe CasController, type: :routing do
  describe "RubyCAS routing" do
    describe "/login" do
      it "logs in successfully without a service url" do
        # Go to log in page to sigin in
        visit "/login"

        # Input login credentials
        fill_in "username", :with => VALID_USERNAME
        fill_in "password", :with => VALID_PASSWORD
        
        # Make sure there is a login button that can be clicked
        # Capybara with Selenium can have problems with javascript
        expect(page).to have_button("login-submit", disabled: false)
        click_button "login-submit"

        # Ensure that the login was successful
        expect(page).to have_content("You have successfully logged in")
      end

      it "fails to log in with bad credentials" do
        # Go to log in page to sigin in
        visit "/login"

        # Input login credentials
        fill_in "username", :with => INVALID_USERNAME
        fill_in "password", :with => INVALID_PASSWORD
        
        # Make sure there is a login button that can be clicked
        # Capybara with Selenium can have problems with javascript
        expect(page).to have_button("login-submit", disabled: false)
        click_button "login-submit"

        # Ensure that the login was failed
        expect(page).to have_content("Incorrect username or password")
      end
      
      it "fails to log in without input" do
        visit "/login"
        
        click_button "login-submit"

        expect(page).to have_content("Incorrect username or password")
      end

      it "logs in successfully and redirects to service url" do
        # Go to log in page to sigin in
        visit "/login?service=#{url_encode(RETURN_SERVICE)}"

        # Input login credentials
        fill_in "username", :with => VALID_USERNAME
        fill_in "password", :with => VALID_PASSWORD
        
        # Make sure there is a login button that can be clicked
        # Capybara with Selenium can have problems with javascript
        expect(page).to have_button("login-submit", disabled: false)
        click_button "login-submit"

        # Ensure that the login was successful
        expect(current_url).to include(RETURN_SERVICE)
        expect(current_url).to include("ticket")
      end

      it "validates existing tickets and generates new one" do
        visit "/login?service=#{url_encode(RETURN_SERVICE)}"
        expect(page).to have_button("login-submit", disabled: false)

        fill_in "username", :with => VALID_USERNAME
        fill_in "password", :with => VALID_PASSWORD
        click_button "login-submit"

        expect(current_url).to include(RETURN_SERVICE)
        expect(current_url).to include("ticket")

        # Get current ticket to check against next generated ticket
        @params = parse_query(current_url, "&?,")
        expect(@params).to include("ticket")

        # Revisit login page to validate current ticket
        visit "/login?service=#{url_encode(RETURN_SERVICE)}"

        # New ticket should be generated
        expect(current_url).not_to include(@params["ticket"])
      end
    end
  end
end