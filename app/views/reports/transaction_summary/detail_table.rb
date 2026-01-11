class Views::Reports::TransactionSummary::DetailTable < Views::Base
  def initialize(transactions:, pagy: nil)
    @transactions = transactions
    @pagy = pagy
  end

  def view_template
    div(class: "p-6 space-y-4 bg-background text-foreground") do
      div(class: "space-y-0") do
        div(class: "flex gap-2") do
          Remix::CashLine(class: "w-6 h-6")
          h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Chi tiết giao dịch" }
        end
        Table do
          TableHeader do
            TableRow do
              TableHead { "STT" }
              TableHead { "Loại hình" }
              TableHead { "Mã HĐ" }
              TableHead { "Tài sản" }
              TableHead { "Người GD" }
              TableHead { "Khách hàng" }
              TableHead { "Ngày GD" }
              TableHead { "Diễn Giải" }
              TableHead { "Đã Thu" }
              TableHead { "Đã Chi" }
              TableHead { "Ghi chú" }
            end
          end
          TableBody do
            TableRow do
              TableCell(class: "font-medium") { "1" }
              TableCell(class: "font-medium") { "Cầm đồ" }
              TableCell(class: "font-medium") { "CD-2" }
              TableCell(class: "font-medium") { "LT" }
              TableCell(class: "font-medium") { "A" }
              TableCell(class: "font-medium text-blue-600") { "xGames" }
              TableCell(class: "font-medium") { "10/01/2026 17:31" }
              TableCell(class: "font-medium") { "Tạo mới hợp động" }
              TableCell(class: "font-medium text-blue-600") { "" }
              TableCell(class: "font-medium text-red-600") { "-25,000,000" }
              TableCell(class: "font-medium") { "" }
            end
            TableRow do
              TableCell(class: "font-medium") { "2" }
              TableCell(class: "font-medium") { "Cầm đồ" }
              TableCell(class: "font-medium") { "CD-2" }
              TableCell(class: "font-medium") { "LT" }
              TableCell(class: "font-medium") { "A" }
              TableCell(class: "font-medium text-blue-600") { "xGames" }
              TableCell(class: "font-medium") { "10/01/2026 17:32" }
              TableCell(class: "font-medium") { "Update hợp động" }
              TableCell(class: "font-medium text-blue-600") { "" }
              TableCell(class: "font-medium text-red-600") { "" }
              TableCell(class: "font-medium") { "" }
            end

            # Tổng hàng
            TableRow(class: "border-t-2 border-gray-300 bg-gray-50") do
              TableCell(colspan: 7, class: "font-semibold text-right") { "Tổng:" }
              TableCell(class: "font-semibold") { "" }
              TableCell(class: "font-semibold text-blue-600") { "0" }
              TableCell(class: "font-semibold text-red-600") { "-25,000,000" }
              TableCell(class: "font-semibold") { "" }
            end
          end
        end
      end
    end
  end
end
