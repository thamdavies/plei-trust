class Views::Shared::Contracts::Tabs::File::CustomerFileForm < Views::Base
  def initialize(contract:, form: nil)
    @contract = contract
    if form.present?
      @form = form
    else
      ctx = Debt::Operations::Destroy::Present.call(params: form_params.to_h)
      @form = ctx[:"contract.default"]
    end
  end

  def form_params
    { amount: 0, contract_id: contract.id }
  end

  def view_template
    div(class: "rounded-lg border p-6 bg-background") do
      div(class: "flex items-center gap-2 mb-4") do
        Remix::Upload2Line(class: "w-5 h-5 text-green-600")
        h3(class: "text-lg font-semibold text-gray-900 dark:text-white") { "Upload ảnh khách hàng" }
      end

      div(class: "space-y-4") do
        Form(action: form_url, method: "DELETE") do
          input(type: "hidden", name: "form[contract_id]", value: contract.id)
          div(class: "overdue-debt-wrapper") do
            FormField(class: "space-y-2") do
              div(class: "max-w-md") do
                FormFieldLabel(class: "w-sm") { "Số tiền trả nợ" }
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

          button(
            class: "w-full flex items-center justify-center gap-2 rounded-md bg-blue-500 px-4 py-2 text-sm font-medium text-white hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
          ) do
            Remix::CheckLine(class: "w-4 h-4")
            plain "Thanh toán"
          end
        end
      end
    end
  end

  private

  attr_reader :contract, :form

  def form_url
    contracts_debt_path(contract)
  end
end
