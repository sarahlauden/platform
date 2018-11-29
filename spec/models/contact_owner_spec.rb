require 'rails_helper'

RSpec.describe ContactOwner, type: :model do
  ##############
  # Associations
  ##############

  it { should belong_to :contact }
  it { should belong_to :owner }
  
  #############
  # Validations
  #############

  it { should validate_presence_of :contact }
  it { should validate_presence_of :owner }
end
