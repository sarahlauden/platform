require 'rails_helper'

RSpec.describe Location, type: :model do
  ##############
  # Associations
  ##############
  
  it { should have_and_belong_to_many :parents }
  it { should have_and_belong_to_many :children }
  
  #############
  # Validations
  #############
  
  it { should validate_presence_of :code }
  it { should validate_presence_of :name }
  
  describe 'validating uniqueness' do
    before { create :location }
    
    it { should validate_uniqueness_of(:code).case_insensitive }
    it { should validate_uniqueness_of(:name) }
  end
  
  ##################
  # Instance methods
  ##################

  describe 'ancestry' do
    let(:unrelated) { create :location }
    let(:grandparent) { create :location }
    let(:parent) { create :location }
    let(:child) { create :location }
    let(:sibling) { create :location }
    let(:uncle) { create :location }
    let(:cousin) { create :location }
  
    before do
      grandparent.children << parent
      grandparent.children << uncle
      
      parent.children << child
      parent.children << sibling
      
      uncle.children << cousin
      
      unrelated
    end
  
    describe '#all_parents' do
      subject { child.all_parents }
    
      it { should_not include(child) }
      it { should include(parent) }
      it { should include(grandparent) }
      it { should_not include(uncle) }
      it { should_not include(sibling) }
      it { should_not include(cousin) }
      it { should_not include(unrelated) }
    end
  
    describe '#all_children' do
      subject { grandparent.all_children }
    
      it { should include(child) }
      it { should include(parent) }
      it { should include(uncle) }
      it { should include(sibling) }
      it { should include(cousin) }
      it { should_not include(grandparent) }
      it { should_not include(unrelated) }
    end
  end
end
