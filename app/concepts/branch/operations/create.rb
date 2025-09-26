# frozen_string_literal: true

module Branch::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(Branch, :new)
      step Contract::Build(constant: Branch::Contracts::Create)
    end

    step Wrap(AppTransaction) {
      step Subprocess(Present)
      step Contract::Validate()
      step Contract::Persist()

      # step :create_capital_contract
    }

    def create_capital_contract(ctx, model:, **)
      contract_type = ContractType.find_by(code: "capital")
      model.branch.branch_contract_types.create!(contract_type: contract_type) if contract_type.present?
      true
    rescue StandardError => e
      ctx[:errors] = { base: [ e.message ] }
      false
    end
  end
end
