class AddCityToPostalCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :postal_codes, :city, :string
  end
end
