class Views::Incomes::Index < Views::Base
  def initialize(collection:, form:, pagy: nil)
    @collection = collection
    @form = form
    @pagy = pagy
  end

  def view_template
    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách thu nhập sẽ hiển thị ở đây" } if @collection.empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Ngày thu" }
            TableHead { "Khách hàng" }
            TableHead { "Loại phiếu" }
            TableHead { "Lý do" }
            TableHead { "Số tiền" }
            TableHead { "Nhân viên" }
            TableHead { "" }
          end
        end
        TableBody do
          @collection.each_with_index do |item, index|
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium") { item.fm_transaction_date }
              TableCell(class: "font-medium") { item.party_name }
              TableCell(class: "font-medium") { item.transaction_type.name }
              TableCell(class: "font-medium") { item.description }
              TableCell(class: "font-medium") { item.amount_formatted }
              TableCell(class: "font-medium") { item.created_by.full_name }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  Remix::PrinterLine(class: "w-5 h-5 cursor-pointer")
                  Link(href: income_path(item.id), class: "w-5 h-5 cursor-pointer p-0", data: { turbo_method: :delete, turbo_confirm: "Bạn có chắc chắn muốn hủy phiếu thu này?" }) do
                    Remix::DeleteBinLine(class: "w-5 h-5 cursor-pointer")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
