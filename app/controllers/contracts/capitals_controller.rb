class Contracts::CapitalsController < ApplicationController
  add_breadcrumb "Quản lý nguồn vốn", :contracts_capitals_path
  def index
    add_breadcrumb "Danh sách", :contracts_capitals_path

    run(CapitalContract::Operations::Index, current_user:, current_branch:) do |result|
      @pagy, contracts = pagy(result[:model])
      @contracts = contracts.decorate
      ctx = CapitalContract::Operations::Create::Present.call
      @form = ctx[:"contract.default"]
    end
  end

  def new
    ctx = CapitalContract::Operations::Create::Present.call
    @form = ctx[:"contract.default"]
    @form.interest_calculation_method = "investment_capital"
  end
end
