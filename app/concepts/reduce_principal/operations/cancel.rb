module ReducePrincipal::Operations
  class Cancel < ApplicationOperation
    class ReducePrincipal
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :id, :contract_id

      def contract
        @contract ||= ::Contract.find(contract_id)
      end
    end

    step Model(ReducePrincipal, :new)
    step Contract::Build(constant: ::ReducePrincipal::Contracts::Cancel)
    step :assign_form_values
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :regenerate_interest_payments
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
      contract.increment!(:loan_amount, financial_transaction.amount.to_d)

      ctx[:financial_transaction] = financial_transaction
      financial_transaction.destroy!

      true
    end

    def regenerate_interest_payments(ctx, model:, params:, **)
      # contract = model.contract
      # paid_interest_payment = ctx[:contract].paid_interest_payments.last

      # if paid_interest_payment
      #   unpaid_interest_payment = contract.unpaid_interest_payments.first
      #   contract.contract_date = unpaid_interest_payment.from
      # end

      # ::Contract::Services::CreateContractInterestPayment.call(contract:)

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Hủy trả bớt gốc thành công!"
      true
    end
  end
end
