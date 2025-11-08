module AdditionalLoan::Operations
  class Update < ApplicationOperation
    class AdditionalLoan
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :transaction_date, :transaction_amount, :note, :contract_id
    end

    class Present < ApplicationOperation
      step Model(AdditionalLoan, :new)
      step Contract::Build(constant: ::AdditionalLoan::Contracts::Update)
      step :assign_attributes

      def assign_attributes(ctx, model:, params:, **)
        model.assign_attributes(params)

        form = ctx["contract.default"]
        form.transaction_date = model.transaction_date
        form.transaction_amount = model.transaction_amount
        form.note = model.note
        form.contract_id = model.contract_id

        ctx[:contract] = ::Contract.find(model.contract_id)

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

    def save(ctx, model:, params:, **)
      ctx[:financial_transaction] = FinancialTransaction.create!(
        contract_id: model.contract_id,
        transaction_type: TransactionType.additional_loan,
        amount: model.transaction_amount,
        transaction_date: model.transaction_date,
        description: model.note,
        created_by: ctx[:current_user]
      )

      true
    end

    def regenerate_interest_payments(ctx, model:, params:, **)
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

    def create_activity_log(ctx, model:, current_user:, **)
      parameters = {
        debit_amount: 0,
        credit_amount: ctx[:financial_transaction].amount,
        other_amount: 0
      }

      ctx[:contract].create_activity! key: "activity.additional_loan.create", owner: current_user, parameters: parameters

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Vay thêm thành công!"
      true
    end
  end
end
