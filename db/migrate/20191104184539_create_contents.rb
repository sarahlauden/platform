class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.string :title
      t.text :body
      t.datetime :published_at
      t.text :type

      t.timestamps
    end
  end
end
