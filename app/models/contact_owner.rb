class ContactOwner < ApplicationRecord
  belongs_to :contact, polymorphic: true
  belongs_to :owner,   polymorphic: true
  
  validates :contact, :owner, presence: true
end
