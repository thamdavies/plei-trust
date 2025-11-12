# frozen_string_literal: true

module PawnContract::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::Contract, :find)
      step :preprocess_params
      step Contract::Build(constant: PawnContract::Contracts::Create)

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
      amount = changes.last.to_d - changes.first.to_d

      if amount.negative?
        parameters[:debit_amount] = amount.abs
      else
        parameters[:credit_amount] = amount
      end

      parameters = model.reverse_debit_amount_params(parameters)
      model.create_activity! key: "activity.contract.update", owner: current_user, parameters: parameters

      true
    end
  end
end
