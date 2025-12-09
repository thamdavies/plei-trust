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
      step :create_activity_log
    }

    private

    def create_contract_interest_payments(ctx, model:, **)
      service = ::Contract::Services::ContractInterestPaymentGenerator.new(contract: model)
      service.call
      true
    end

    def create_activity_log(ctx, model:, current_user:, **)
      debit_amount = 0
      credit_amount = 0
      parameters = {
        debit_amount:,
        credit_amount:
      }

      last_version = model.versions.last
      changes = last_version.changeset["loan_amount"].presence || []

      if changes.blank?
        parameters[:debit_amount] = 0
        parameters[:credit_amount] = 0
      else
        amount = changes.last.to_d - changes.first.to_d
        model.create_financial_transaction!(is_income: true, amount: amount * 1_000)
      end

      parameters = model.reverse_debit_amount_params(parameters)
      model.create_activity! key: "activity.contract.update", owner: current_user, parameters: parameters

      true
    end
  end
end
