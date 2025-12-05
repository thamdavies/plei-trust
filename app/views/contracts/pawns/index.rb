class Views::Contracts::Pawns::Index < Views::Base
  def initialize(collection:, form:, pagy: nil)
    @collection = collection
    @form = form
    @pagy = pagy
  end

  def view_template
    render Views::Contracts::Pawns::Modal.new
    render Views::Shared::Contracts::ShowModal.new

    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách hợp đồng sẽ được hiển thị ở đây" } if @collection.empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Khách hàng" }
            TableHead { "Mã TS" }
            TableHead { "Tài sản" }
            TableHead { "Tiền cầm" }
            TableHead { "Ngày cầm" }
            TableHead { "Lãi đã đóng" }
            TableHead { "Tiền nợ" }
            TableHead { "Lãi đến hôm nay" }
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
              TableCell(class: "font-medium") { contract.asset_setting.asset_code }
              TableCell(class: "font-medium") { contract.asset_name }
              TableCell(class: "font-medium") { contract.total_amount_formatted }
              TableCell(class: "font-medium") { contract.fm_contract_date }
              TableCell(class: "font-medium") { contract.total_paid_interest_formatted }
              TableCell(class: "font-medium") { contract.fm_old_debt_amount(unit: false) }
              TableCell(class: "font-medium") { contract.fm_current_interest_amount }
              TableCell(class: "font-medium") { contract.fm_due_date }
              TableCell(class: "font-medium") { contract.status_badge }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  Remix::EditBoxLine(
                    class: "w-5 h-5 cursor-pointer",
                    data: {
                      action: "click->resource#triggerDialog",
                      controller: "resource",
                      resource_path_value: edit_contracts_pawn_path(contract.id),
                      resource_dialogbutton_value: "pawn-dialog-trigger"
                    }
                  )
                  Remix::BarChartBoxLine(
                    class: "w-5 h-5 cursor-pointer",
                    data: {
                      action: "click->resource#triggerDialog",
                      controller: "resource",
                      resource_path_value: contracts_pawn_path(contract.id),
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
