require "rails_helper"

RSpec.describe AccessTokensController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/access_tokens").to route_to("access_tokens#index")
    end

    it "routes to #new" do
      expect(:get => "/access_tokens/new").to route_to("access_tokens#new")
    end

    it "routes to #edit" do
      expect(:get => "/access_tokens/1/edit").to route_to("access_tokens#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/access_tokens").to route_to("access_tokens#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/access_tokens/1").to route_to("access_tokens#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/access_tokens/1").to route_to("access_tokens#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/access_tokens/1").to route_to("access_tokens#destroy", :id => "1")
    end
  end
end
