require 'contact_list'

# include in models that own contacts
module ContactOwnerMap
  extend ActiveSupport::Concern

  included do
    has_many :contact_owners, as: :owner

    has_many :emails, through: :contact_owners, source: :contact, source_type: 'Email'
    has_many :phones, through: :contact_owners, source: :contact, source_type: 'Phone'
    has_many :addresses, through: :contact_owners, source: :contact, source_type: 'Address'
  end
  
  def contacts
    return @contacts if defined?(@contacts)
    @contacts = ContactList.create(contact_owners.map(&:contact), self)
  end
end