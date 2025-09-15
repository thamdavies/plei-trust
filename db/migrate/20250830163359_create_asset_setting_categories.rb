class CreateAssetSettingCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_categories, id: false do |t|
      t.ksuid :id, primary_key: true
      t.references :asset_setting, null: false, foreign_key: true, type: :string
      t.references :contract_type, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
