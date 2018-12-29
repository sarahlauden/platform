require 'rails_helper'

RSpec.describe ProgramMembership, type: :model do
  ##############
  # Associations
  ##############

  it { should belong_to :person }
  it { should belong_to :program }
  it { should belong_to :role }
end
