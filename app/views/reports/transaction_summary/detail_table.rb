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
            @transactions.each_with_index do |item, index|
              TableRow do
                TableCell(class: "font-medium") { index + 1 }
                TableCell(class: "font-medium") { item.contract_type_name }
                TableCell(class: "font-medium") { item.contract_code }
                TableCell(class: "font-medium") { item.asset_name }
                TableCell(class: "font-medium") { item.transaction_by }
                TableCell(class: "font-medium text-blue-600") { item.customer_name }
                TableCell(class: "font-medium") { item.transaction_date }
                TableCell(class: "font-medium") { item.description }
                TableCell(class: "font-medium text-blue-600") { item.amount_in }
                TableCell(class: "font-medium text-red-600") { item.amount_out }
                TableCell(class: "font-medium") { item.notes }
              end
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
