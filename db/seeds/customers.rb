Branch.find_each do |branch|
  customer = Customer.create!(
    full_name: "Vốn khởi tạo",
    branch: branch,
    created_by: User.first,
    is_seed_capital: true
  )
  puts "✓ Created customer: #{customer.full_name} - ID: #{customer.id}"
end
