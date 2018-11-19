require "rails_helper"

RSpec.describe PostalCodesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/postal_codes").to route_to("postal_codes#index")
    end

    it "routes to #show" do
      expect(:get => "/postal_codes/10001").to route_to("postal_codes#show", id: '10001')
    end
    
    it "routes to #search" do
      expect(:post => "postal_codes/search?code=10001").to route_to("postal_codes#search", code: '10001')
    end
    
    it "routes to #distance" do
      expect(:get => "/postal_codes/distance?from=10001&to=10002").to route_to("postal_codes#distance", from: '10001', to: '10002')
    end
  end
end
