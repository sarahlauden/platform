class CreateProgramMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :program_memberships do |t|
      t.integer :person_id, null: false
      t.integer :program_id, null: false
      t.integer :role_id, null: false
      
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :program_memberships, :person_id
    add_index :program_memberships, :program_id
    add_index :program_memberships, :role_id
    
    add_index :program_memberships, [:person_id, :program_id, :role_id], unique: true, name: 'program_memberships_index'
  end
end
