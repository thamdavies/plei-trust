class CreateAssetSettingValues < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_values, id: false do |t|
      t.ksuid :id, primary_key: true
      t.references :asset_setting_attribute, null: false, foreign_key: true, type: :string
      t.references :contract, null: false, foreign_key: true, type: :string
      t.string :value
      t.timestamps
    end
  end
end