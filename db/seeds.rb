raise "Seeding is not allowed in production" if Rails.env.production?
puts "🌱 Starting database seeding..."

# Load branches seed
load Rails.root.join('db', 'seeds', 'branches.rb')

# Load users seed
load Rails.root.join('db', 'seeds', 'users.rb')

puts "✅ Database seeding completed!"
