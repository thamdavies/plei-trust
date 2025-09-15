class CreateBranchContractTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :branch_contract_types, id: false do |t|
      t.ksuid :id, primary_key: true
      t.references :branch, null: false, foreign_key: true, type: :string
      t.references :contract_type, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
