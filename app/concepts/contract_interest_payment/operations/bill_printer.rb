# frozen_string_literal: true

module ContractInterestPayment::Operations
  class BillPrinter < ApplicationOperation
    step Model(ContractInterestPayment, :find)
    step :load_contract
    step :load_interest_payment_info

    def load_contract(ctx, model:, params:, **)
      contract = ::Contract.pawn.find_by!(id: params[:contract_id])
      ctx[:contract] = contract.decorate
      ctx[:customer] = ctx[:contract].customer
    end

    def load_interest_payment_info(ctx, model:, params:, **)
      raise ActiveRecord::RecordNotFound unless model.paid?

      next_interest_payment = ctx[:contract].interest_payments.due_date_greater_than(model.to).first
      if next_interest_payment.present?
        ctx[:next_period] = next_interest_payment.to.to_fs(:date_vn)
      end
    end
  end
end
