# frozen_string_literal: true

module Staff::Operations
  class Index < ApplicationOperation
    step :model!
    step :filter!
    step :sort!

    def model!(ctx, params:, current_branch:, **)
      ctx[:model] = current_branch.users
    end

    def filter!(ctx, params:, model:, **)
      ctx[:model] = model.ransack(params[:q]).result
    end

    def sort!(ctx, params:, model:, **)
      ctx[:model] = model.order(id: :desc)
    end
  end
end
