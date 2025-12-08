class Views::Shared::Contracts::Form < Views::Base
  def initialize(form:, contract_type:)
    @form = form
    @contract_type = contract_type
  end

  def view_template
    div(data: { controller: "shared--contract" }) do
      Text(class: "text-sm mb-2 text-red-500 italic") { "Bạn phải huỷ bỏ kỳ lãi đã thanh toán để cập nhật thông tin hợp đồng" } if !form.can_edit_contract

      if contract_type == :pawn
        render Views::Shared::Contracts::AssetFormFields.new(form:)
      end

      FormField(class: "max-w-sm") do
        FormFieldLabel { contract_type_label.loan_amount }
        div(class: "relative") do
          MaskedInput(
            data: { maska_number_locale: "vi", maska_number_unsigned: true },
            placeholder: "Nhập #{contract_type_label.loan_amount.downcase}",
            name: "form[loan_amount]",
            value: form.loan_amount.to_i,
            readonly: !form.can_edit_contract,
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
        readonly: !form.can_edit_contract,
        label: contract_type_label.contract_date, id: "contract_date", error: form.errors[:contract_date].first,
        value: form.contract_date
      )

      div(class: "flex gap-4 items-center") do
        FormField(class: "w-sm") do
          FormFieldLabel { "Hình thức lãi" }
          select(
            name: "form[interest_calculation_method]",
            readonly: !form.can_edit_contract,
            disabled: !form.can_edit_contract,
            id: "select-contract-type",
            placeholder: "Chọn hình thức lãi",
            data: { controller: "slim-select",
              "slim-select-target": "select",
              "shared--contract_target": "interestMethodSelect",
              "slim-select-selected-value": form.interest_calculation_method,
              action: "change->shared--contract#handleInterestMethodChange"
            }) do
            view_context.select_options_for_interest_types(contract_type: contract_type).each do |interest_method|
              option(value: interest_method.code, selected: interest_method.code == form.interest_calculation_method) { interest_method.name }
            end
          end
          FormFieldError() { form.errors[:interest_calculation_method].first }
        end

        div(class: "flex items-center space-x-3 mt-4") do
          Checkbox(
            id: "collect_interest_in_advance",
            name: "form[collect_interest_in_advance]",
            checked: form.collect_interest_in_advance,
            value: "true",
            disabled: !form.can_edit_contract,
          )
          label(for: "collect_interest_in_advance", class: "text-sm cursor-pointer font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70") { "Thu lãi trước" }
        end
      end

      render Views::Shared::Contracts::InterestForm.new(form:, contract_type:)

      div(class: "grid w-full max-w-sm items-center gap-1.5") do
        FormField do
          FormFieldLabel(for: "textarea") { "Ghi chú" }
          Textarea(
            placeholder: "Nhập ghi chú",
            id: "textarea",
            name: "form[note]",
          ) { form.note }
          FormFieldError()
        end
      end
    end
  end

  private

  attr_reader :form, :contract_type
end
