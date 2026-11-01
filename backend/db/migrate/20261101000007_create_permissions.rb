class CreatePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :permissions, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.uuid :parent_id
      t.string :key, null: false
      t.string :label, null: false
      t.string :category, null: false
      t.boolean :assignable, null: false, default: false
      t.integer :sort_order, null: false, default: 0
      t.timestamps
    end

    add_index :permissions, :key, unique: true
    add_index :permissions, :parent_id
  end
end
