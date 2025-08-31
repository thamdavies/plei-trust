class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.ksuid :id, primary_key: true
      t.string :email, null: false
      t.string :full_name, null: false
      t.references :branch, null: false, foreign_key: true, type: :string
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.string :phone
      t.string :status, default: "active"
      t.timestamps
    end

    add_index :users, :email
    add_index :users, :confirmation_token, unique: true
    add_index :users, :remember_token, unique: true
  end
end
