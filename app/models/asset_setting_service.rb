# == Schema Information
#
# Table name: asset_setting_services
#
#  id               :string(27)       not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  asset_setting_id :string           not null
#  service_id       :string           not null
#
# Indexes
#
#  index_asset_setting_services_on_asset_setting_id  (asset_setting_id)
#  index_asset_setting_services_on_service_id        (service_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_id => asset_settings.id)
#  fk_rails_...  (service_id => services.id)
#
class AssetSettingService < ApplicationRecord
end
