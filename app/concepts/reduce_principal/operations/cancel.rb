module ReducePrincipal::Operations
  class Cancel < ApplicationOperation
    class ReducePrincipal
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :prepayment_date, :prepayment_amount, :note, :contract_id
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

        ctx[:contract] = ::Contract.find(model.contract_id)

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :regenerate_interest_payments
      step :notify
    }

    def save(ctx, model:, params:, **)
      FinancialTransaction.create!(
        contract_id: model.contract_id,
        transaction_type: TransactionType.principal_payment,
        amount: model.prepayment_amount,
        transaction_date: model.prepayment_date,
        description: model.note,
        created_by: ctx[:current_user]
      )

      ctx[:contract].decrement!(:loan_amount, model.prepayment_amount.to_d)

      true
    end

    def regenerate_interest_payments(ctx, model:, params:, **)
      contract = ctx[:contract]

      paid_interest_payment = contract.paid_interest_payments.last

      if paid_interest_payment
        unpaid_interest_payment = contract.unpaid_interest_payments.first
        contract.contract_date = unpaid_interest_payment.from
      end

      ::Contract::Services::CreateContractInterestPayment.call(contract:)

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Trả bớt gốc thành công!"
      true
    end
  end
end
