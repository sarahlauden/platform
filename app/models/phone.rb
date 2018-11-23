class Phone < ApplicationRecord
  validates :value, presence: true, uniqueness: true
  
  validate :value_must_contain_ten_digits
  
  before_validation :format_value
  
  private
  
  def format_value
    return if value.blank?
    return unless has_required_digits?
    
    digits = value.gsub(only_digits, '')
    self.value = [digits[0,3], digits[3,3], digits[6,4]].join('-')
  end
  
  def value_must_contain_ten_digits
    unless has_required_digits?
      errors.add(:value, "must contain exactly ten digits")
    end
  end
  
  def only_digits
    /[^0-9]/
  end
  
  def required_digits
    10
  end
  
  def has_required_digits?
    return false if value.blank?
    value.gsub(only_digits, '').size == required_digits
  end
end
