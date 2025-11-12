class Views::Shared::Contracts::ContractInfo < Views::Base
  def initialize(contract:)
    @contract = contract
    @customer = contract.customer || Customer.new
  end

  def view_template
    div(class: "flex mb-4") do
      Table do
        TableBody do
          TableRow do
            TableCell(class: "font-bold") { customer.full_name }
            TableCell(class: "font-medium") do
              div(class: "flex gap-4 items-center") do
                if customer.phone.present?
                  div(class: "flex text-sm items-center text-gray-500 dark:text-gray-400") do
                    Remix::PhoneLine(class: "w-4 h-4 mr-2")
                    span { customer.phone }
                  end
                end
                if customer.national_id.present?
                  div(class: "flex text-sm items-center text-gray-500 dark:text-gray-400") do
                    Remix::IdCardLine(class: "w-4 h-4 mr-2")
                    span { customer.national_id }
                  end
                end
              end
            end
          end
          TableRow do
            TableCell(class: "font-medium") { contract_type_label(type: contract.contract_type_code.to_sym).loan_amount }
            TableCell(class: "font-medium") { contract.total_amount_currency }
          end
          TableRow do
            TableCell(class: "font-medium") { "Lãi suất" }
            TableCell(class: "font-medium") { contract.fm_interest_rate }
          end
          TableRow do
            TableCell(class: "font-medium") { "Vay từ ngày" }
            TableCell(class: "font-medium") { contract.fm_contract_term }
          end
        end
      end

      Table do
        TableBody do
          TableRow do
            TableCell(class: "font-medium") { "Tổng lãi" }
            TableCell(class: "font-medium") { contract.fm_total_interest }
          end
          TableRow do
            TableCell(class: "font-medium") { "Đã thanh toán" }
            TableCell(class: "font-medium") { contract.fm_paid_interest }
          end
          TableRow do
            TableCell(class: "font-medium") { "Nợ cũ KH: " + customer.fm_old_debt_amount }
            TableCell(class: "font-medium") { "Nợ cũ HĐ: " + contract.fm_old_debt_amount }
          end
          TableRow do
            TableCell(class: "font-medium") { "Trạng thái" }
            TableCell(class: "font-medium") { contract.status_badge }
          end
        end
      end
    end
  end

  private

  attr_reader :contract, :customer
end
