require 'rails_helper'

RSpec.describe Contract::Services::Generators::DailyFixedPayments do
  let(:contract_type) { create(:contract_type, code: :capital) }
  let(:contract) { create(:contract, contract_type:, contract_date: "2025-10-03".to_date, interest_rate: 10, interest_calculation_method: InterestCalculationMethod.config[:code][:daily_fixed]) }
  let(:processed_by) { create(:user) }
  let(:service) { described_class.new(contract: contract, processed_by: processed_by) }

  describe '#call' do
    it 'generates correct number of payment cycles' do
      service.call
      expect(contract.contract_interest_payments.size).to eq(2)
    end

    it 'calculates payment amounts correctly using daily fixed formula' do
      service.call

      first_payment = contract.contract_interest_payments.order(:from).first
      second_payment = contract.contract_interest_payments.order(:from).second

      expect(first_payment.amount.to_f).to eq(300_000.0)
      expect(second_payment.amount.to_f).to eq(300_000.0)
    end

    it 'sets correct payment date ranges' do
      service.call

      first_payment = contract.contract_interest_payments.order(:from).first
      second_payment = contract.contract_interest_payments.order(:from).second

      expect(first_payment.number_of_days).to eq(30)
      expect(first_payment.from).to eq(contract.contract_date)
      expect(first_payment.to).to eq(contract.contract_date + 29)

      expect(second_payment.number_of_days).to eq(30)
      expect(second_payment.from).to eq(contract.contract_date + 30)
      expect(second_payment.to).to eq(contract.contract_date + 59)
    end

    context 'when contract term is not evenly divisible by payment frequency' do
      before do
        allow(contract).to receive(:contract_term).and_return(25)
      end

      it 'handles partial final payment period correctly' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(1)
        # 10 * 1_000 * 25 = 250_000
        expect(contract.contract_interest_payments.first.amount.to_f).to eq(250_000.0)
        expect(contract.contract_interest_payments.first.number_of_days).to eq(25)
        expect(contract.contract_interest_payments.first.from).to eq(contract.contract_date)
        expect(contract.contract_interest_payments.first.to).to eq(contract.contract_date + 24)
      end
    end

    context 'with different interest rate' do
      let(:contract) { create(:contract, contract_type:, contract_date: "2025-10-03".to_date, interest_rate: 5) }

      it 'calculates payments with different interest rate' do
        service.call

        first_payment = contract.contract_interest_payments.order(:from).first

        # 5 * 1_000 * 30 = 150_000
        expect(first_payment.amount.to_f).to eq(150_000.0)
        expect(first_payment.number_of_days).to eq(30)
      end
    end
  end

  describe '#initialize' do
    it 'sets contract and processed_by attributes' do
      expect(service.instance_variable_get(:@contract)).to eq(contract)
      expect(service.instance_variable_get(:@processed_by)).to eq(processed_by)
    end
  end
end
