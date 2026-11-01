class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :account, type: :uuid, null: false, index: false
      t.string :name, null: false
      t.string :scope, null: false
      t.string :system_key
      t.timestamps
    end

    add_index :roles, %i[account_id name], unique: true
    add_index :roles, %i[account_id system_key], unique: true
  end
end
