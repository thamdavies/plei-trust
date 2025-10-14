module ContractInterestPayment::Contracts
  class Update < ApplicationContract
    property :id
    property :contract_id, virtual: true
    property :total_paid, default: 0, populator: ->(options) {
      self.total_paid = self.input_params["total_paid"].remove_dots if self.input_params["total_paid"].present?
    }

    validation contract: DryContract do
      option :form

      params do
        required(:id).filled(:string)
      end

      # Rule này tôi muốn kiểm tra xem các kỳ đóng lãi trước đó đã được đóng chưa vì yêu cầu nghiệp vụ là phải đóng lãi theo thứ tự, tương tự cho việc hủy đóng lãi
      rule(:id) do
        contract = ::Contract.find(form.contract_id)
        interest_payment = contract.contract_interest_payments.find_by(id: value)
        key.failure("không tồn tại") unless interest_payment

        if interest_payment.unpaid? && interest_payment.contract.unpaid_interest_payments.where("contract_interest_payments.from < ?", interest_payment.from).exists?
          key.failure("phải đóng lãi các kỳ trước đó trước khi đóng kỳ này")
        end

        if interest_payment.paid? && interest_payment.contract.paid_interest_payments.where("contract_interest_payments.from > ?", interest_payment.from).exists?
          key.failure("phải hủy đóng lãi các kỳ sau đó trước khi hủy kỳ này")
        end
      end
    end
  end
end
