class CreateInterestRateHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :interest_rate_histories, id: :uuid, default: 'uuidv7()' do |t|
      t.date :effective_date, null: false
      t.float :interest_rate, null: false
      t.text :description
      t.references :processed_by, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
