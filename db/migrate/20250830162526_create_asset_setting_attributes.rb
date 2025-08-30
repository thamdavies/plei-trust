class CreateAssetSettingAttributes < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_attributes, id: false do |t|
      t.ksuid :id, primary_key: true
      t.references :asset_setting, null: false, foreign_key: true, type: :string
      t.string :attribute_name

      t.timestamps
    end
  end
end
