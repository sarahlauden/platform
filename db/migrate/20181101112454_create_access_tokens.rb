class CreateAccessTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :access_tokens do |t|
      t.string :name
      t.string :key

      t.timestamps
    end
    add_index :access_tokens, :name, unique: true
    add_index :access_tokens, :key, unique: true
  end
end
