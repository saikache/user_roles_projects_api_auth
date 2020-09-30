class AddRoleIdToPermissions < ActiveRecord::Migration[5.2]
  def change
    add_column :permissions, :role_id, :integer
    add_index :permissions, :role_id
  end
end
