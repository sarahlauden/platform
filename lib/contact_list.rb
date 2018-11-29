class ContactList < Array
  attr_accessor :owner
  
  class << self
    def create list, owner
      new_list = new(list)
      new_list.owner = owner
      
      new_list
    end
  end
  
  def << contact
    ContactOwner.find_or_create_by(contact: contact, owner: @owner)
  end
end
