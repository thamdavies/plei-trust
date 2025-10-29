class Views::Shared::Contracts::Tabs::WithdrawPrincipal::Form < Views::Base
  def initialize(contract:, form: nil)
    @contract = contract
    if form.present?
      @form = form
    else
      ctx = WithdrawPrincipal::Operations::Update::Present.call(params: form_params.to_h)
      @form = ctx[:"contract.default"]
    end
  end

  def view_template
    div(data: { controller: "shared--withdraw-principal" }) do
      Form(action: form_url, method: "PATCH") do
        Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
        Input(type: "hidden", name: "form[contract_id]", id: "withdraw_principal_contract_id", value: contract.id)

        render Components::Fields::DateField.new(
          name: "form[transaction_date]",
          wrapper_style: :inline,
          label_classes: "w-sm",
          label: "Ngày rút vốn",
          id: "withdraw_principal_transaction_date",
          error: form.errors[:transaction_date].first,
          listen_change: true,
          data: {
            "data-shared--withdraw-principal-target": "transactionDateInput"
          },
          input_actions: "change->shared--withdraw-principal#calculateInterestByDays",
          value: form.transaction_date,
        )

        div(class: "flex gap-4 items-center mt-2") do
          FormField(class: "space-y-2") do
            div(class: "max-w-md flex items-center gap-2") do
              FormFieldLabel(class: "w-sm") { "Tiền cầm" }
              div(class: "relative space-y-4 mb-0 w-full") do
                span(
                  class: "text-sm text-green-600", data: { "shared--withdraw-principal-target": "heldAmountText" }) do
                  contract.total_amount_currency
                end
              end
            end
          end
        end

        div(class: "flex gap-4 items-center mt-2") do
          FormField(class: "space-y-2") do
            div(class: "max-w-md flex items-center gap-2") do
              FormFieldLabel(class: "w-sm") { "Nợ cũ" }
              div(class: "relative space-y-4 mb-0 w-full") do
                span(class: "text-sm text-green-600", data: { "shared--withdraw-principal-target": "oldDebtText" }) do
                  "0 VNĐ"
                end
              end
            end
          end
        end

        div(class: "flex gap-4 items-center mt-2") do
          FormField(class: "space-y-2") do
            div(class: "max-w-md flex items-center gap-2") do
              FormFieldLabel(class: "w-sm") { "Tiền lãi" }
              div(class: "relative space-y-4 mb-0 w-full") do
                span(class: "text-sm text-green-600", data: { "shared--withdraw-principal-target": "interestAmountText" }) do
                  "0 VNĐ"
                end
              end
            end
          end
        end

        div(class: "flex gap-4 items-center mt-2") do
          FormField(class: "space-y-2") do
            div(class: "max-w-md flex items-center gap-2") do
              FormFieldLabel(class: "w-sm") { "Tiền khác" }
              div(class: "relative space-y-4 mb-0 w-full") do
                MaskedInput(
                  data: {
                    maska_number_locale: "vi",
                    maska_number_unsigned: true,
                    "shared--withdraw-principal-target": "otherAmountInput"
                  },
                  placeholder: "0",
                  name: "form[withdrawal_amount]",
                  value: form.withdrawal_amount.to_i,
                  class: "pr-10 mb-0"
                )

                span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
              end
            end

            FormFieldError(class: "max-w-md mt-0 mb-2 flex items-center gap-2 justify-end") { form.errors[:withdrawal_amount].first }
          end
        end

        FormField(class: "space-y-2 max-w-md flex items-center gap-4") do
          FormFieldLabel(class: "w-sm") { "Ghi chú" }
          Textarea(name: "form[note]", class: "w-full", rows: 3, placeholder: "Nhập ghi chú nếu có") { form.note }
          FormFieldError() { form.errors[:note].first }
        end

        div(class: "flex gap-4 items-center mt-2") do
          FormField(class: "space-y-2") do
            div(class: "max-w-md flex items-center gap-2") do
              FormFieldLabel(class: "w-sm") { "Tổng tiền" }
              div(class: "relative space-y-4 mb-0 w-full") do
                span(class: "text-sm text-red-600", data: { "shared--withdraw-principal-target": "totalAmountText" }) do
                  "0 VNĐ"
                end
              end
            end
          end
        end

        div(class: "mt-4 w-md flex justify-end space-x-2") do
          Button(type: "submit") { "Rút vốn" }
        end
      end
    end
  end

  private

  attr_reader :contract, :form

  def form_url
    contracts_withdraw_principal_path(id: contract.id)
  end

  def form_params
    params = ActionController::Parameters.new(
      form: {
        contract_id: contract.id,
        transaction_date: Date.current.to_fs(:date_vn),
        withdrawal_amount: "0",
        note: ""
      }
    )

    params.require(:form).permit(
      :contract_id,
      :transaction_date,
      :withdrawal_amount,
      :note
    )
  end
end
