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
  
  ##################
  # Instance methods
  ##################

  describe '#to_show' do
    let(:program) { build :program, name: 'Program' }
    subject { program.to_show }
    
    it { should eq({'name' => 'Program'}) }
  end
end
