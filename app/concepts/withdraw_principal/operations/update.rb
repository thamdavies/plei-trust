module WithdrawPrincipal::Operations
  class Update < ApplicationOperation
    class WithdrawPrincipal
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :start_date, :transaction_date, :withdrawal_amount, :other_amount, :note, :contract_id

      def contract
        @contract ||= ::Contract.find(contract_id)
      end
    end

    class Present < ApplicationOperation
      step Model(WithdrawPrincipal, :new)
      step Contract::Build(constant: ::WithdrawPrincipal::Contracts::Update)
      step :assign_attributes

      def assign_attributes(ctx, model:, params:, **)
        model.assign_attributes(params)
        ctx[:contract] = model.contract
        start_date = ContractInterestPayment.unpaid.where(contract_id: model.contract_id).order(:from).first&.from
        model.start_date = start_date || Date.current

        reader = ::Contract::Services::CustomInterestPaymentReader.new(
          contract: ctx[:contract],
          from_date: model.start_date,
          to_date: model.transaction_date.parse_date_vn,
          old_debt_amount: ctx[:contract].customer.old_debt_amount,
          other_amount: model.other_amount&.remove_dots.to_f
        )

        ctx[:withdraw_principal] = reader.call

        form = ctx["contract.default"]
        form.start_date = model.start_date
        form.transaction_date = model.transaction_date

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
      withdraw_principal = ctx[:withdraw_principal]
      ctx[:record] = model.contract.financial_transactions.create!(
        transaction_type: TransactionType.withdrawal_principal,
        amount: withdraw_principal[:total_amount_raw],
        transaction_date: model.transaction_date.parse_date_vn,
        description: model.note,
        created_by: ctx[:current_user]
      )

      true
    end

    def regenerate_interest_payments(ctx, model:, params:, **)
      contract = ctx[:contract]
      contract.update_columns(status: "closed")
      generator = ::Contract::Services::ContractInterestPaymentGenerator.new(contract:, start_date: model.start_date)
      generator.call

      true
    end

    def create_activity_log(ctx, model:, current_user:, **)
      parameters = {
        debit_amount: ctx[:record].amount,
        credit_amount: 0,
        other_amount: 0
      }

      parameters = ctx[:contract].reverse_debit_amount_params(parameters)
      ctx[:contract].create_activity! key: "activity.contract.close", owner: current_user, parameters: parameters

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Rút gốc thành công"

      true
    end
  end
end
