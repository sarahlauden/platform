require 'rails_helper'

RSpec.describe User, type: :model do
  #############
  # Validations
  #############

  it { should validate_presence_of :email }
  
  describe 'validating uniqueness' do
    before { create :user }
    
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
  
  ###########
  # Callbacks
  ###########

  describe 'auto-admin' do
    it "sets admin when user has a bebraven.org email" do
      user = create :user, email: 'test@bebraven.org'
      expect(user.reload.admin).to be(true)
    end
    
    it "sets admin to false when user has a non-braven e-mail" do
      user = create :user, email: 'bob@example.com'
      expect(user.reload.admin).to be(false)
    end
  end
end
