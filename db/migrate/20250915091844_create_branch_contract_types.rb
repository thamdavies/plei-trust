class CreateBranchContractTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :branch_contract_types, id: :uuid, default: 'uuidv7()' do |t|
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.string :contract_type_code, null: false
      t.timestamps
    end

    add_foreign_key :branch_contract_types, :contract_types, column: :contract_type_code, primary_key: :code
  end
end
