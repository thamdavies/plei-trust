class Views::Shared::Contracts::InterestForm < Views::Base
  def initialize(form:)
    @form = form
  end

  attr_reader :form

  def view_template
    div(class: "hidden", data: { "shared--contract_target": "interestFieldsWrapper" }) do
      FormField(class: "max-w-sm") do
        FormFieldLabel { "Lãi suất" }
        div(class: "relative") do
          Input(
            type: "number",
            placeholder: "Nhập lãi suất",
            name: "form[interest_rate]",
            value: form.interest_rate,
            class: "pr-10",
            validate: false,
            data: {
              controller: "number-input",
              "shared--contract_target": "interestRateInput"
            }
          )
          span(
            class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500",
            data: { "shared--contract_target": "interestUnit" }
          ) { "%/tháng" }
        end

        FormFieldError() { form.errors[:interest_rate].first }
      end

      div(class: "flex gap-4 items-center") do
        FormField(class: "w-sm") do
          FormFieldLabel { "Kỳ lãi" }
            Input(
              type: "number",
              placeholder: "Nhập kỳ lãi",
              name: "form[interest_period]",
              value: form.interest_period,
              class: "pr-10",
              data: {
                controller: "number-input",
                "shared--contract_target": "interestPeriodInput"
              }
            )

          FormFieldError() { form.errors[:interest_period].first }
        end
        span(
          class: "text-sm text-gray-500 mt-5",
          data: { "shared--contract_target": "interestPeriodUnit" }
        ) { "(VD: 1 tháng đóng lãi 1 lần thì điền số 1)" }
      end

      FormField(class: "max-w-sm") do
        FormFieldLabel { "Thời gian vay" }
        Input(
          type: "number",
          data: {
            controller: "number-input",
            "shared--contract_target": "contractTermDaysInput"
          },
          placeholder: "Nhập số ngày vay",
          name: "form[contract_term_days]",
          value: form.contract_term_days,
          class: "pr-10"
        )

        FormFieldError() { form.errors[:contract_term_days].first }
      end
    end
  end
end
