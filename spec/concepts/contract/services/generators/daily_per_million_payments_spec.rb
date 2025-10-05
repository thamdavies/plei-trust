require 'rails_helper'

RSpec.describe Contract::Services::Generators::DailyPerMillionPayments do
  let(:contract_type) { create(:contract_type, code: :capital) }
  let(:contract) { create(:contract, contract_type:) }
  let(:processed_by) { create(:user) }
  let(:service) { described_class.new(contract: contract, processed_by: processed_by) }

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
        allow(contract).to receive(:contract_term_days).and_return(25)
      end

      it 'handles partial final payment period correctly' do
        service.call

        expect(contract.contract_interest_payments.size).to eq(1)
        expect(contract.contract_interest_payments.first.number_of_days).to eq(25)
        expect(contract.contract_interest_payments.first.from).to eq(contract.contract_date)
        expect(contract.contract_interest_payments.first.to).to eq(contract.contract_date + 24)
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
