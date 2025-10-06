class CreateContractInterestPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_interest_payments, id: :uuid, default: 'uuidv7()' do |t|
      t.references :contract, null: false, foreign_key: true, type: :uuid
      t.date :from
      t.date :to
      t.integer :number_of_days
      t.decimal :amount, precision: 15, scale: 2
      t.decimal :other_amount, precision: 15, scale: 2
      t.decimal :total_amount, precision: 15, scale: 2
      t.decimal :total_paid, precision: 15, scale: 2
      t.string :payment_status, default: 'unpaid'
      t.text :note

      t.timestamps
    end
  end
end
