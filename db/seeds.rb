raise "Seeding is not allowed in production" if Rails.env.production?
puts "🌱 Starting database seeding..."

# Load contract types seed
load Rails.root.join('db', 'seeds', 'contract_types.rb')

# Load branches seed
load Rails.root.join('db', 'seeds', 'branches.rb')

# Associate contract types with branches
load Rails.root.join('db', 'seeds', 'branch_contract_types.rb')

# Load users seed
load Rails.root.join('db', 'seeds', 'users.rb')

# Load asset settings seed
load Rails.root.join('db', 'seeds', 'asset_settings.rb')

# Seed default transaction types
TransactionType.seed_default_types

puts "✅ Database seeding completed!"
