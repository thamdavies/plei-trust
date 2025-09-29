class Views::Shared::Contracts::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  attr_reader :form

  def view_template
    FormField(class: "max-w-sm") do
      FormFieldLabel { "Số tiền đầu tư" }
      div(class: "relative") do
        MaskedInput(
          data: { maska_number_locale: "vi", maska_number_unsigned: true },
          placeholder: "Nhập số tiền đầu tư",
          name: "form[loan_amount]",
          value: form.loan_amount.to_i,
          class: "pr-10"
        )
        span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
      end

      p(class: "text-sm font-medium text-destructive") do
        form.errors[:loan_amount].first
      end
    end

    render Components::Fields::DateField.new(
      name: "form[contract_date]",
      wrapper_class: "max-w-sm",
      label: "Ngày góp", id: "contract_date", error: form.errors[:contract_date].first,
      value: form.contract_date
    )

    div(class: "flex gap-4 items-center") do
      FormField(class: "w-sm") do
        FormFieldLabel { "Hình thức lãi" }
        select(
          name: "form[interest_calculation_method]",
          id: "select-contract-type",
          placeholder: "Chọn hình thức lãi",
          data: { controller: "slim-select",
            'slim-select-target': "select",
            'slim-select-selected-value': form.interest_calculation_method,
            action: "change->page--asset-setting#handleInterestMethodChange"
          }) do
          view_context.select_options_for_interest_types().each do |interest_method|
            option(value: interest_method.code, selected: interest_method.code == form.interest_calculation_method) { interest_method.name }
          end
        end
        FormFieldError() { form.errors[:interest_calculation_method].first }
      end

      div(class: "flex items-center space-x-3 mt-4") do
        Checkbox(id: "collect_interest_in_advance", name: "form[collect_interest_in_advance]", checked: form.collect_interest_in_advance, value: "true")
        label(for: "collect_interest_in_advance", class: "text-sm cursor-pointer font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70") { "Thu lãi trước" }
      end
    end

    div(class: "grid w-full max-w-sm items-center gap-1.5") do
      FormField do
        FormFieldLabel(for: "textarea") { "Ghi chú" }
        Textarea(placeholder: "Nhập ghi chú", id: "textarea")
        FormFieldError()
      end
    end
  end
end
