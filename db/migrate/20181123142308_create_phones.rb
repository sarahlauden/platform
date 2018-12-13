class CreatePhones < ActiveRecord::Migration[5.2]
  def change
    create_table :phones do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :phones, :value, unique: true
  end
end
