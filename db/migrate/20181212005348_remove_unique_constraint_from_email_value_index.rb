class RemoveUniqueConstraintFromEmailValueIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :emails, :value
    add_index :emails, :value
  end
end
