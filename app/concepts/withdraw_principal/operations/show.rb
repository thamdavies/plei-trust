module WithdrawPrincipal::Operations
  class Show < ApplicationOperation
    step :load_contract
    step :load_withdrawal_principal

    def load_contract(ctx, params:, current_user:, **)
      ctx[:contract] = ::Contract.find(params[:contract_id])
    end

    def load_withdrawal_principal(ctx, params:, **)
      start_date = ctx[:contract].unpaid_interest_payments.minimum(:from)
      reader = ::Contract::Services::CustomInterestPaymentReader.new(
        contract: ctx[:contract],
        from_date: start_date,
        to_date: params[:transaction_date].parse_date_vn,
        old_debt_amount: ctx[:contract].customer.old_debt_amount,
        other_amount: params[:other_amount].remove_dots.to_f
      )

      ctx[:withdraw_principal] = reader.call
    end
  end
end
