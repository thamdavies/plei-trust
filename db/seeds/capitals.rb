# Create a capital_in transaction type record for the branch's invest_amount
transaction_type = TransactionType.capital_in
Branch.find_each do |branch|
  FinancialTransaction.create!(
    recordable: branch,
    transaction_type: transaction_type,
    amount: branch.invest_amount * 1_000,
    description: "Ghi nhận vốn đầu tư cho chi nhánh #{branch.name}",
    transaction_date: Date.current,
    created_by_id: User.first.id
  )

  Contract.create!(
    contract_type_code: ContractType.codes[:capital],
    branch: branch,
    cashier_id: branch.users.first.id,
    created_by: branch.users.first,
    customer: branch.customers.first,
    loan_amount: branch.invest_amount * 1_000,
    contract_date: Date.current,
    interest_calculation_method: InterestCalculationMethod.config[:code][:investment_capital],
  )
end

puts "✓ Recorded capital investment for all branches."
