class CreateAssetSettingValues < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_values, id: :uuid, default: 'uuidv7()' do |t|
      t.references :asset_setting_attribute, null: false, foreign_key: true, type: :uuid
      t.references :contract, null: false, foreign_key: true, type: :uuid
      t.string :value
      t.timestamps
    end
  end
end
