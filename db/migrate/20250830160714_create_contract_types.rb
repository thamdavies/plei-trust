class CreateContractTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_types, id: false do |t|
      t.ksuid :id, primary_key: true
      t.string :code
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
