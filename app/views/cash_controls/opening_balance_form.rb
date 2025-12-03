class Views::CashControls::OpeningBalanceForm < Views::Base
  def initialize(form: nil)
    if form.present?
      @form = form
    else
      ctx = CashControl::Operations::UpdateOpeningBalance::Present.call(params: form_params.to_h)
      @form = ctx[:"contract.default"]
    end
  end

  def form_params
    { amount: "0" }
  end

  def view_template
    div(class: "rounded-lg border p-6 bg-background") do
      div(class: "flex items-center gap-2 mb-4") do
        Remix::MoneyDollarBoxLine(class: "w-5 h-5 text-green-600")
        h3(class: "text-lg font-semibold text-gray-900 dark:text-white") { "Nhập tiền đầu ngày" }
      end

      div(class: "space-y-4") do
        Form(action: form_url, method: "POST") do
          div(class: "opening-balance-wrapper") do
            FormField(class: "space-y-2") do
              div(class: "max-w-md") do
                FormFieldLabel(class: "w-sm") { "Số tiền" }
                div(class: "relative space-y-4 mb-0 w-full pt-1") do
                  MaskedInput(
                    data: {
                      maska_number_locale: "vi",
                      maska_number_unsigned: true
                    },
                    placeholder: "0",
                    name: "form[amount]",
                    value: form.amount.to_i,
                    class: "pr-10 mb-0"
                  )

                  span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
                end
              end

              FormFieldError(class: "max-w-md mt-0 mb-2 flex items-center gap-2 justify-start") { form.errors[:amount].first }
            end
          end

          Button(type: :submit) { "Nhập tiền" }
        end
      end
    end
  end

  private

  attr_reader :form

  def form_url
    update_opening_balance_cash_controls_path
  end
end
