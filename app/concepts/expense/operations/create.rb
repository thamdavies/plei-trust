module Expense::Operations
  class Create < ApplicationOperation
    class Expense
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :party_name, :amount, :transaction_type_code, :transaction_note
    end

    class Present < ApplicationOperation
      step Model(Expense, :new)
      step Contract::Build(constant: ::Expense::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :notify
    }

    private

    def save(ctx, model:, params:, current_branch:, current_user:, **)
      model.assign_attributes(params)
      transaction_type = TransactionType.find_by!(code: model.transaction_type_code)

      ctx[:current_branch].financial_transactions.create!(
        amount: model.amount,
        party_name: model.party_name,
        transaction_type:,
        description: model.transaction_note,
        created_by: current_user,
        transaction_date: Date.current
      )

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Ghi nhận phiếu chi thành công!"

      true
    end
  end
end
