class Person < ApplicationRecord
  # allow this model to own contacts - phones, e-mails, addresses
  include ContactOwnerMap
  
  validates :first_name, :last_name, presence: true
  
  def full_name
    [first_name, last_name].join(' ')
  end
end
