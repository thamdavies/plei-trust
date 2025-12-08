# frozen_string_literal: true

module Staff::Operations
  class Update < ApplicationOperation
    # Only used to setup the form.
    class Present < ApplicationOperation
      step Model(User, :find)
      step Contract::Build(constant: Staff::Contracts::Update)
      step :assign_params

      def assign_params(ctx, model:, params:, **)
        if params[:password].blank? && params[:password_confirmation].blank?
          model.skip_password_validation = true
        end

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
