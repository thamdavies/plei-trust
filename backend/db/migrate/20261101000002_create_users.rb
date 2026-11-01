class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :status, null: false, default: "active"
      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end
