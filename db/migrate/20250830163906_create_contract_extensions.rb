class CreateContractExtensions < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_extensions, id: :uuid, default: 'uuidv7()' do |t|
      t.references :contract, null: false, foreign_key: true, type: :uuid
      t.date :from
      t.date :to
      t.integer :number_of_days
      t.text :content
      t.text :notes

      t.timestamps
    end
  end
end
