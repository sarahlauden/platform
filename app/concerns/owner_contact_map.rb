# include in contacts that are owned
module OwnerContactMap
  extend ActiveSupport::Concern
  
  included do
    has_one :contact_owner, as: :contact
  end
  
  def owner
    contact_owner.owner
  end
  
  def owner= new_owner
    ContactOwner.create contact: self, owner: new_owner
  end
end
