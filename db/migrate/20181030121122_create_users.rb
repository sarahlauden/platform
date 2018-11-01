class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :admin, default: false

      t.timestamps
    end
    add_index :users, :email
    add_index :users, :admin
  end
end
