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
      ctx[:seed_capital_customer] = current_user.create_seed_capital_customer(branch: model)
      true
    end

    def create_capital_contract(ctx, model:, current_user:, **)
      ::Contract.create!(
        asset_name: "Vốn khởi tạo",
        code: SecureRandom.hex(4).upcase,
        contract_date: Date.current,
        contract_term_days: 0,
        interest_calculation_method: "investment_capital",
        interest_rate: 0.0,
        loan_amount: model.invest_amount,
        payment_frequency_days: 0,
        status: "active",
        branch: model,
        cashier: current_user,
        contract_type: ContractType.capital.first,
        customer: ctx[:seed_capital_customer],
        created_by: current_user,
      )

      true
    end
  end
end
