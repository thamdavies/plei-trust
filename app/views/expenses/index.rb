class Views::Expenses::Index < Views::Base
  def initialize(collection:, form:, pagy: nil)
    @collection = collection
    @form = form
    @pagy = pagy
  end

  def view_template
    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách hợp đồng sẽ được hiển thị ở đây" } if @collection.empty?
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
          @collection.each_with_index do |contract, index|
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium") { "12/12/1998" }
              TableCell(class: "font-medium") { "Tham" }
              TableCell(class: "font-medium") { "Thu khac" }
              TableCell(class: "font-medium") { "Thích" }
              TableCell(class: "font-medium") { "10.000.000" }
              TableCell(class: "font-medium") { "NV A" }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  Remix::PrinterLine(class: "w-5 h-5 cursor-pointer")
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
