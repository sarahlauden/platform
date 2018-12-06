class Email < ApplicationRecord
  # allow this model to be used as a contact
  include OwnerContactMap
  
  validates :value, presence: true, uniqueness: {case_sensitive: false}, format: { with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/i }
  
  before_validation :downcase
  
  def as_json options={}
    attributes.slice('value')
  end
  
  private
  
  def downcase
    return if value.blank?
    self.value = value.downcase
  end
end
