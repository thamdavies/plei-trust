module AdditionalLoan::Operations
  class Cancel < ApplicationOperation
    class AdditionalLoan
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :id, :contract_id

      def contract
        @contract ||= ::Contract.find(contract_id)
      end
    end

    step Model(AdditionalLoan, :new)
    step Contract::Build(constant: ::AdditionalLoan::Contracts::Cancel)
    step :assign_form_values
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :regenerate_interest_payments
      step :create_activity_log
      step :notify
    }

    def assign_form_values(ctx, params:, model:, **)
      model.id = params[:id]
      model.contract_id = params[:contract_id]
      ctx[:contract] = model.contract

      true
    end

    def save(ctx, params:, model:, **)
      contract = ctx[:contract]
      financial_transaction = contract.financial_transactions.find(params[:id])
      ctx[:financial_transaction] = financial_transaction
      financial_transaction.destroy!

      true
    end

    def regenerate_interest_payments(ctx, model:, params:, **)
      contract = model.contract
      paid_interest_payment = ctx[:contract].paid_interest_payments.last

      if paid_interest_payment
        unpaid_interest_payment = contract.unpaid_interest_payments.first
        ::Contract::Services::ContractInterestPaymentGenerator.call(contract:, start_date: unpaid_interest_payment.from)
      else
        ::Contract::Services::ContractInterestPaymentGenerator.call(contract:)
      end

      true
    end

    def create_activity_log(ctx, current_user:, params:, **)
      parameters = {
        debit_amount: ctx[:financial_transaction].amount,
        credit_amount: 0,
        other_amount: 0
      }

      parameters = ctx[:contract].reverse_debit_amount_params(parameters)
      ctx[:contract].create_activity! key: "activity.additional_loan.cancel", owner: current_user, parameters: parameters

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Hủy khoản vay thêm thành công!"
      true
    end
  end
end
