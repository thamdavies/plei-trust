# Seed data for branches in Gia Lai and Da Nang

if Province.count == 0
  ActiveRecord::Base.connection.execute(File.read(Rails.root.join("db", "fixtures", "ImportData_vn_units.sql")))
end

# Find provinces
gia_lai_province = Province.find_by(code_name: "gia_lai")
da_nang_province = Province.find_by(code_name: "da_nang")

unless gia_lai_province
  puts "Province 'Gia Lai' not found. Please check provinces data."
  return
end

unless da_nang_province
  puts "Province 'Đà Nẵng' not found. Please check provinces data."
  return
end

# Find some wards for addresses
pleiku_wards = Ward.joins(:province).where(provinces: { code_name: "gia_lai" }).limit(1)
da_nang_wards = Ward.joins(:province).where(provinces: { code_name: "da_nang" }).limit(1)

puts "Creating branches for Gia Lai province..."

# Gia Lai branches
branches_gia_lai = [
  {
    name: "Chi nhánh Pleiku",
    province_id: gia_lai_province.id,
    ward_id: pleiku_wards.first&.id,
    address: "123 Đường Lê Duẩn, Thành phố Pleiku, Gia Lai",
    phone: "0269.3123.456",
    representative: "Nguyễn Văn An",
    invest_amount: 5_000_000_000.00,
    status: "active"
  }
]

puts "Creating branches for Đà Nẵng province..."

# Đà Nẵng branches
branches_da_nang = [
  {
    name: "Chi nhánh Hải Châu",
    province_id: da_nang_province.id,
    ward_id: da_nang_wards.first&.id,
    address: "123 Đường Trần Phú, Quận Hải Châu, Đà Nẵng",
    phone: "0236.3111.222",
    representative: "Phạm Văn Dũng",
    invest_amount: 8_000_000_000.00,
    status: "active"
  }
]

# Create branches
all_branches = branches_gia_lai + branches_da_nang

all_branches.each do |branch_data|
  branch = Branch.find_or_create_by(name: branch_data[:name]) do |b|
    b.province_id = branch_data[:province_id]
    b.ward_id = branch_data[:ward_id]
    b.address = branch_data[:address]
    b.phone = branch_data[:phone]
    b.representative = branch_data[:representative]
    b.invest_amount = branch_data[:invest_amount]
    b.status = branch_data[:status]
  end

  if branch.persisted?
    puts "✓ Created branch: #{branch.name} - ID: #{branch.id}"
  else
    puts "✗ Failed to create branch: #{branch_data[:name]}"
    puts "  Errors: #{branch.errors.full_messages.join(', ')}" if branch.errors.any?
  end
end

puts "Total branches created: #{Branch.count}"
