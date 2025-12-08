class Views::Contracts::Reminders::Index < Views::Base
  def initialize(collection:, pagy:)
    @collection = collection
    @pagy = pagy
  end

  def view_template
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
              TableCell(class: "font-medium") { item.contract.code }
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
