class Views::Shared::Contracts::Tabs::PayInterest::PayByDayForm < Views::Base
  def initialize(contract:)
    @contract = contract
    ctx = CustomInterestPayment::Operations::Create::Present.call(params: form_params.to_h)
    @form = ctx[:"contract.default"]
  end

  def view_template
    return disable_custom_interest_payment if Contract.config[:disable_custom_interest_payment]

    div(data: { controller: "shared--custom-interest-payment" }) do
      Form(action: form_url, method: "POST") do
        Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
        Input(type: "hidden", name: "form[contract_id]", value: contract.id)

        render Components::Fields::DateField.new(
          name: "form[from_date]",
          wrapper_class: "max-w-md flex items-center gap-2",
          readonly: true,
          label_classes: "w-sm",
          label: "Lãi từ ngày", id: "from_date", error: form.errors[:from_date].first,
          value: form.from_date,
          data: { "data-shared--custom-interest-payment_target": "fromDateInput" }
        )

        div(class: "flex gap-4 items-center") do
          render Components::Fields::DateField.new(
            name: "form[to_date]",
            wrapper_class: "max-w-md flex items-center gap-2",
            label_classes: "w-sm",
            label: "Đến ngày", id: "to_date", error: form.errors[:to_date].first,
            value: form.to_date,
            listen_change: true,
            data: {
              "data-shared--custom-interest-payment_target": "toDateInput",
              "data-contract-id": contract.id
            },
            input_actions: "change->shared--custom-interest-payment#calculateInterestByDays blur->shared--custom-interest-payment#setToValidDate"
          )

          p(class: "text-sm mt-0") do
            span { "Ngày đóng lãi tiếp theo: " }
            span(class: "font-medium", data: { "shared--custom-interest-payment_target": "nextInterestDate" }) do
              form.next_interest_date.present? ? form.next_interest_date.to_date.to_fs(:date_vn) : "N/A"
            end
          end
        end

        div(class: "flex gap-4 items-center") do
          FormField(class: "space-y-2") do
            div(class: "max-w-md flex items-center gap-2") do
              FormFieldLabel(class: "w-sm") { "Số ngày" }
              div(class: "relative space-y-4 mb-0 w-full") do
                Input(
                  type: "number",
                  placeholder: "Nhập số ngày",
                  name: "form[days_count]",
                  value: form.days_count,
                  class: "pr-10",
                  min: "1",
                  data: {
                    controller: "number-input",
                    "contract-id": contract.id,
                    range_underflow: "Số ngày phải lớn hơn hoặc bằng 1",
                    "shared--custom-interest-payment_target": "daysCountInput",
                    action: "input->shared--custom-interest-payment#setToDateValue change->shared--custom-interest-payment#calculateInterestByDays"
                  }
                )

                span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "ngày" }
              end
            end

            div(class: "max-w-md flex items-center gap-2 justify-end") do
              span { "" }
              FormFieldError(class: "max-w-md mb-2") { form.errors[:days_count].first }
            end
          end
        end

        div(class: "flex gap-4 items-center") do
          FormField(class: "space-y-2 max-w-md flex items-center gap-2") do
            FormFieldLabel(class: "w-sm") { "Tiền lãi" }
            span(class: "w-full text-sm text-green-500", data: { "shared--custom-interest-payment_target": "interestAmount" }) { "300.000 VNĐ" }
            input(
              type: "hidden", name: "form[interest_amount]", value: form.interest_amount,
              data: { "shared--custom-interest-payment_target": "interestAmountInput" }
            )
          end
        end

        div(class: "flex gap-4 items-center") do
          FormField(class: "space-y-2 max-w-md flex items-center gap-2") do
            FormFieldLabel(class: "w-sm") { "Tiền khác" }
            div(class: "relative space-y-4 mb-0 w-full") do
              MaskedInput(
                data: {
                  maska_number_locale: "vi",
                  "shared--custom-interest-payment_target": "otherAmountInput",
                  action: "input->shared--custom-interest-payment#recalculateTotalInterest"
                },
                placeholder: "Nhập số tiền khác",
                name: "form[other_amount]",
                value: form.other_amount.to_i,
                class: "pr-10"
              )

              span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
            end

            FormFieldError() { form.errors[:other_amount].first }
          end
        end

        div(class: "flex gap-4 items-center") do
          FormField(class: "space-y-2 max-w-md flex items-center gap-2") do
            FormFieldLabel(class: "w-sm") { "Tổng tiền lãi" }
            span(class: "w-full text-sm text-red-500", data: { "shared--custom-interest-payment_target": "totalInterestAmount" }) { "300.000 VNĐ" }
            input(
              type: "hidden", name: "form[total_interest_amount]", value: form.total_interest_amount,
              data: { "shared--custom-interest-payment_target": "totalInterestAmountInput" }
            )
          end
        end

        div(class: "flex gap-4 items-center") do
          FormField(class: "space-y-2 max-w-md flex items-center gap-2") do
            FormFieldLabel(class: "w-sm") { "Tiền khách đưa" }
            div(class: "relative space-y-4 mb-0 w-full") do
              MaskedInput(
                data: {
                  maska_number_locale: "vi",
                  maska_number_unsigned: true,
                  "shared--custom-interest-payment_target": "customerPaymentAmountInput"
                },
                placeholder: "Nhập số tiền khách đưa",
                name: "form[customer_payment_amount]",
                value: form.customer_payment_amount.to_i,
                class: "pr-10"
              )

              span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
            end

            FormFieldError() { form.errors[:customer_payment_amount].first }
          end
        end

        FormField(class: "space-y-2 max-w-md flex items-center gap-4") do
          FormFieldLabel(class: "w-sm") { "Ghi chú" }
          Textarea(name: "form[note]", class: "w-full", rows: 3, placeholder: "Nhập ghi chú nếu có") { form.note }
          FormFieldError() { form.errors[:note].first }
        end

        div(class: "mt-4 w-md flex justify-end space-x-2") do
          Button(variant: :outline,
            data: {
              action: "ruby-ui--collapsible#close shared--custom-interest-payment#resetForm"
            }) { "Hủy" }
          Button(type: "submit") { "Đóng lãi" }
        end
      end
    end
  end

  private

  attr_reader :contract, :form

  def disable_custom_interest_payment
    Alert(variant: :warning) do
      AlertDescription { "Chưa hỗ trợ chức năng đóng lãi tuỳ biến theo ngày" }
    end
  end

  def form_url
    contracts_custom_interest_payments_path(contract)
  end

  def form_params
    params = ActionController::Parameters.new(
      form: {
        from_date: from_date,
        to_date: to_date,
        interest_amount: 0,
        other_amount: 0,
        total_interest_amount: 0,
        customer_payment_amount: 0
      }
    )

    params.require(:form).permit(
      :from_date,
      :to_date,
      :days_count,
      :interest_amount,
      :other_amount,
      :total_interest_amount,
      :customer_payment_amount
    )
  end

  def from_date
    @from_date ||= (contract.nearest_unpaid_interest_payment&.from || contract.contract_date)
  end

  def to_date
    if from_date < Date.current
      Date.current
    else
      from_date
    end
  end

  def unpaid_interest_payments
    @unpaid_interest_payments ||= contract.contract_interest_payments.unpaid.order(:from)
  end

  def paid_interest_payments
    @paid_interest_payments ||= contract.contract_interest_payments.paid.order(:from)
  end
end
