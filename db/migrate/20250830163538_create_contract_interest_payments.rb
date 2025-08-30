class CreateContractInterestPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_interest_payments, id: false do |t|
      t.ksuid :id, primary_key: true
      t.references :contract, null: false, foreign_key: true, type: :string
      t.date :from
      t.date :to
      t.integer :number_of_days
      t.decimal :amount, precision: 15, scale: 2
      t.decimal :other_amount, precision: 15, scale: 2
      t.decimal :total_amount, precision: 15, scale: 2
      t.decimal :total_paid, precision: 15, scale: 2
      t.string :payment_status, default: 'unpaid'
      t.text :notes
      t.references :processed_by, null: false, foreign_key: { to_table: :users }, type: :string
      t.string :status

      t.timestamps
    end
  end
end
