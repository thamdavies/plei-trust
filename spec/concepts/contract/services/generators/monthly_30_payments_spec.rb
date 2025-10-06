require 'rails_helper'

RSpec.describe Contract::Services::Generators::Monthly30Payments do
  let(:contract_type) { create(:contract_type, code: :capital) }
  let(:contract) { create(:contract, contract_type:, contract_date: "2025-10-02".to_date, loan_amount: 20_000_000, interest_rate: 0.5, contract_term: 3, interest_period: 1, interest_calculation_method: InterestCalculationMethod.config[:code][:monthly_30]) }
  let(:processed_by) { create(:user) }
  let(:service) { described_class.new(contract: contract, processed_by: processed_by) }

  describe '#call' do
    it 'generates correct number of payment cycles' do
      service.call
      expect(contract.contract_interest_payments.size).to eq(3)
    end

    it 'calculates payment amounts correctly using monthly 30-day formula' do
      service.call

      payments = contract.contract_interest_payments.order(:from)

      payments.each do |payment|
        # amount = loan_amount * monthly_percent = 20,000,000 * 0.005 = 100,000
        expect(payment.amount.to_f).to eq(100.0)
      end
    end

    it 'sets correct payment date ranges with standardized 30-day periods' do
      service.call

      payments = contract.contract_interest_payments.order(:from)

      expect(payments[0].number_of_days).to eq(30)
      expect(payments[0].from).to eq("2025-10-02".to_date)
      expect(payments[0].to).to eq("2025-10-31".to_date)

      expect(payments[1].number_of_days).to eq(30)
      expect(payments[1].from).to eq("2025-11-01".to_date)
      expect(payments[1].to).to eq("2025-11-30".to_date)

      expect(payments[2].number_of_days).to eq(30)
      expect(payments[2].from).to eq("2025-12-01".to_date)
      expect(payments[2].to).to eq("2025-12-30".to_date)
    end

    context 'when contract term is not evenly divisible by payment frequency' do
      before do
        allow(contract).to receive(:contract_term).and_return(2) # 2 months
        allow(contract).to receive(:interest_period).and_return(3) # 3 month periods
      end

      it 'handles partial final payment period correctly' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(1)

        payment = contract.contract_interest_payments.first
        expect(payment.amount.to_f).to eq(100.0)
        expect(payment.number_of_days).to eq(60) # 2 months * 30 days
        expect(payment.from).to eq(contract.contract_date)
        expect(payment.to).to eq(contract.contract_date + 59)
      end
    end

    context 'with different interest rate' do
      let(:contract) { create(:contract, contract_type:, contract_date: "2025-10-02".to_date, loan_amount: 20_000_000, interest_rate: 1.0, contract_term: 3, interest_period: 1) }

      it 'calculates payments with different interest rate' do
        service.call

        payments = contract.contract_interest_payments.order(:from)

        payments.each do |payment|
          # amount = 20,000,000 * 0.01 = 200,000
          expect(payment.amount.to_f).to eq(200.0)
        end
      end
    end

    context 'with multi-month payment periods' do
      before do
        allow(contract).to receive(:contract_term).and_return(6) # 6 months
        allow(contract).to receive(:interest_period).and_return(2) # 2 month periods
      end

      it 'generates correct number of payment cycles for multi-month periods' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(3)

        payments = contract.contract_interest_payments.order(:from)

        payments.each do |payment|
          expect(payment.amount.to_f).to eq(100.0)
          expect(payment.number_of_days).to eq(60) # 2 months * 30 days
        end
      end
    end

    context 'with single month contract term' do
      before do
        allow(contract).to receive(:contract_term).and_return(1) # 1 month
        allow(contract).to receive(:interest_period).and_return(1) # 1 month period
      end

      it 'creates single payment for one month' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(1)

        payment = contract.contract_interest_payments.first
        expect(payment.amount.to_f).to eq(100.0)
        expect(payment.number_of_days).to eq(30)
        expect(payment.from).to eq(contract.contract_date)
        expect(payment.to).to eq(contract.contract_date + 29)
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
