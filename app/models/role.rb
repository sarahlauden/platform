class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  
  def to_show
    attributes.slice('name')
  end
end
