class CreateRolePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :role_permissions, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :account, type: :uuid, null: false, index: false
      t.references :role, type: :uuid, null: false, index: false
      t.references :permission, type: :uuid, null: false, index: false
      t.timestamps
    end

    add_index :role_permissions, %i[role_id permission_id], unique: true
    add_index :role_permissions, %i[account_id permission_id]
  end
end
