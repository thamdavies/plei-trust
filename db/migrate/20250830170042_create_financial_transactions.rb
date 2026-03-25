class CreateFinancialTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_transactions, id: :uuid, default: 'uuidv7()' do |t|
      t.string :transaction_number, null: false
      t.date :transaction_date, null: false
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.references :transactable, null: true, polymorphic: true, index: false, type: :uuid
      t.string :transactable_type_code
      t.string :transaction_type_code, null: false
      t.decimal :amount, precision: 15, scale: 4, null: false
      t.string :description
      t.string :party_name
      t.string :reference_number
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.datetime :canceled_at, null: true
      t.text :notes

      t.timestamps
    end

    add_foreign_key :financial_transactions, :transaction_types, column: :transaction_type_code, primary_key: :code
    add_index :financial_transactions, :transaction_type_code
    add_index :financial_transactions, [ :transactable_type, :transactable_id ]
  end
end
