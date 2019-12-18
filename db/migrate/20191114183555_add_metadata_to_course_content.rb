class AddMetadataToCourseContent < ActiveRecord::Migration[6.0]
  def change
    add_column :course_contents, :course_id, :integer
    add_column :course_contents, :secondary_id, :string
    add_column :course_contents, :course_name, :string
  end
end
