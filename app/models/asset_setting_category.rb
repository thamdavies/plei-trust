# == Schema Information
#
# Table name: asset_setting_categories
#
#  id               :string(27)       not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  asset_setting_id :string           not null
#  contract_type_id :string           not null
#
# Indexes
#
#  index_asset_setting_categories_on_asset_setting_id  (asset_setting_id)
#  index_asset_setting_categories_on_contract_type_id  (contract_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_id => asset_settings.id)
#  fk_rails_...  (contract_type_id => contract_types.id)
#
class AssetSettingCategory < ApplicationRecord
end
