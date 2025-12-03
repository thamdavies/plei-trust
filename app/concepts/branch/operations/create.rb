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
      step :create_capital_customer
      step :create_capital_contract
    }

    def create_capital_customer(ctx, model:, current_user:, **)
      ActsAsTenant.with_tenant(model) do
        ctx[:seed_capital_customer] = current_user.create_seed_capital_customer(branch: model)
      end

      true
    end

    def create_capital_contract(ctx, model:, current_user:, **)
      ActsAsTenant.with_tenant(model) do
        model.contracts.create!(
          contract_date: Date.current,
          contract_term: 0,
          is_default_capital: true,
          interest_calculation_method: InterestCalculationMethod.config[:code][:investment_capital],
          interest_rate: 0.0,
          loan_amount: model.invest_amount * 1_000,
          interest_period: 0,
          status: "active",
          cashier: current_user,
          contract_type_code: ContractType.codes[:capital],
          customer: ctx[:seed_capital_customer],
          created_by: current_user,
        )
      end

      true
    end
  end
end
