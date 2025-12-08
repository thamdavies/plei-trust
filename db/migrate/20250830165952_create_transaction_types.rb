class CreateTransactionTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :transaction_types, id: false do |t|
      t.string :code, primary_key: true
      t.string :name
      t.text :description
      t.boolean :is_income

      t.timestamps
    end
  end
end
