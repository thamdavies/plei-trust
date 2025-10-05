module Contract::Services::Generators
  class Base
    def build_payment_attrs(from:, to:, amount:, number_of_days:, total_amount:)
      {
        contract_id: contract.id,
        processed_by_id: processed_by.id,
        from: from,
        to: to,
        amount: amount,
        number_of_days:,
        total_amount: total_amount,
        total_paid: 0,
        other_amount: 0,
        status: "active"
      }
    end

    def create_payments(payment_data)
      return [] if payment_data.empty?

      ContractInterestPayment.where(contract_id: contract.id).delete_all
      ContractInterestPayment.insert_all!(payment_data)
    end
  end
end
