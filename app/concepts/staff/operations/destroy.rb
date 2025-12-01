# frozen_string_literal: true

module Staff::Operations
  class Destroy < ApplicationOperation
    step Model(User, :find)
    step :delete!

    def delete!(ctx, model:, **)
      model.destroy!
    end
  end
end
