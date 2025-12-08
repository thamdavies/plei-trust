class Views::Contracts::Reminders::Index < Views::Base
  def initialize(collection:, pagy:)
    @collection = collection
    @pagy = pagy
  end

  def view_template
    render Views::Shared::Contracts::ShowModal.new

    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách hợp đồng đang hẹn sẽ hiển thị ở đây" } if @collection.empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Khách hàng" }
            TableHead { "Mã HĐ" }
            TableHead { "Loại hình" }
            TableHead { "Ngày hẹn" }
            TableHead { "Nội dung" }
          end
        end
        TableBody do
          @collection.each_with_index do |item, index|
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium") { item.customer_name }
              TableCell(class: "font-medium") do
                span(class: "cursor-pointer text-blue-600 underline flex items-center", data: {
                  action: "click->resource#triggerDialog",
                  controller: "resource",
                  resource_path_value: contracts_capital_path(item.contract_id),
                  resource_dialogbutton_value: "contract-modal-dialog-trigger"
                }) do
                  Remix::ExternalLinkLine(class: "w-4 h-4 inline-block mr-1")
                  span { item.contract.code }
                end
              end
              TableCell(class: "font-medium") { item.contract_type_name }
              TableCell(class: "font-medium") { item.fm_remind_date }
              TableCell(class: "font-medium") { item.note }
            end
          end
        end
      end
    end
  end
end
