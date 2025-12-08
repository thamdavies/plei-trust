class CreateContractReminders < ActiveRecord::Migration[8.1]
  def change
    create_table :contract_reminders, id: :uuid, default: 'uuidv7()' do |t|
      t.references :contract, null: false, foreign_key: true, type: :uuid
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.datetime :date
      t.text :note
      t.string :reminder_type, null: false
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
