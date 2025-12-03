module Expense::Operations
  class Index < ApplicationOperation
    step :format_created_date
    step :filter
    step :sort

    def filter(ctx, params:, current_branch:, **)
      ctx[:model] = current_branch.financial_transactions.expense_types.includes(:transaction_type, :created_by).ransack(ctx[:params][:q]).result
    end

    def sort(ctx, params:, model:, **)
      ctx[:model] = model.order(id: :desc)
    end
  end
end
