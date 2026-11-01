class CreateMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :memberships, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :account, type: :uuid, null: false, index: false
      t.references :user, type: :uuid, null: false, index: false
      t.string :status, null: false, default: "active"
      t.timestamps
    end

    add_index :memberships, %i[account_id user_id], unique: true
  end
end
