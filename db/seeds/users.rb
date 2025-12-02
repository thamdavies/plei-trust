index = 1
Branch.find_each do |branch|
  user = branch.users.find_or_create_by!(email: "user#{index}@plei-trust.com") do |user|
    user.branch_id = branch.id
    user.phone = "0978463712"
    user.full_name = "Tham #{branch.name}"
    user.password = "Abc123456$"
  end

  puts "✓ Created user: #{user.full_name} - ID: #{user.id}"
  index += 1
end
