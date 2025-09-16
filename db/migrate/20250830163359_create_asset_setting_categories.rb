class CreateAssetSettingCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_categories, id: :uuid, default: 'uuidv7()' do |t|
      t.references :asset_setting, null: false, foreign_key: true, type: :uuid
      t.references :contract_type, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
