require 'digest/md5'

class AccessToken < ApplicationRecord
  VALID_KEY = /\A[0-9a-f]{16}\z/i
  
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :key, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_KEY}
  
  before_validation :generate_key, if: :key_invalid?
  
  class << self
    def generate_key
      Digest::MD5.hexdigest([Time.now, rand].join(','))[0,16]
    end
  end
  
  private
  
  def generate_key
    self.key = self.class.generate_key
  end
  
  def key_invalid?
    key !~ VALID_KEY
  end
end
