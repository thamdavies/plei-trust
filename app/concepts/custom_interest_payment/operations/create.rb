# frozen_string_literal: true

module CustomInterestPayment::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::CustomInterestPayment, :new)
      step Contract::Build(constant: CustomInterestPayment::Contracts::Create)
      step :set_custom_interest_payment

      def set_custom_interest_payment(ctx, params:, model:, **)
        model.assign_attributes(ctx[:params])
        if model.from_date.present? && model.from_date.is_a?(String)
          model.from_date = model.from_date.parse_date_vn
        end
        if model.to_date.present? && model.to_date.is_a?(String)
          model.to_date = model.to_date.parse_date_vn
        end

        form = ctx["contract.default"]
        form.from_date = model.from_date
        form.to_date = model.to_date
        form.days_count = (model.to_date - model.from_date).to_i + 1
        form.interest_amount = model.interest_amount
        form.other_amount = model.other_amount || 0
        form.total_interest_amount = form.interest_amount + form.other_amount
        form.customer_payment_amount = model.customer_payment_amount
        form.note = model.note

        true
      end
    end

    step Subprocess(Present)
    step :preprocess_params
    step Contract::Validate()

    step Wrap(AppTransaction) {
      step :save_custom_interest_payment
      step :generate_contract_interest_payments
    }

    def preprocess_params(ctx, params:, model:, **)
      model.interest_amount = model.interest_amount.remove_dots.to_d
      model.other_amount = model.other_amount.remove_dots.to_d
      model.total_interest_amount = model.interest_amount + model.other_amount
      model.customer_payment_amount = model.customer_payment_amount.remove_dots.to_d
      ctx[:contract] = ::Contract.find(model.contract_id)

      true
    end

    def save_custom_interest_payment(ctx, model:, **)
      ::ContractInterestPayment.create!(
        contract_id: model.contract_id,
        from: model.from_date,
        to: model.to_date,
        custom_payment: true,
        number_of_days: model.days_count,
        amount: model.interest_amount,
        other_amount: model.other_amount,
        total_amount: model.total_interest_amount,
        total_paid: model.customer_payment_amount,
        note: model.note,
        payment_status: ContractInterestPayment.payment_statuses[:paid],
      )
      true
    end

    def generate_contract_interest_payments(ctx, model:, **)
      contract = ctx[:contract]
      contract.contract_date = model.to_date
      contract.recalculate_contract_date

      ::Contract::Services::ContractInterestPaymentGenerator.new(contract:).call
      true
    end
  end
end
