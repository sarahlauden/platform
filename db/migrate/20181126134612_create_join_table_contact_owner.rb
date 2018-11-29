class CreateJoinTableContactOwner < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_owners do |t|
      t.integer :contact_id
      t.string :contact_type

      t.integer :owner_id
      t.string :owner_type

      t.index [:contact_id, :contact_type]
      t.index [:owner_id, :owner_type]
    end
  end
end
