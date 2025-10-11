# frozen_string_literal: true

module CapitalContract::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::Contract, :find)
      step :preprocess_params
      step Contract::Build(constant: CapitalContract::Contracts::Create)

      def preprocess_params(ctx, params:, **)
        if params[:collect_interest_in_advance].blank?
          params[:collect_interest_in_advance] = false
        end

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step Contract::Persist()
      step :create_contract_interest_payments
    }

    private

    def create_contract_interest_payments(ctx, model:, **)
      service = ::Contract::Services::CreateContractInterestPayment.new(contract: model)
      service.call
      true
    end
  end
end
