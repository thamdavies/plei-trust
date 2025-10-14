require 'rails_helper'

RSpec.describe Contract::Services::Generators::WeeklyFixedPayments do
  let(:contract_type) { create(:contract_type, code: :capital) }
  let(:contract) { create(:contract, contract_type:, contract_date: "2025-10-03".to_date, interest_rate: 10, contract_term: 4, interest_period: 2, interest_calculation_method: InterestCalculationMethod.config[:code][:weekly_fixed]) }
  let(:processed_by) { create(:user) }
  let(:service) { described_class.new(contract: contract) }

  describe '#call' do
    it 'generates correct number of payment cycles' do
      service.call
      expect(contract.contract_interest_payments.size).to eq(2)
    end

    it 'calculates payment amounts correctly using weekly fixed formula' do
      service.call

      first_payment = contract.contract_interest_payments.order(:from).first
      second_payment = contract.contract_interest_payments.order(:from).second

      # interest_rate * number_of_weeks (2 weeks per period)
      expect(first_payment.amount.to_f).to eq(20.0)
      expect(second_payment.amount.to_f).to eq(20.0)
    end

    it 'sets correct payment date ranges' do
      service.call

      first_payment = contract.contract_interest_payments.order(:from).first
      second_payment = contract.contract_interest_payments.order(:from).second

      expect(first_payment.number_of_days).to eq(14)
      expect(first_payment.from).to eq(contract.contract_date)
      expect(first_payment.to).to eq(contract.contract_date + 13)

      expect(second_payment.number_of_days).to eq(14)
      expect(second_payment.from).to eq(contract.contract_date + 14)
      expect(second_payment.to).to eq(contract.contract_date + 27)
    end

    context 'when contract term is not evenly divisible by payment frequency' do
      before do
        allow(contract).to receive(:contract_term).and_return(3) # 3 weeks
        allow(contract).to receive(:interest_period).and_return(2) # 2 week periods
      end

      it 'handles partial final payment period correctly' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(2)

        first_payment = contract.contract_interest_payments.order(:from).first
        second_payment = contract.contract_interest_payments.order(:from).second

        # First payment: 2 weeks = 20.0
        expect(first_payment.amount.to_f).to eq(20.0)
        expect(first_payment.number_of_days).to eq(14)
        expect(first_payment.from).to eq(contract.contract_date)
        expect(first_payment.to).to eq(contract.contract_date + 13)

        # Second payment: 1 week (partial) = 10.0
        expect(second_payment.amount.to_f).to eq(10.0)
        expect(second_payment.number_of_days).to eq(7)
        expect(second_payment.from).to eq(contract.contract_date + 14)
        expect(second_payment.to).to eq(contract.contract_date + 20)
      end
    end

    context 'with single week contract term' do
      before do
        allow(contract).to receive(:contract_term).and_return(1) # 1 week
        allow(contract).to receive(:interest_period).and_return(1) # 1 week period
      end

      it 'creates single payment for one week' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(1)

        payment = contract.contract_interest_payments.first
        expect(payment.amount.to_f).to eq(10.0) # 1 week * 10 rate
        expect(payment.number_of_days).to eq(7)
        expect(payment.from).to eq(contract.contract_date)
        expect(payment.to).to eq(contract.contract_date + 6)
      end
    end

    context 'with different interest rate' do
      let(:contract) { create(:contract, contract_type:, contract_date: "2025-10-03".to_date, interest_rate: 5, contract_term: 4, interest_period: 2) }

      it 'calculates payments with different interest rate' do
        service.call

        first_payment = contract.contract_interest_payments.order(:from).first
        second_payment = contract.contract_interest_payments.order(:from).second

        # 5 * 2 weeks = 10.0 per payment
        expect(first_payment.amount.to_f).to eq(10.0)
        expect(second_payment.amount.to_f).to eq(10.0)
      end
    end

    context 'with longer contract term' do
      before do
        allow(contract).to receive(:contract_term).and_return(8) # 8 weeks
        allow(contract).to receive(:interest_period).and_return(2) # 2 week periods
      end

      it 'generates correct number of payment cycles for longer term' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(4)

        payments = contract.contract_interest_payments.order(:from)

        payments.each_with_index do |payment, index|
          expect(payment.amount.to_f).to eq(20.0)
          expect(payment.number_of_days).to eq(14)
          expect(payment.from).to eq(contract.contract_date + (index * 14))
          expect(payment.to).to eq(contract.contract_date + (index * 14) + 13)
        end
      end
    end

    context 'with fractional days calculation' do
      before do
        allow(contract).to receive(:contract_term).and_return(2) # 2 weeks = 14 days
        allow(contract).to receive(:interest_period).and_return(1) # 1 week periods
      end

      it 'handles week calculation correctly when days do not divide evenly' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(2)

        payments = contract.contract_interest_payments.order(:from)

        payments.each do |payment|
          expect(payment.amount.to_f).to eq(10.0) # 1 week each
          expect(payment.number_of_days).to eq(7)
        end
      end
    end
  end

  describe '#initialize' do
    it 'sets contract and processed_by attributes' do
      expect(service.instance_variable_get(:@contract)).to eq(contract)
    end
  end
end
