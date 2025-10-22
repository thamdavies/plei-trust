module Contract::Services::Generators
  class Base
    attr_reader :interest_per_day

    # Initialize with contract
    # @param contract [Contract] The contract for which interest payments are being generated
    # @return [void]
    def initialize(contract:, start_date: nil)
      @contract = contract
      @start_date = start_date || contract.contract_date
    end

    private

    attr_reader :contract, :start_date

    def payment_cycle
      (contract.contract_term / contract.interest_period.to_f).ceil
    end

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

      # Ensure idempotency by removing existing payments for this contract
      ContractInterestPayment.where(contract_id: contract.id, custom_payment: false, payment_status: :unpaid).delete_all
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
