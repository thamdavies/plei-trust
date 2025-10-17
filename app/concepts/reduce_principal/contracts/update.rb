module ReducePrincipal::Contracts
  class Update < ApplicationContract
    property :contract_id
    property :prepayment_date, populator: ->(options) {
      self.prepayment_date = self.input_params["prepayment_date"].parse_date_vn if self.input_params["prepayment_date"].present?
    }
    property :prepayment_amount, default: 0, populator: ->(options) {
      self.prepayment_amount = self.input_params["prepayment_amount"].remove_dots.to_f if self.input_params["prepayment_amount"].present?
    }
    property :note

    validation contract: DryContract do
      option :form

      params do
        required(:prepayment_date).filled
        required(:prepayment_amount).filled(:float?, gt?: 0)
      end

      rule(:prepayment_date) do
        paid_interest_payment = ::Contract.find(form.contract_id).paid_interest_payments.last
        if paid_interest_payment && value < paid_interest_payment.to
          key.failure("phải lớn hơn hoặc bằng ngày kết thúc kỳ lãi đã trả là ngày #{paid_interest_payment.to.to_fs(:date_vn)}")
        else
          last_interest_payment = ::Contract.find(form.contract_id).interest_payments.last
          if last_interest_payment && value > last_interest_payment.to
            key.failure("phải nhỏ hơn hoặc bằng ngày kết thúc kỳ lãi cuối cùng là ngày #{last_interest_payment.to.to_fs(:date_vn)}")
          end
        end
      end
    end
  end
end
