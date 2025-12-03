module Contract::Writer
  extend ActiveSupport::Concern

  def recalculate_contract_date
    if InterestCalculationMethod.config[:code][:monthly_calendar] != interest_calculation_method
      self.contract_date = contract_date.next_day
    end
  end

  def reset_interest_payments!
    contract_interest_payments.delete_all
    Contract::Services::ContractInterestPaymentGenerator.new(contract: self).call
  end

  def reverse_debit_amount_params(parameters)
    debit_amount = parameters[:debit_amount]
    credit_amount = parameters[:credit_amount]

    if pawn?
      parameters[:credit_amount] = debit_amount
      parameters[:debit_amount] = credit_amount
    end

    parameters
  end

  def create_financial_transaction!(is_income: false, amount: nil)
    return if is_default_capital?

    code = is_income ? TransactionType::INCOME_MISC : TransactionType::EXPENSE_MISC
    current_branch = self.branch
    current_user = self.created_by
    current_branch.financial_transactions.create!(
      amount: amount || self.loan_amount_display,
      transaction_type_code: code,
      created_by: current_user,
      transaction_date: Date.current,
      recordable: self
    )
  end
end
