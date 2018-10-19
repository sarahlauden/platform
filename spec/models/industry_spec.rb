require 'rails_helper'

RSpec.describe Industry, type: :model do
  #############
  # Validations
  #############

  it { should validate_presence_of :name}
  
  describe 'validating uniqueness' do
    before { create :industry }
    
    it { should validate_uniqueness_of :name }
  end
end
