# == Schema Information
#
# Table name: asset_setting_values
#
#  id                         :string(27)       not null, primary key
#  value                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  asset_setting_attribute_id :string           not null
#  contract_id                :string           not null
#
# Indexes
#
#  index_asset_setting_values_on_asset_setting_attribute_id  (asset_setting_attribute_id)
#  index_asset_setting_values_on_contract_id                 (contract_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_attribute_id => asset_setting_attributes.id)
#  fk_rails_...  (contract_id => contracts.id)
#
require "test_helper"

class AssetSettingValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
