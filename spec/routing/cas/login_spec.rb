require "rails_helper"
require "capybara_helper"

VALID_USERNAME = 'platform_user'
VALID_PASSWORD = 'rspec_test'

RSpec.describe CasController, type: :routing do
  describe 'RubyCAS routing' do
    describe "/login" do
      it "logs in successfully without a service url" do
        # Go to log in page to sigin in
        visit "/login"

        # Input login credentials
        fill_in 'username', :with => VALID_USERNAME
        fill_in 'password', :with => VALID_PASSWORD
        
        # Make sure there is a login button that can be clicked
        # Capybara with Selenium can have problems with javascript
        expect(page).to have_button('login-submit', disabled: false)
        click_button 'login-submit'

        # Ensure that the login was successful
        expect(page).to have_content("You have successfully logged in")
      end
    end
  end
end