require 'rails_helper'

RSpec.describe Major, type: :model do

  ##############
  # Associations
  ##############
  
  it { should belong_to :parent }
  it { should have_many :children }

  #############
  # Validations
  #############

  it { should validate_presence_of :name }
  
  describe "validating uniqueness" do
    subject { create :major }
    it { should validate_uniqueness_of :name }
  end
  
  ########
  # Scopes
  ########

  describe 'scope parentless' do
    let(:parent1) { create :major, parent_id: nil }
    let(:parent2) { create :major, parent_id: nil }
    
    let(:child1) { create :major, parent_id: parent1.id }
    let(:child2) { create :major, parent_id: parent2.id }
    
    before { parent1; parent2; child1; child2 }
    
    subject { Major.parentless }
    
    it { should include(parent1) }
    it { should include(parent2) }

    it { should_not include(child1) }
    it { should_not include(child2) }
  end
  
  ##################
  # Instance methods
  ##################
  
  describe '#all_parents' do
    let(:unrelated) { create :major }
    let(:grandparent) { create :major }
    let(:parent) { create :major, parent: grandparent }
    let(:child) { create :major, parent: parent }
    
    before { unrelated; child }
    
    subject { child.all_parents }
    
    it { should include(grandparent) }
    it { should include(parent) }
    it { should_not include(child) }
    it { should_not include(unrelated) }
  end
  
  describe '#all_children' do
    let(:unrelated) { create :major }
    let(:grandparent) { create :major }
    let(:parent) { create :major, parent: grandparent }
    let(:child) { create :major, parent: parent }
    
    before { unrelated; child }
    
    subject { grandparent.all_children }
    
    it { should include(child) }
    it { should include(parent) }
    it { should_not include(grandparent) }
    it { should_not include(unrelated) }
  end
end
