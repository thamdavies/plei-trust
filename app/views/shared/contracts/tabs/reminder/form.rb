class Views::Shared::Contracts::Tabs::Reminder::Form < Views::Base
  def initialize(contract:, form: nil)
    @contract = contract
    if form.present?
      @form = form
    else
      ctx = ContractReminder::Operations::Create::Present.call(params: form_params.to_h)
      @form = ctx[:"contract.default"]
    end
  end

  def view_template
    div do
      Form(action: form_url, method: "POST") do
        Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
        Input(type: "hidden", name: "form[contract_id]", value: contract.id)

        render Components::Fields::DateField.new(
          name: "form[remind_date]",
          wrapper_style: :inline,
          label_classes: "w-sm",
          label: "Ngày hẹn",
          id: "remind_date",
          error: form.errors[:remind_date].first,
          value: form.remind_date,
        )

        FormField(class: "space-y-2 max-w-md flex items-center gap-4") do
          FormFieldLabel(class: "w-sm") { "Ghi chú" }
          Textarea(name: "form[note]", class: "w-full", rows: 3, placeholder: "Nhập ghi chú nếu có") { form.note }
          FormFieldError() { form.errors[:note].first }
        end

        div(class: "mt-4 w-md flex justify-end space-x-2") do
          Button(type: "submit") { "Tạo hẹn giờ" }
          Button(variant: :destructive, class: "text-white") { "Dừng hẹn giờ" }
        end
      end
    end
  end

  private

  attr_reader :contract, :form

  def form_url
    contracts_reminders_path
  end

  def form_params
    params = ActionController::Parameters.new(
      form: {
        contract_id: contract.id,
        remind_date: Date.current.to_fs(:date_vn),
        note: ""
      }
    )

    params.require(:form).permit(
      :contract_id,
      :remind_date,
      :note
    )
  end
end
