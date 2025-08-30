class CreateAssetSettingServices < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_setting_services, id: false do |t|
      t.ksuid :id, primary_key: true
      t.references :asset_setting, null: false, foreign_key: true, type: :string
      t.references :service, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
