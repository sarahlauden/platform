class ContentTypeIsStringNotText < ActiveRecord::Migration[6.0]
  def change
    change_column :contents, :type, :string
  end
end
