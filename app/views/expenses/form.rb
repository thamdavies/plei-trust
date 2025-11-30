class Views::Expenses::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    Form(action: expenses_path, method: :post, id: "expense-form") do
      Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
      div(class: "flex gap-2") do
        Remix::HandCoinLine(class: "w-6 h-6")
        h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Nhập phiếu chi tiền" }
      end
      FormField(class: "max-w-sm") do
        FormFieldLabel { "Người nhận" }
        div(class: "relative") do
          Input(
            placeholder: "Nhập tên người nhận",
            name: "form[party_name]",
            value: form.party_name,
            class: "pr-10"
          )
        end

        FormFieldError() { form.errors[:party_name].first }
      end

      FormField(class: "max-w-sm") do
        FormFieldLabel { "Số tiền" }
        div(class: "relative") do
          MaskedInput(
            data: { maska_number_locale: "vi", maska_number_unsigned: true },
            placeholder: "Nhập số tiền",
            name: "form[amount]",
            value: form.amount.to_i,
            class: "pr-10"
          )
          span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
        end

        p(class: "text-sm font-medium text-destructive") do
          form.errors[:amount].first
        end
      end

      div(class: "flex gap-4 items-center") do
        FormField(class: "w-sm") do
          FormFieldLabel { "Loại phiếu" }
          select(
            name: "form[transaction_type_code]",
            id: "select-transaction-type-code",
            placeholder: "Chọn loại phiếu",
            data: { controller: "slim-select",
              "slim-select-target": "select",
              "slim-select-selected-value": form.transaction_type_code
            }) do
            view_context.select_options_for_transaction_types(is_income: false).each do |item|
              option(value: item.code, selected: item.code == form.transaction_type_code) { item.name }
            end
          end
          FormFieldError() { form.errors[:transaction_type_code].first }
        end
      end

      div(class: "grid w-full max-w-sm items-center gap-1.5") do
        FormField do
          FormFieldLabel(for: "textarea") { "Lý do chi tiền" }
          Textarea(placeholder: "Nhập lý do chi tiền", id: "textarea", name: "form[transaction_note]", rows: 4) { form.transaction_note }
          FormFieldError() { form.errors[:transaction_note].first }
        end
      end

      Button(type: "submit", class: "mt-4") { "Chi tiền" }
    end
  end

  private

  attr_reader :form
end
