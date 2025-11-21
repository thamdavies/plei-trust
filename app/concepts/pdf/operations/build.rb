module Pdf::Operations
  class Build < ApplicationOperation
    step :create_pdf_params

    def create_pdf_params(ctx, params:, **)
      activity = PublicActivity::Activity.create!(
        trackable: ctx[:current_user],
        key: "activity.pdf.contract.build",
        parameters: params,
        owner: ctx[:current_user],
      )

      ctx[:activity_id] = activity.id

      true
    end
  end
end
