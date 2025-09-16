class CreateContractTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_types, id: :uuid, default: 'uuidv7()' do |t|
      t.string :code
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
