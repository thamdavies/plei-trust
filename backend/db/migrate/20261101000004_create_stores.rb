class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :account, type: :uuid, null: false, index: false
      t.string :code, null: false
      t.string :name, null: false
      t.string :address
      t.string :phone
      t.string :status, null: false, default: "active"
      t.datetime :opened_at
      t.timestamps
    end

    add_index :stores, %i[account_id code], unique: true
  end
end
