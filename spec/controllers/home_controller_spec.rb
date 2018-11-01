require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create :user, admin: true }
  
  before do
    sign_in user
  end

  describe "GET #welcome" do
    it "returns http success" do
      get :welcome
      expect(response).to have_http_status(:success)
    end
  end

end
