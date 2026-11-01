class CreateLoginAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :login_attempts, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string :normalized_username, null: false
      t.integer :failed_attempts, null: false, default: 0
      t.datetime :locked_until
      t.timestamps
    end

    add_index :login_attempts, :normalized_username, unique: true
  end
end
