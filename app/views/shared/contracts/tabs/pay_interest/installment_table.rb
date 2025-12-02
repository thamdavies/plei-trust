class Views::Shared::Contracts::Tabs::PayInterest::InstallmentTable < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    Table do
      TableCaption { "Danh sách các kỳ đóng lãi sẽ được hiển thị ở đây" } if contract.contract_interest_payments.blank?
      TableHeader do
        TableRow do
          TableHead { "STT" }
          TableHead(class: "text-center") { "Ngày" }
          TableHead { "Tiền gốc" }
          TableHead { "Tiền lãi" }
          TableHead { "Số dư" }
          TableHead { "Số tiền trả" }
          TableHead { "Tiền khách trả" }
          TableHead { "Chức năng" }
        end
      end
      TableBody do
        contract.contract_interest_payments.order(:from).each_with_index do |item, index|
          TableRow do
            TableCell(class: "font-medium") { index + 1 }
            TableCell { item.fm_dates }
            TableCell { item.fm_installment_principal_amount }
            TableCell { item.other_amount_formatted }
            TableCell { item.balance_formatted }
            TableCell { item.amount_formatted }
            TableCell do
              if item.paid?
                span(class: "text-green-600 font-medium") { item.total_paid_formatted }
              else
                MaskedInput(
                  data: {
                    maska_number_locale: "vi",
                    maska_number_unsigned: true,
                    "shared--contract-detail_target": "customerPaymentAmountInput"
                  },
                  class: "w-24 border rounded px-2 py-1",
                  placeholder: item.amount_formatted,
                  value: item.amount_formatted
                )
              end
            end
            TableCell do
              div(class: "flex items-center space-x-3") do
                Tooltip do
                  TooltipTrigger do
                    Checkbox(
                      id: item.id, class: "cursor-pointer", checked: item.paid?,
                      data: {
                        action: "click->shared--contract-detail#togglePaid",
                        "shared--contract-detail_target": "paymentCheckbox",
                        contract_id: contract.id
                      }
                    )
                  end
                  TooltipContent do
                    Text(size: :sm) { "Thanh toán" }
                  end
                end

                Tooltip do
                  TooltipTrigger do
                    Remix::StickyNoteLine(class: "h-5 w-5 cursor-pointer")
                  end
                  TooltipContent do
                    Text(size: :sm) { "Ghi chú" }
                  end
                end

                Tooltip(data: {
                    controller: "shared--pdf",
                    "shared--pdf_contract-id-value": contract.id,
                    "shared--pdf_interest-payment-id-value": item.id,
                    "shared--pdf_is-paid-value": "#{item.paid?}"
                  }) do
                  TooltipTrigger do
                    Remix::PrinterLine(class: "h-5 w-5 cursor-pointer", data: { action: "click->shared--pdf#printReceipt" })
                  end
                  TooltipContent do
                    Text(size: :sm) { "In Biên nhận đóng lãi" }
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  private

  attr_reader :contract
end
