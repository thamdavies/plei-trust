ActiveRecord::Base.connection.execute("TRUNCATE TABLE \"#{BranchContractType.table_name}\" RESTART IDENTITY CASCADE")

# Associate some contract types with branches
Branch.find_each do |branch|
  # Associate all contract types with each branch for demonstration purposes
  # In a real scenario, you might want to associate specific contract types
  # based on branch location or other criteria
  contract_types = ContractType.all
  contract_types.each do |contract_type|
    BranchContractType.find_or_create_by(branch_id: branch.id.to_s, contract_type_id: contract_type.id.to_s)
  end
  puts "✓ Associated #{contract_types.count} contract types with branch: #{branch.name}"
end

puts "✓ Created #{BranchContractType.count} branch contract type associations."
