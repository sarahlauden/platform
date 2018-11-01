require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  ############
  # Validation
  ############
  
  describe 'validation' do
    before do
      # disable auto-key generation to test validation
      allow_any_instance_of(AccessToken).to receive(:generate_key).and_return(nil)
    end
  
    it { should validate_presence_of :name }
    it { should validate_presence_of :key }
  
    describe 'uniqueness' do
      before { create :access_token }
    
      it { should validate_uniqueness_of(:name).case_insensitive }
      it { should validate_uniqueness_of(:key).case_insensitive }
    end
  
    describe '16-digit hexadecimal key format' do
      it { should allow_value('0000000000000001').for(:key) }
      it { should allow_value('0123456789abcdef').for(:key) }
    
      it { should_not allow_value('1').for(:key)}
      it { should_not allow_value('000000000000000x').for(:key)}
    end
  end
  
  ###########
  # Callbacks
  ###########

  describe 'generating key on create' do
    let(:access_token) { AccessToken.create name: 'Name', key: key }
    
    subject { access_token.key }
    
    describe 'when valid key is provided' do
      let(:key) { '0000111122223333' }
      it { should eq(key) }
    end
    
    describe 'when invalid key provided' do
      let(:key) { '1' }
      it { should_not eq(key) }
      it { should match(AccessToken::VALID_KEY) }
    end
    
    describe 'when key is not provided' do
      let(:key) { nil }
      it { should match(AccessToken::VALID_KEY) }
    end
  end
  
  ###############
  # Class methods
  ###############

  describe 'generate_key' do
    subject { AccessToken.generate_key }
    
    it { should match(AccessToken::VALID_KEY) }
    
    it "generates a new key each time" do
      attempts = 100
      keys = []
      
      attempts.times{ keys << AccessToken.generate_key }
      
      expect(keys.uniq.size).to eq(attempts)
    end
  end
end
