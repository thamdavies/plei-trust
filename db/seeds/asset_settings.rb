ActiveRecord::Base.connection.execute("TRUNCATE TABLE \"#{AssetSettingAttribute.table_name}\" RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE \"#{AssetSettingCategory.table_name}\" RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE \"#{AssetSetting.table_name}\" RESTART IDENTITY CASCADE")

# Load asset settings from YAML file
require 'yaml'

puts "🌱 Seeding asset settings..."

asset_settings_file = Rails.root.join('db', 'fixtures', 'asset_settings.yml')
asset_settings_data = YAML.load_file(asset_settings_file)['asset_settings']

ActiveRecord::Base.transaction do
  Branch.find_each do |branch|
    asset_settings_data.each do |asset_data|
      asset_setting = branch.asset_settings.create!(
        asset_name: asset_data['asset_name'],
        asset_code: asset_data['asset_code'],
        status: asset_data['status'],
        interest_calculation_method: asset_data['interest_calculation_method'],
        default_loan_amount: asset_data['default_loan_amount'],
        default_interest_rate: asset_data['default_interest_rate'],
        interest_period: asset_data['interest_period'],
        default_contract_term: asset_data['default_contract_term'],
        liquidation_after_days: 15,
      )

      puts "Created AssetSetting: #{asset_setting.asset_code} for Branch: #{branch.name}"

      # Create associated categories
      if asset_data['asset_setting_categories'].present?
        asset_data['asset_setting_categories'].each do |category|
          contract_type = ContractType.find_by(code: category['code'])
          if contract_type
            AssetSettingCategory.create!(
              asset_setting_id: asset_setting.id,
              contract_type_id: contract_type.id
            )
          else
            puts "Warning: ContractType '#{category['code']}' not found. Skipping category creation."
          end
        end
      end

      puts "Associated categories created for AssetSetting: #{asset_setting.asset_code}"

      # Create associated attributes
      if asset_data['asset_setting_attributes']
        asset_data['asset_setting_attributes'].each do |attribute|
          AssetSettingAttribute.create!(
            asset_setting_id: asset_setting.id,
            attribute_name: attribute['attribute_name']
          )
        end
      end

      puts "Associated attributes created for AssetSetting: #{asset_setting.asset_code}"
    end
  end
end

puts "✅ Asset settings seeded successfully."
