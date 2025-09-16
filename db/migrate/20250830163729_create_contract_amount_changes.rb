class CreateContractAmountChanges < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_amount_changes, id: :uuid, default: 'uuidv7()' do |t|
      t.references :contract, null: false, foreign_key: true, type: :uuid
      t.date :action_date
      t.string :type
      t.decimal :amount, precision: 15, scale: 2
      t.text :notes
      t.references :processed_by, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
