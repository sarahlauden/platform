require 'rails_helper'

RSpec.describe Person, type: :model do
  #############
  # Validations
  #############

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  
  ##################
  # Instance methods
  ##################

  describe 'full_name' do
    let(:person) { build :person, first_name: 'Bob', last_name: 'Smith' }
    
    subject { person.full_name }
    it { should eq('Bob Smith') }
  end
end
