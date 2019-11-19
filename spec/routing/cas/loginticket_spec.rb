require "rails_helper"
require "capybara_helper"
require "json"

RSpec.describe CasController, type: :routing do
  describe "RubyCAS routing" do
    describe "/loginTicket" do
      it "returns error when attempting a GET request" do 
        visit "/loginTicket"
        expect(page.body).to include("To generate a login ticket, you must make a POST request.")

        result = JSON.parse(page.body)
        expect(result).to include("response")
        expect(result['response']).to include("To generate a login ticket, you must make a POST request.") 
      end
      it "dispense a login ticket" do
        page.driver.post('/loginTicket')
        expect(page.body).to include('ticket')
        
        result = JSON.parse(page.body)
        expect(result).to include("ticket")
        expect(result['ticket']).to include("LT-") 
      end
    end
  end
end