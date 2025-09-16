class CreateFinancialTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_transactions, id: :uuid, default: 'uuidv7()' do |t|
      t.string :transaction_number, null: false
      t.date :transaction_date, null: false
      t.references :transaction_type, null: false, foreign_key: true, type: :uuid
      t.references :contract, null: false, foreign_key: true, type: :uuid
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :description
      t.string :reference_number
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
