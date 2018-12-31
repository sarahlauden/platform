class DeuniquifyProgramMembershipMasterIndex < ActiveRecord::Migration[5.2]
  def change
    index_name = "program_memberships_index"
    
    remove_index :program_memberships, name: index_name
    add_index :program_memberships, ["person_id", "program_id", "role_id"], name: index_name
  end
end
