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
    }

    def save(ctx, model:, params:, **)
      if model.paid?
        model.destroy!
        ::Contract::Services::ContractInterestPaymentGenerator.call(contract: model.contract, start_date: model.from)
        ctx[:message] = "Đã huỷ đóng lãi"
      else
        model.payment_status = ContractInterestPayment.payment_statuses[:paid]
        model.total_paid = params[:total_paid].remove_dots.to_d
        ctx[:message] = "Đóng lãi thành công"
        model.save!
      end

      true
    end
  end
end
