class CreateApiTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :api_tokens, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :account, type: :uuid, null: false, index: false
      t.references :user, type: :uuid, null: false, index: false
      t.references :membership, type: :uuid, null: false, index: false
      t.string :token_digest, null: false
      t.datetime :expires_at, null: false
      t.datetime :revoked_at
      t.datetime :last_used_at
      t.timestamps
    end

    add_index :api_tokens, :token_digest, unique: true
    add_index :api_tokens, %i[account_id user_id]
    add_index :api_tokens, %i[membership_id expires_at]
  end
end
