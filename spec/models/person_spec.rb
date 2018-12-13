require 'rails_helper'

RSpec.describe Person, type: :model do
  ##############
  # Associations
  ##############

  it { should have_many :contact_owners }
  it { should have_many(:emails).through(:contact_owners) }
  it { should have_many(:phones).through(:contact_owners) }
  it { should have_many(:addresses).through(:contact_owners) }

  #############
  # Validations
  #############

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  
  ###########
  # Factories
  ###########

  describe 'person_with_contacts' do
    let(:person) { create :person_with_contacts }
    
    subject { person }
    
    it { expect(subject.phones.count).to eq(2) }
    it { expect(subject.emails.count).to eq(3) }
    it { expect(subject.addresses.count).to eq(3) }
  end
  
  ##################
  # Instance methods
  ##################

  describe 'full_name' do
    let(:person) { build :person, first_name: 'Bob', last_name: 'Smith' }
    
    subject { person.full_name }
    it { should eq('Bob Smith') }
  end
  
  describe 'contacts' do
    let(:person) { create :person }
    let(:email) { create :email }
    let(:phone) { create :phone }
    let(:address) { create :address }
    
    before do
      person.emails << email
      person.phones << phone
      person.addresses << address
    end
    
    subject { person.contacts }
    
    it { should be_an(Array) }
    
    it { should include(email) }
    it { should include(phone) }
    it { should include(address) }
  end
end
