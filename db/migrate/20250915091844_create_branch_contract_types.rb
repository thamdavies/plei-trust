class CreateBranchContractTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :branch_contract_types, id: :uuid, default: 'uuidv7()' do |t|
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.references :contract_type, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
