class CreateJoinTableContactOwner < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts_owners, id: false do |t|
      t.integer :contact_id
      t.integer :contact_type

      t.integer :owner_id
      t.integer :owner_type

      t.index [:contact_id, :contact_type]
      t.index [:owner_id, :owner_type]
    end
  end
end
