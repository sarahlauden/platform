class CreatePostalCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :postal_codes do |t|
      t.string :code
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :msa_code
      t.string :state

      t.timestamps
    end
    add_index :postal_codes, :code
    add_index :postal_codes, :state
  end
end
