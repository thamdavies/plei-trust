# Load contract types from YAML file
require 'yaml'

# reset contract types with identical ids to ensure consistency

ActiveRecord::Base.connection.execute("TRUNCATE TABLE \"#{ContractType.table_name}\" RESTART IDENTITY CASCADE")

contract_types_file = Rails.root.join('db', 'fixtures', 'contract_types.yml')
contract_types_data = YAML.load_file(contract_types_file)['contract_types']

# Bulk insert contract types
ContractType.insert_all(contract_types_data)

puts "Seeded #{ContractType.count} contract types."
