require "rails_helper"

RSpec.describe MajorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/majors").to route_to("majors#index")
    end

    it "routes to #new" do
      expect(:get => "/majors/new").to route_to("majors#new")
    end

    it "routes to #edit" do
      expect(:get => "/majors/1/edit").to route_to("majors#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/majors").to route_to("majors#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/majors/1").to route_to("majors#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/majors/1").to route_to("majors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/majors/1").to route_to("majors#destroy", :id => "1")
    end
  end
end
