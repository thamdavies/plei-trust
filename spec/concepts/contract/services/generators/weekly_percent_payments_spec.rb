require 'rails_helper'

RSpec.describe Contract::Services::Generators::WeeklyPercentPayments do
  let(:contract_type) { create(:contract_type, code: :capital) }
  let(:contract) { create(:contract, :weekly_percent, contract_type:, contract_date: "2025-10-06".to_date) }
  let(:processed_by) { create(:user) }
  let(:service) { described_class.new(contract: contract) }

  describe '#call' do
    it 'generates correct number of payment cycles' do
      service.call
      expect(contract.contract_interest_payments.size).to eq(3)
    end

    it 'calculates payment amounts correctly using daily fixed formula' do
      service.call

      first_payment = contract.contract_interest_payments.order(:from).first
      second_payment = contract.contract_interest_payments.order(:from).second
      third_payment = contract.contract_interest_payments.order(:from).third

      expect(first_payment.amount.to_f).to eq(200.0)
      expect(second_payment.amount.to_f).to eq(200.0)
      expect(third_payment.amount.to_f).to eq(200.0)
    end

    it 'sets correct payment date ranges' do
      service.call

      first_payment = contract.contract_interest_payments.order(:from).first
      second_payment = contract.contract_interest_payments.order(:from).second
      third_payment = contract.contract_interest_payments.order(:from).third

      expect(first_payment.number_of_days).to eq(28)
      expect(first_payment.from).to eq(contract.contract_date)
      expect(first_payment.to).to eq("2025-11-02".to_date)

      expect(second_payment.number_of_days).to eq(28)
      expect(second_payment.from).to eq("2025-11-03".to_date)
      expect(second_payment.to).to eq("2025-11-30".to_date)

      expect(third_payment.number_of_days).to eq(28)
      expect(third_payment.from).to eq("2025-12-01".to_date)
      expect(third_payment.to).to eq("2025-12-28".to_date)
    end

    context 'when contract term is not evenly divisible by payment frequency' do
      before do
        allow(contract).to receive(:contract_term).and_return(5)
      end

      it 'handles partial final payment period correctly' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(2)

        expect(contract.contract_interest_payments.first.amount.to_f).to eq(200.0)
        expect(contract.contract_interest_payments.first.number_of_days).to eq(28)
        expect(contract.contract_interest_payments.first.from).to eq(contract.contract_date)
        expect(contract.contract_interest_payments.first.to).to eq("2025-11-02".to_date)

        expect(contract.contract_interest_payments.second.amount.to_f).to eq(50.0)
        expect(contract.contract_interest_payments.second.number_of_days).to eq(7)
        expect(contract.contract_interest_payments.second.from).to eq("2025-11-03".to_date)
        expect(contract.contract_interest_payments.second.to).to eq("2025-11-09".to_date)
      end
    end

    context 'with different interest rate' do
      let(:contract) { create(:contract, :weekly_percent, contract_type:, contract_date: "2025-10-06".to_date, interest_rate: 5, contract_term: 4) }

      it 'calculates payments with different interest rate' do
        service.call

        first_payment = contract.contract_interest_payments.order(:from).first

        expect(contract.contract_interest_payments.size).to eq(1)
        expect(first_payment.amount.to_f).to eq(1000.0)
        expect(first_payment.number_of_days).to eq(28)
      end
    end
  end

  describe '#initialize' do
    it 'sets contract and processed_by attributes' do
      expect(service.instance_variable_get(:@contract)).to eq(contract)
    end
  end
end
