class CreateMajors < ActiveRecord::Migration[5.2]
  def change
    create_table :majors do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_index :majors, :name
    add_index :majors, :parent_id
  end
end
