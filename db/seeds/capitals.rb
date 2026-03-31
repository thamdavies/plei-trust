# Create a capital_in transaction type record for the branch's invest_amount
Branch.find_each do |branch|
  contract = Contract.create!(
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
    created_by: branch.users.first,
  )

  branch.financial_transactions.create!(
    transaction_date: Date.current,
    transaction_type_code: TransactionType::INCOME_CONTRACT_CHANGE,
    transactable_type_code: contract.contract_type_code,
    party_name: contract.customer.full_name,
    amount: branch.invest_amount * 1_000,
    created_by: branch.users.first,
    transactable: contract
  )
end

puts "✓ Recorded capital investment for all branches."
