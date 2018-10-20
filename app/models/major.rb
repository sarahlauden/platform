class Major < ApplicationRecord
  belongs_to :parent, class_name: 'Major', optional: true
  has_many :children, class_name: 'Major', foreign_key: 'parent_id'
  
  validates :name, presence: true, uniqueness: true
  
  default_scope { order(name: :asc) }
  
  scope :parentless, -> { where(parent_id: nil) }

  def all_parents
    return [] if parent.nil?
    ([parent] + parent.all_parents).compact
  end
  
  def all_children
    return [] if children.empty?
    (children + children.map(&:all_children).flatten).compact
  end
end
