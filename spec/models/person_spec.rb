require 'rails_helper'

RSpec.describe Person, type: :model do
  ##############
  # Associations
  ##############

  it { should have_many :contact_owners }
  it { should have_many(:emails).through(:contact_owners) }
  it { should have_many(:phones).through(:contact_owners) }
  it { should have_many(:addresses).through(:contact_owners) }

  it { should have_many :program_memberships }
  it { should have_many(:programs).through(:program_memberships) }
  it { should have_many(:roles).through(:program_memberships) }

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
  
  describe '#start_membership(program_id, role_id)' do
    let!(:person) { create :person }
    let!(:program) { create :program }
    let!(:role) { create :role }
    
    subject { person.start_membership(program.id, role.id) }
    
    describe "when membership doesn't already exist" do
      it { expect(subject.person).to eq(person) }
      it { expect(subject.program).to eq(program) }
      it { expect(subject.role).to eq(role) }
      it { expect(subject.start_date).to eq(Date.today) }
      it { expect(subject.end_date).to eq(nil) }
    end
    
    describe 'when membership aleady exists' do
      let(:start_date) { Date.today - 100 }
      let!(:program_membership) { create :program_membership, person: person, program: program, role: role, start_date: start_date }
      
      it { should eq(program_membership) }
      
      it { expect(subject.person).to eq(person) }
      it { expect(subject.program).to eq(program) }
      it { expect(subject.role).to eq(role) }
      it { expect(subject.start_date).to eq(start_date) }
      it { expect(subject.end_date).to eq(nil) }
    end
  end
  
  describe '#end_membership(program_id, role_id)' do
    let!(:person) { create :person }
    let!(:program) { create :program }
    let!(:role) { create :role }
    let(:start_date) { Date.today - 100 }
    
    subject { person.end_membership(program.id, role.id) }
  
    describe 'when membership exists' do
      let!(:program_membership) { create :program_membership, person: person, program: program, role: role, start_date: start_date }
    
      it { should be_truthy }
      it { subject; expect(program_membership.reload.end_date).to eq(Date.yesterday) }
    end
    
    describe 'when membership does not exist' do
      it { should be_falsey }
    end
  end
  
  describe '#update_membership(program_id, old_role_id, new_role_id)' do
    let!(:person) { create :person }
    let!(:program) { create :program }
    let!(:old_role) { create :role, name: 'Old' }
    let!(:new_role) { create :role, name: 'New' }
    let!(:start_date) { Date.today - 100 }
    
    subject { person.update_membership(program.id, old_role.id, new_role.id) }

    describe 'when membership with old role exists' do
      let!(:program_membership) { create :program_membership, person: person, program: program, role: old_role, start_date: start_date }
    
      it { should be_truthy }
      
      it "ends the program membership with the old role" do
        expect(person).to receive(:end_membership).with(program.id, old_role.id)
        subject
      end
      
      it "creates a program membership with the new role" do
        expect(person).to receive(:start_membership).with(program.id, new_role.id)
        subject
      end
    end
    
    describe 'when membership does not exist' do
      it "attempts to end membership without breaking" do
        expect(person).to receive(:end_membership).with(program.id, old_role.id)
        subject
      end
      
      it "creates a program membership with the new role" do
        expect(person).to receive(:start_membership).with(program.id, new_role.id)
        subject
      end
    end
    
    describe 'when old role and new role are the same' do
      let(:new_role) { old_role }
      let!(:program_membership) { create :program_membership, person: person, program: program, role: old_role, start_date: start_date }
      
      it "does NOT attempt to end membership" do
        expect(person).to_not receive(:end_membership).with(program.id, old_role.id)
        subject
      end
      
      it "does NOT attempt to create a new membership" do
        expect(person).to_not receive(:start_membership).with(program.id, new_role.id)
        subject
      end
    end
  end
end
