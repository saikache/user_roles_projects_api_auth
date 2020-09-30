class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.string :permission_type
      t.boolean :can_new, default: false
      t.boolean :can_edit, default: false
      t.boolean :can_delete, default: false

      t.timestamps
    end
  end
end
