class CreateStoreMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :store_memberships, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :account, type: :uuid, null: false, index: false
      t.references :membership, type: :uuid, null: false, index: false
      t.references :store, type: :uuid, null: false, index: false
      t.references :role, type: :uuid, null: false, index: false
      t.timestamps
    end

    add_index :store_memberships, %i[membership_id store_id], unique: true
    add_index :store_memberships, %i[account_id store_id]
  end
end
