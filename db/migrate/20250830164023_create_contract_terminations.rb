class CreateContractTerminations < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_terminations, id: false do |t|
      t.ksuid :id, primary_key: true
      t.references :contract, null: false, foreign_key: true, type: :string
      t.date :termination_date
      t.decimal :amount, precision: 15, scale: 2
      t.decimal :old_debt, precision: 15, scale: 2
      t.decimal :interest_amount, precision: 15, scale: 2
      t.decimal :other_amount, precision: 15, scale: 2
      t.decimal :total_amount, precision: 15, scale: 2
      t.references :processed_by, null: false, foreign_key: { to_table: :users }, type: :string

      t.timestamps
    end
  end
end
