# Create a capital_in transaction type record for the branch's invest_amount
Branch.find_each do |branch|
  Contract.create!(
    contract_type_code: ContractType.codes[:capital],
    branch: branch,
    is_default_capital: true,
    cashier_id: branch.users.first.id,
    created_by: branch.users.first,
    customer: branch.customers.first,
    loan_amount: branch.invest_amount * 1_000,
    contract_date: Date.current,
    interest_calculation_method: InterestCalculationMethod.config[:code][:investment_capital],
  )

  branch.daily_balances.create!(
    date: Date.current,
    opening_balance: 0,
    closing_balance: 0,
    created_by: branch.users.first,
  )
end

puts "✓ Recorded capital investment for all branches."
