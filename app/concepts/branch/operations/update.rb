# frozen_string_literal: true

module Branch::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(Branch, :find)
      step Contract::Build(constant: Branch::Contracts::Update)
    end

    step Wrap(AppTransaction) {
      step :build_fresh_contract
      step Subprocess(Present)
      step Contract::Validate()
      step Contract::Persist()
    }

    def build_fresh_contract(ctx, params:, **)
      params[:ward_id] = nil if params[:ward_id].blank?
      true
    end
  end
end
