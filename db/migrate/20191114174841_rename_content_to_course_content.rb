class RenameContentToCourseContent < ActiveRecord::Migration[6.0]
  def change
    rename_table :contents, :course_contents
  end
end
