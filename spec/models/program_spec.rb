require 'rails_helper'

RSpec.describe Program, type: :model do
  #############
  # Validations
  #############
  
  it { should validate_presence_of :name }

  describe 'validating uniqueness' do
    before { create :program }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
