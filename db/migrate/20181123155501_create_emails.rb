class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :value, null: false

      t.timestamps
    end
    add_index :emails, :value, unique: true
  end
end
