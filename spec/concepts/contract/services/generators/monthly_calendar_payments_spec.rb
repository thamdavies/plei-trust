require 'rails_helper'

RSpec.describe Contract::Services::Generators::MonthlyCalendarPayments do
  let(:contract_type) { create(:contract_type, :capital, code: :capital) }
  let(:contract) { create(:contract, :monthly_calendar, contract_type:, contract_date: "2025-10-02".to_date, loan_amount: 20_000_000, interest_rate: 0.5, contract_term: 3, interest_period: 1, interest_calculation_method: InterestCalculationMethod.config[:code][:monthly_calendar]) }
  let(:processed_by) { create(:user) }
  let(:service) { described_class.new(contract: contract) }

  describe '#call' do
    it 'generates correct number of payment cycles' do
      service.call
      expect(contract.contract_interest_payments.size).to eq(3)
    end

    it 'calculates payment amounts correctly using monthly calendar formula' do
      service.call

      payments = contract.contract_interest_payments.order(:from)

      payments.each do |payment|
        # Fixed amount per period regardless of actual days: loan_amount * monthly_percent
        expect(payment.amount.to_f).to eq(100.0)
      end
    end

    it 'sets correct payment date ranges using calendar months with varying days' do
      service.call

      payments = contract.contract_interest_payments.order(:from)

      # First period: Oct 2 to Nov 2 (32 days including both ends)
      expect(payments[0].number_of_days).to eq(32)
      expect(payments[0].from).to eq("2025-10-02".to_date)
      expect(payments[0].to).to eq("2025-11-02".to_date)

      # Second period: Nov 2 to Dec 2 (31 days including both ends)
      expect(payments[1].number_of_days).to eq(31)
      expect(payments[1].from).to eq("2025-11-02".to_date)
      expect(payments[1].to).to eq("2025-12-02".to_date)

      # Third period: Dec 2 to Jan 2 (32 days including both ends)
      expect(payments[2].number_of_days).to eq(32)
      expect(payments[2].from).to eq("2025-12-02".to_date)
      expect(payments[2].to).to eq("2026-01-02".to_date)
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
        expect(payment.amount.to_f).to eq(200.0) # Fixed amount regardless of period length
        expect(payment.from).to eq(contract.contract_date)
        expect(payment.to).to eq(contract.contract_date + 2.months)
      end
    end

    context 'with different interest rate' do
      let(:contract) { create(:contract, :monthly_calendar, contract_type:, contract_date: "2025-10-02".to_date, loan_amount: 20_000_000, interest_rate: 1.0, contract_term: 3, interest_period: 1) }

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
          expect(payment.amount.to_f).to eq(200.0)
        end

        # Each period should span 2 calendar months
        expect(payments[0].from).to eq("2025-10-02".to_date)
        expect(payments[0].to).to eq("2025-12-02".to_date)

        expect(payments[1].from).to eq("2025-12-02".to_date)
        expect(payments[1].to).to eq("2026-02-02".to_date)

        expect(payments[2].from).to eq("2026-02-02".to_date)
        expect(payments[2].to).to eq("2026-04-02".to_date)
      end
    end

    context 'with leap year calculations' do
      let(:contract) { create(:contract, :monthly_calendar, contract_date: "2024-02-01".to_date, loan_amount: 20_000_000, interest_rate: 0.5, contract_term: 2, interest_period: 1) }

      it 'handles leap year February correctly' do
        service.call

        payments = contract.contract_interest_payments.order(:from)

        expect(payments[0].from).to eq("2024-02-01".to_date)
        expect(payments[0].to).to eq("2024-03-01".to_date)
        expect(payments[0].number_of_days).to eq(30) # Feb 1 to Mar 1 in leap year (29 days in Feb + 1)

        expect(payments[1].from).to eq("2024-03-01".to_date)
        expect(payments[1].to).to eq("2024-04-01".to_date)
        expect(payments[1].number_of_days).to eq(32) # Mar 1 to Apr 1 (31 days in Mar + 1)
      end
    end
  end

  describe '#initialize' do
    it 'sets contract and processed_by attributes' do
      expect(service.instance_variable_get(:@contract)).to eq(contract)
    end
  end
end
