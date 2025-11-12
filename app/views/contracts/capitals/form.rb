class Views::Contracts::Capitals::Form < Views::Base
  def initialize(form:, url: nil, method: :post)
    @form = form
  end

  def view_template
    Form(action: form_url, method: form_method) do
      Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
      DialogHeader do
        DialogTitle { form.model.new_record? ? "Thêm hợp đồng mới" : "Chỉnh sửa hợp đồng" }
      end
      DialogMiddle do
        div(class: "flex gap-2") do
          Remix::Information2Line(class: "w-6 h-6")
          h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Thông tin khách hàng" }
        end

        render Views::Shared::Customers::Form.new(form:)
        RubyUI::Separator(class: "my-4")
        div(class: "flex gap-2") do
          Remix::ContractLine(class: "w-6 h-6")
          h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Thông tin hợp đồng" }
        end

        render Views::Shared::Contracts::Form.new(form:, contract_type: :capital)
      end
      DialogFooter do
        Button(variant: :outline, data: { action: "click->ruby-ui--dialog#dismiss" }) { I18n.t("button.close") }
        Button(type: "submit", disabled: !form.can_edit_contract) { I18n.t("button.save") }
      end
    end
  end

  private

  attr_reader :form

  def form_url
    if form.model.new_record?
      contracts_capitals_path
    else
      contracts_capital_path(form.model)
    end
  end
end
