# frozen_string_literal: true

module ContractInterestPayment::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::ContractInterestPayment, :find)
      step Contract::Build(constant: ContractInterestPayment::Contracts::Update)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :create_activity_log
    }

    def save(ctx, model:, params:, current_branch:, **)
      is_paid = false
      if model.paid?
        ctx[:financial_transaction] = current_branch.financial_transactions.create!(
          transaction_type_code: TransactionType.config.dig(:interest_payment, model.contract.contract_type_code.to_sym, :cancel),
          amount: model.total_paid_display,
          transaction_date: Date.current,
          description: "Huỷ đóng lãi #{model.contract_id}, ID: #{model.id}",
          owner: model.contract,
          created_by: ctx[:current_user]
        )
        model.destroy!
        ::Contract::Services::ContractInterestPaymentGenerator.call(contract: model.contract, start_date: model.from)
        ctx[:message] = "Đã huỷ đóng lãi"
        is_paid = false
      else
        model.payment_status = ContractInterestPayment.payment_statuses[:paid]
        model.paid_at = Time.current
        model.total_paid = params[:total_paid].remove_dots.to_d
        ctx[:message] = "Đóng lãi thành công"
        is_paid = true
        model.save!

        ctx[:financial_transaction] = current_branch.financial_transactions.create!(
          transaction_type_code: TransactionType.config.dig(:interest_payment, model.contract.contract_type_code.to_sym, :update),
          amount: model.total_paid_display,
          transaction_date: Date.current,
          description: "Đóng lãi hợp đồng ##{model.contract_id}",
          owner: model.contract,
          created_by: ctx[:current_user]
        )
      end

      ctx[:is_paid] = is_paid
      true
    end

    def create_activity_log(ctx, model:, current_user:, **)
      debit_amount = 0
      credit_amount = 0

      if ctx[:is_paid]
        key = "activity.contract_interest_payment.paid"
        debit_amount = model.total_paid
      else
        key = "activity.contract_interest_payment.cancel"
        credit_amount = model.total_paid
      end

      parameters = {
        debit_amount:,
        credit_amount:,
        other_amount: 0,
        interest_payment_id: model.id,
        note: "Kỳ: #{model.from.to_fs(:date_vn)} - #{model.to.to_fs(:date_vn)}"
      }

      parameters = model.contract.reverse_debit_amount_params(parameters)
      model.contract.create_activity! key: key, owner: current_user, parameters: parameters

      true
    end
  end
end
