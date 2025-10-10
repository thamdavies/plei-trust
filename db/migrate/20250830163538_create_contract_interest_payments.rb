class CreateContractInterestPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_interest_payments, id: :uuid, default: 'uuidv7()' do |t|
      t.references :contract, null: false, foreign_key: true, type: :uuid
      t.date :from
      t.date :to
      # flag để nhận biết có sử dụng chức năng đóng lãi tuỳ biến theo ngày hay không
      t.boolean :custom_payment, default: false
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
