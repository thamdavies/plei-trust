# == Schema Information
#
# Table name: asset_setting_values
#
#  value                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  asset_setting_attribute_id :uuid             not null, primary key
#  contract_id                :uuid             not null, primary key
#
# Indexes
#
#  idx_on_contract_id_asset_setting_attribute_id_b35d1be676  (contract_id,asset_setting_attribute_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_attribute_id => asset_setting_attributes.id)
#  fk_rails_...  (contract_id => contracts.id)
#
class AssetSettingValue < ApplicationRecord
  belongs_to :contract, optional: true
  belongs_to :asset_setting_attribute, optional: true
end
