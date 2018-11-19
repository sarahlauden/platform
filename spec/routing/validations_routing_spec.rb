require "rails_helper"

RSpec.describe ValidationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/validations").to route_to("validations#index")
    end

    it "routes to #report" do
      expect(:get => "/validations/report").to route_to("validations#report")
    end
  end
end
