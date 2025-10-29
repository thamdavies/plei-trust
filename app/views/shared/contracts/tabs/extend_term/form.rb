class Views::Shared::Contracts::Tabs::ExtendTerm::Form < Views::Base
  def initialize(contract:, form: nil)
    @contract = contract
    if form.present?
      @form = form
    else
      ctx = ExtendTerm::Operations::Update::Present.call(params: form_params.to_h)
      @form = ctx[:"contract.default"]
    end
  end

  def view_template
    div do
      Form(action: form_url, method: "PATCH") do
        Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
        Input(type: "hidden", name: "form[contract_id]", value: contract.id)

        div(class: "flex gap-4 items-center mt-2") do
          FormField(class: "space-y-2") do
            div(class: "max-w-md flex items-center gap-2") do
              FormFieldLabel(class: "w-sm") { "Gia hạn thêm" }
              div(class: "relative space-y-4 mb-0 w-full") do
                Input(
                  type: "number",
                  placeholder: "1",
                  name: "form[number_of_days]",
                  value: form.number_of_days,
                  class: "pr-10",
                  validate: false,
                  data: { controller: "number-input" }
                )

                span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "ngày" }
              end
            end

            FormFieldError(class: "max-w-md mt-0 mb-2 flex items-center gap-2 justify-end") { form.errors[:number_of_days].first }
          end
        end

        FormField(class: "space-y-2 max-w-md flex items-center gap-4") do
          FormFieldLabel(class: "w-sm") { "Ghi chú" }
          Textarea(name: "form[note]", class: "w-full", rows: 3, placeholder: "Nhập ghi chú nếu có") { form.note }
          FormFieldError() { form.errors[:note].first }
        end

        div(class: "mt-4 w-md flex justify-end space-x-2") do
          Button(type: "submit") { "Đồng ý" }
        end
      end
    end
  end

  private

  attr_reader :contract, :form

  def form_url
    contracts_extend_term_path(id: contract.id)
  end

  def form_params
    params = ActionController::Parameters.new(
      form: {
        contract_id: contract.id,
        number_of_days: 30,
        note: ""
      }
    )

    params.require(:form).permit(
      :contract_id,
      :number_of_days,
      :note
    )
  end
end
