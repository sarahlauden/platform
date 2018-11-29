require 'state_abbreviations'

class Address < ApplicationRecord
  # allow this model to be used as a contact
  include OwnerContactMap
  
  validates :line1, :city, :state, :zip, presence: true
  validates :state, format: {with: /\A[A-Z]{2}\z/}
  
  before_validation :set_city, :set_state
  
  private
  
  def set_city
    return unless city.blank?
    self.city = postal_code.city if postal_code
  end
  
  def set_state
    if state.blank?
      self.state = postal_code.state if postal_code
    elsif state !~ /\A[A-Z]{2}\z/
      StateAbbreviations::PATTERNS.each do |abbr, pattern|
        if state =~ pattern
          self.state = abbr
          return
        end
      end
    end
  end
  
  def postal_code
    return @postal_code if defined?(@postal_code)
    @postal_code = PostalCode.find_by(code: zip)
  end
end
