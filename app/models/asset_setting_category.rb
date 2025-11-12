# == Schema Information
#
# Table name: asset_setting_categories
#
#  id                 :uuid             not null, primary key
#  contract_type_code :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  asset_setting_id   :uuid             not null
#
# Indexes
#
#  index_asset_setting_categories_on_asset_setting_id  (asset_setting_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_id => asset_settings.id)
#  fk_rails_...  (contract_type_code => contract_types.code)
#
class AssetSettingCategory < ApplicationRecord
  belongs_to :asset_setting
  belongs_to :contract_type, foreign_key: :contract_type_code, primary_key: :code

  class << self
    def ransackable_attributes(auth_object = nil)
      [ "contract_type_code" ]
    end

    def ransackable_associations(auth_object = nil)
     []
    end
  end
end
