module Debt::Operations
  class Destroy < ApplicationOperation
    class DebtPayment
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :amount, :contract_id

      def contract
        @contract ||= Contract.find(contract_id)
      end
    end

    class Present < ApplicationOperation
      step Model(DebtPayment, :new)
      step Contract::Build(constant: Debt::Contracts::Destroy)
      step :assign_attributes

      def assign_attributes(ctx, model:, params:, **)
        model.assign_attributes(params)

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :create_activity_log
      step :notify
    }

    def save(ctx, model:, **)
      contract = model.contract
      model.amount = model.amount.remove_dots.to_d
      transaction_type = TransactionType.debt_repayment

      ctx[:contract] = contract
      ctx[:financial_transaction] = FinancialTransaction.create!(
        contract: contract,
        transaction_date: Date.current,
        transaction_type: transaction_type,
        amount: model.amount,
        created_by_id: ctx[:current_user]&.id,
      )

      true
    end

    def create_activity_log(ctx, financial_transaction:, contract:, current_user:, **)
      parameters = {
        debit_amount: 0,
        credit_amount: financial_transaction.amount,
        financial_transaction_id: financial_transaction.id
      }
      contract.create_activity! key: "activity.contract.debt_repayment", owner: current_user, parameters: parameters

      true
    end

    def notify(ctx, **)
      ctx[:message] = "Trả nợ thành công!"
    end
  end
end
