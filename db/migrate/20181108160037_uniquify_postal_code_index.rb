class UniquifyPostalCodeIndex < ActiveRecord::Migration[5.2]
  def up
    remove_index :postal_codes, :code
    add_index :postal_codes, :code, unique: true
  end
  
  def down
    remove_index :postal_codes, :code
    add_index :postal_codes, :code
  end
end
