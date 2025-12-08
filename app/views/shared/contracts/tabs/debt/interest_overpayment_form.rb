class Views::Shared::Contracts::Tabs::Debt::InterestOverpaymentForm < Views::Base
  def initialize(contract:, form: nil)
    @contract = contract
    if form.present?
      @form = form
    else
      ctx = Debt::Operations::Create::Present.call(params: form_params.to_h)
      @form = ctx[:"contract.default"]
    end
  end

  def form_params
    { amount: 0, contract_id: contract.id }
  end

  def view_template
    div(class: "rounded-lg border p-6 bg-background") do
      div(class: "flex items-center gap-2 mb-4") do
        Remix::HandCoinLine(class: "w-5 h-5 text-yellow-600")
        h3(class: "text-lg font-semibold text-gray-900 dark:text-white") { "Khách hàng nợ lãi - Trả tiền thừa" }
      end

      div(class: "space-y-4") do
        Form(action: form_url, method: "POST") do
          input(type: "hidden", name: "form[contract_id]", value: contract.id)
          div(class: "overdue-debt-wrapper") do
            FormField(class: "space-y-2") do
              div(class: "max-w-md") do
                FormFieldLabel(class: "w-sm") { "Số tiền nợ lại" }
                div(class: "relative space-y-4 mb-0 w-full pt-1") do
                  MaskedInput(
                    data: {
                      maska_number_locale: "vi",
                      maska_number_unsigned: true
                    },
                    placeholder: "0",
                    name: "form[amount]",
                    value: form.amount,
                    class: "pr-10 mb-0"
                  )

                  span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
                end
              end

              FormFieldError(class: "max-w-md mt-0 mb-2 flex items-center gap-2 justify-start") { form.errors[:amount].first }
            end
          end

          button(
            class: "w-full flex items-center justify-center gap-2 rounded-md bg-red-500 px-4 py-2 text-sm font-medium text-white hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-500"
          ) do
            Remix::Save3Line(class: "w-4 h-4")
            plain "Ghi nợ"
          end
        end
      end
    end
  end

  private

  attr_reader :contract, :form

  def form_url
    contracts_debts_path
  end
end
