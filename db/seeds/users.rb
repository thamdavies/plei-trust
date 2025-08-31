user = User.find_or_create_by!(email: "tham@plei-trust.com") do |user|
  user.branch_id = Branch.find_by(name: "Chi nhánh Pleiku")&.id
  user.phone = "0978463712"
  user.full_name = "Tham"
  user.password = "Abc123456$"
end

puts "✓ Created user: #{user.full_name} - ID: #{user.id}"
