class CreateFinancialTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_transactions, id: false do |t|
      t.ksuid :id, primary_key: true
      t.string :transaction_number, null: false
      t.date :transaction_date, null: false
      t.references :transaction_type, null: false, foreign_key: true, type: :string
      t.references :contract, null: false, foreign_key: true, type: :string
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :description
      t.string :reference_number
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :string

      t.timestamps
    end
  end
end
