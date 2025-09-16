# == Schema Information
#
# Table name: asset_setting_attributes
#
#  id               :uuid             not null, primary key
#  attribute_name   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  asset_setting_id :uuid             not null
#
# Indexes
#
#  index_asset_setting_attributes_on_asset_setting_id  (asset_setting_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_id => asset_settings.id)
#
require "test_helper"

class AssetSettingAttributeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
