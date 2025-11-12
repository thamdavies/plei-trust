require 'rails_helper'

RSpec.describe Contract::Services::Generators::DailyPerMillionPayments do
  let(:contract_type) { create(:contract_type, :capital, code: :capital) }
  let(:contract) { create(:contract, contract_type:, contract_date: "2025-10-03".to_date) }
  let(:processed_by) { create(:user) }
  let(:transaction_type) { create(:transaction_type, :additional_loan) }
  let(:additional_loan1) { create(:financial_transaction, transaction_type:, contract:, amount: 1_000_000, transaction_date: "2025-10-22".to_date) }
  let(:additional_loan2) { create(:financial_transaction, transaction_type:, contract:, amount: 1_000_000, transaction_date: "2025-10-26".to_date) }
  let(:additional_loan3) { create(:financial_transaction, transaction_type:, contract:, amount: 1_000_000, transaction_date: "2025-11-20".to_date) }
  let(:additional_loan4) { create(:financial_transaction, transaction_type:, contract:, amount: 1_000_000, transaction_date: "2025-11-26".to_date) }
  let(:service) { described_class.new(contract: contract) }

  describe '#call' do
    it 'generates correct number of payment cycles' do
      service.call
      expect(contract.contract_interest_payments.size).to eq(2)
    end

    it 'calculates payment amounts correctly' do
      service.call

      first_payment = contract.contract_interest_payments.order(:from).first
      second_payment = contract.contract_interest_payments.order(:from).second

      expect(first_payment.amount.to_f).to eq(1500.0)
      expect(second_payment.amount.to_f).to eq(1500.0)
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
        expect(contract.contract_interest_payments.first.amount.to_f).to eq(1_250.0)
        expect(contract.contract_interest_payments.first.number_of_days).to eq(25)
        expect(contract.contract_interest_payments.first.from).to eq(contract.contract_date)
        expect(contract.contract_interest_payments.first.to).to eq(contract.contract_date + 24)
      end
    end

    context 'when there are additional loans during the contract period exists one in period' do
      before do
        allow(contract).to receive(:contract_term).and_return(120)
        allow(contract).to receive(:contract_date).and_return("2025-10-18".to_date)

        additional_loan1
      end

      it 'includes additional loans in payment calculations' do
        service.call
        first_payment = contract.interest_payments.first
        expect(first_payment.amount.to_f).to eq(1_760.0)
      end
    end

    context 'when there are additional loans during the contract period exists two in period' do
      before do
        allow(contract).to receive(:contract_term).and_return(120)
        allow(contract).to receive(:contract_date).and_return("2025-10-18".to_date)

        additional_loan1 && additional_loan2
      end

      it 'includes additional loans in payment calculations' do
        service.call
        first_payment = contract.interest_payments.first
        second_payment = contract.interest_payments.second
        expect(first_payment.amount.to_f).to eq(1_980.0)
        expect(second_payment.amount.to_f).to eq(2_100.0)
      end
    end

    context 'when there are additional loans during the contract period exists one in different periods' do
      before do
        allow(contract).to receive(:contract_term).and_return(120)
        allow(contract).to receive(:contract_date).and_return("2025-10-18".to_date)

        additional_loan1 && additional_loan2 && additional_loan3
      end

      it 'includes additional loans in payment calculations' do
        service.call
        first_payment = contract.interest_payments.first
        second_payment = contract.interest_payments.second
        third_payment = contract.interest_payments.third
        expect(first_payment.amount.to_f).to eq(1_980.0)
        expect(second_payment.amount.to_f).to eq(2_370.0)
        expect(third_payment.amount.to_f).to eq(2_400.0)
      end
    end

    context 'when there are additional loans during the contract period exists two in different periods' do
      before do
        allow(contract).to receive(:contract_term).and_return(120)
        allow(contract).to receive(:contract_date).and_return("2025-10-18".to_date)

        additional_loan1 && additional_loan2 && additional_loan3 && additional_loan4
      end

      it 'includes additional loans in payment calculations' do
        service.call
        first_payment = contract.interest_payments.first
        second_payment = contract.interest_payments.second
        third_payment = contract.interest_payments.third
        expect(first_payment.amount.to_f).to eq(1_980.0)
        expect(second_payment.amount.to_f).to eq(2_580.0)
        expect(third_payment.amount.to_f).to eq(2_700.0)
      end
    end
  end

  describe '#initialize' do
    it 'sets contract and processed_by attributes' do
      expect(service.instance_variable_get(:@contract)).to eq(contract)
    end
  end
end
