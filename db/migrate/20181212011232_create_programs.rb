class CreatePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :programs do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :programs, :name, unique: true
  end
end
