class CreateLocationRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :location_relationships, id: false do |t|
      t.integer :parent_id
      t.integer :child_id
    end
    
    add_index :location_relationships, [:parent_id, :child_id]
    add_index :location_relationships, :parent_id
    add_index :location_relationships, :child_id
  end
end
