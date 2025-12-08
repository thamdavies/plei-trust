class CreateAssetSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_settings, id: :uuid, default: 'uuidv7()' do |t|
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.string :asset_code
      t.string :asset_name
      t.string :status, default: "active"
      t.string :interest_calculation_method, default: "monthly"
      t.decimal :default_loan_amount, precision: 12, scale: 4
      t.float :default_interest_rate
      t.integer :interest_period
      t.integer :default_contract_term
      t.integer :liquidation_after_days
      t.boolean :collect_interest_in_advance, default: false
      t.decimal :contract_initiation_fee, precision: 12, scale: 4
      t.float :asset_appraisal_fee
      t.float :management_fee
      t.float :asset_rental_fee
      t.float :early_termination_fee

      t.timestamps
    end
  end
end
