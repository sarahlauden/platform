class Person < ApplicationRecord
  # allow this model to own contacts - phones, e-mails, addresses
  include ContactOwnerMap
  
  has_many :program_memberships
  has_many :programs, through: :program_memberships
  has_many :roles, through: :program_memberships

  validates :first_name, :last_name, presence: true
  
  def full_name
    [first_name, last_name].join(' ')
  end
end
