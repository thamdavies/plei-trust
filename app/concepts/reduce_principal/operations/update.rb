module ReducePrincipal::Operations
  class Update < ApplicationOperation
    class ReducePrincipal
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :prepayment_date, :prepayment_amount, :note, :contract_id

      def contract
        @contract ||= ::Contract.find(contract_id)
      end
    end

    class Present < ApplicationOperation
      step Model(ReducePrincipal, :new)
      step Contract::Build(constant: ::ReducePrincipal::Contracts::Update)
      step :assign_attributes

      def assign_attributes(ctx, model:, params:, **)
        model.assign_attributes(params)

        form = ctx["contract.default"]
        form.prepayment_date = model.prepayment_date
        form.prepayment_amount = model.prepayment_amount
        form.note = model.note
        form.contract_id = model.contract_id
        ctx[:contract] = model.contract

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :regenerate_interest_payments
      step :create_activity_log
      step :notify
    }

    def save(ctx, model:, current_branch:, **)
      ctx[:financial_transaction] = current_branch.financial_transactions.create!(
        transaction_type_code: TransactionType.config.dig(:reduce_principal, model.contract.contract_type_code.to_sym, :update),
        amount: model.prepayment_amount,
        transaction_date: model.prepayment_date,
        description: model.note,
        created_by: ctx[:current_user],
        owner: model.contract
      )

      true
    end

    def regenerate_interest_payments(ctx, model:, params:, **)
      return true if ctx[:contract].no_interest?

      contract = ctx[:contract]

      paid_interest_payment = contract.paid_interest_payments.last

      if paid_interest_payment
        unpaid_interest_payment = contract.unpaid_interest_payments.first
        ::Contract::Services::ContractInterestPaymentGenerator.call(contract:, start_date: unpaid_interest_payment.from)
      else
        ::Contract::Services::ContractInterestPaymentGenerator.call(contract:)
      end

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Trả bớt gốc thành công!"
      true
    end

    def create_activity_log(ctx, model:, current_user:, **)
      parameters = {
        debit_amount: ctx[:financial_transaction].amount,
        credit_amount: 0,
        other_amount: 0
      }

      parameters = ctx[:contract].reverse_debit_amount_params(parameters)
      ctx[:contract].create_activity! key: "activity.reduce_principal.create", owner: current_user, parameters: parameters

      true
    end
  end
end
