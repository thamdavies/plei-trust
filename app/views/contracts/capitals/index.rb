class Views::Contracts::Capitals::Index < Views::Base
  def initialize(collection:, form:, pagy: nil)
    @collection = collection
    @form = form
    @pagy = pagy
  end

  def view_template
    render Views::Contracts::Capitals::Modal.new(form: @form)
    render Views::Shared::Contracts::ShowModal.new(contract: nil)

    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách hợp đồng sẽ được hiển thị ở đây" } if @collection.empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Khách hàng" }
            TableHead { "Số tiền (VNĐ)" }
            TableHead { "Ngày góp" }
            TableHead { "Loại vốn" }
            TableHead { "Lãi suất" }
            TableHead { "Lãi đã trả" }
            TableHead { "Ghi chú" }
            TableHead { "Ngày phải đóng lãi" }
            TableHead { "Tình trạng" }
            TableHead { "Chức năng" }
          end
        end
        TableBody do
          @collection.each_with_index do |contract, index|
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium") { contract.customer_name }
              TableCell(class: "font-medium") { contract.total_amount_formatted }
              TableCell(class: "font-medium") { contract.fm_contract_date }
              TableCell(class: "font-medium") { contract.capital_type }
              TableCell(class: "font-medium") { contract.fm_interest_rate }
              TableCell(class: "font-medium") { "" }
              TableCell(class: "font-medium") { contract.note }
              TableCell(class: "font-medium") { contract.fm_due_date }
              TableCell(class: "font-medium") { contract.status_badge }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  Remix::EditBoxLine(
                    class: "w-5 h-5 cursor-pointer",
                    data: {
                      action: "click->resource#triggerDialog",
                      controller: "resource",
                      resource_path_value: edit_contracts_capital_path(contract.id),
                      resource_dialogbutton_value: "capital-dialog-trigger"
                    }
                  )
                  Remix::BarChartBoxLine(
                    class: "w-5 h-5 cursor-pointer",
                    data: {
                      action: "click->resource#triggerDialog",
                      controller: "resource",
                      resource_path_value: contracts_capital_path(contract.id),
                      resource_dialogbutton_value: "contract-modal-dialog-trigger"
                    }
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
