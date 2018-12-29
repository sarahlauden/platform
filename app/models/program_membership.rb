class ProgramMembership < ApplicationRecord
  belongs_to :person
  belongs_to :program
  belongs_to :role
end
