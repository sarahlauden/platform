RSpec.shared_examples "contact" do |contact_type|
  it { should have_one :contact_owner }

  describe '#owner' do
    let(:person) { create :person }
    let(:contact) { create contact_type }
    let(:contact_owner) { create :contact_owner, contact: contact, owner: person }
    
    before { contact_owner }
    subject { contact.owner }
    
    it { should eq(person)  }
  end
  
  describe '#owner=' do
    let(:person) { create :person }
    let(:contact) { create contact_type }
    
    before { contact.owner = person }
    subject { ContactOwner.last }

    it { expect(subject.contact).to eq(contact) }
    it { expect(subject.owner).to eq(person) }
  end
end