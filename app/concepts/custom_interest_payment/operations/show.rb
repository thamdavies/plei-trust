# frozen_string_literal: true

module CustomInterestPayment::Operations
  class Show < ApplicationOperation
    step Model(::Contract, :find)
    step :calculate_custom_interest_payment

    def calculate_custom_interest_payment(ctx, params:, model:, **)
      custom_interest_payment = ::Contract::Services::CustomInterestPaymentReader.new(
        contract: model,
        from_date: (params[:from_date].presence || Date.current.to_fs(:date_vn)).parse_date_vn,
        to_date: (params[:to_date].presence || Date.current.to_fs(:date_vn)).parse_date_vn
      ).call
      ctx[:custom_interest_payment] = custom_interest_payment
      true
    end
  end
end
