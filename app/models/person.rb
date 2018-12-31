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
  
  def start_membership program_id, role_id
    find_membership(program_id, role_id) ||
      program_memberships.create(program_id: program_id, role_id: role_id, start_date: Date.today)
  end
  
  def end_membership program_id, role_id
    if program_membership = find_membership(program_id, role_id)
      program_membership.update! end_date: Date.yesterday
    else
      return false
    end
  end
  
  def update_membership program_id, old_role_id, new_role_id
    return if old_role_id == new_role_id
    
    end_membership(program_id, old_role_id)
    start_membership(program_id, new_role_id)
  end
  
  def find_membership program_id, role_id
    program_memberships.find_by(program_id: program_id, role_id: role_id)
  end
end
