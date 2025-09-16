class CreateAssetSettingAttributes < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_attributes, id: :uuid, default: 'uuidv7()' do |t|
      t.references :asset_setting, null: false, foreign_key: true, type: :uuid
      t.string :attribute_name

      t.timestamps
    end
  end
end
