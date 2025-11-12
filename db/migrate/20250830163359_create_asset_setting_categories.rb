class CreateAssetSettingCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_categories, id: :uuid, default: 'uuidv7()' do |t|
      t.references :asset_setting, null: false, foreign_key: true, type: :uuid
      t.string :contract_type_code, null: false
      t.timestamps
    end

    add_foreign_key :asset_setting_categories, :contract_types, column: :contract_type_code, primary_key: :code
  end
end
