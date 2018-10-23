class Location < ApplicationRecord
  has_and_belongs_to_many :parents,  class_name: 'Location', join_table: 'location_relationships', foreign_key: 'parent_id', association_foreign_key: 'child_id', dependent: :destroy
  has_and_belongs_to_many :children, class_name: 'Location', join_table: 'location_relationships', foreign_key: 'child_id', association_foreign_key: 'parent_id', dependent: :destroy

  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: true
  
  default_scope { order(name: :asc) }
  
  def parent_names
    parents.pluck(:name)
  end

  def all_parents existing_parents=[]
    return [] if parents.empty?
    
    more_parents = parents + (parents - existing_parents).map do |p|
      p.all_parents(existing_parents + parents)
    end
    
    more_parents.flatten.compact
  end
  
  def all_children existing_children=[]
    return [] if children.empty?

    more_children = children + (children - existing_children).map do |c|
      c.all_children(existing_children + children)
    end
    
    more_children.flatten.compact
  end
end
