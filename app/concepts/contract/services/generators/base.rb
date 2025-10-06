module Contract::Services::Generators
  class Base
    def build_payment_attrs(from:, to:, amount:, number_of_days:, total_amount:)
      {
        contract_id: contract.id,
        from:,
        to:,
        amount:,
        number_of_days:,
        total_amount:,
        total_paid: 0,
        other_amount: 0
      }
    end

    def create_payments(payment_data)
      return [] if payment_data.empty?

      ContractInterestPayment.insert_all!(payment_data)
    end

    # For debugging purposes
    def print_data
      contract.contract_interest_payments.each do |data|
        puts "From: #{data.from}, To: #{data.to}, Amount: #{data.amount_formatted}, Days: #{data.number_of_days}, Total: #{data.total_amount}"
        puts "-----------------------------------"
      end
    end
  end
end
