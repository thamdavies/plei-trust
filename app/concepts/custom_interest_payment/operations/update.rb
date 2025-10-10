# frozen_string_literal: true

module CustomInterestPayment::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::CustomInterestPayment, :new)
      step Contract::Build(constant: CustomInterestPayment::Contracts::Update)
      step :set_defaults
      def set_defaults(ctx, params:, model:, **)
        model.assign_attributes(ctx[:params])
        form = ctx["contract.default"]
        form.from_date = model.from_date
        form.to_date = model.to_date
        form.days_count = (model.to_date - model.from_date).to_i + 1
        form.interest_amount = model.interest_amount
        form.other_amount = model.other_amount || 0
        form.total_interest_amount = form.interest_amount.to_i + form.other_amount.to_i
        form.customer_payment_amount = model.customer_payment_amount
        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step Contract::Persist()
    }
  end
end
