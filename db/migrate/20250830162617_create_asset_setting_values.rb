class CreateAssetSettingValues < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_values, primary_key: [ :contract_id, :asset_setting_attribute_id ] do |t|
      t.uuid :contract_id, null: false
      t.uuid :asset_setting_attribute_id, null: false
      t.string :value
      t.timestamps
    end

    add_foreign_key :asset_setting_values, :contracts, column: :contract_id
    add_foreign_key :asset_setting_values, :asset_setting_attributes, column: :asset_setting_attribute_id

    add_index :asset_setting_values, [ :contract_id, :asset_setting_attribute_id ], unique: true
  end
end
