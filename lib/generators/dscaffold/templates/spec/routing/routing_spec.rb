require "rails_helper"

RSpec.describe <%= plural_class_name %>Controller, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/<%= plural_name %>").to route_to("<%= plural_name %>#index")
    end

    it "routes to #show" do
      expect(:get => "/<%= plural_name %>/1").to route_to("<%= plural_name %>#show", id: "1")
    end

    it "routes to #new" do
      expect(:get => "/<%= plural_name %>/new").to route_to("<%= plural_name %>#new")
    end

    it "routes to #edit" do
      expect(:get => "/<%= plural_name %>/1/edit").to route_to("<%= plural_name %>#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/<%= plural_name %>").to route_to("<%= plural_name %>#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/<%= plural_name %>/1").to route_to("<%= plural_name %>#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/<%= plural_name %>/1").to route_to("<%= plural_name %>#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/<%= plural_name %>/1").to route_to("<%= plural_name %>#destroy", :id => "1")
    end
  end
end
