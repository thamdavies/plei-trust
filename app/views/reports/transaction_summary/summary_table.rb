class Views::Reports::TransactionSummary::SummaryTable < Views::Base
  def initialize(summary:, pagy: nil)
    @summary = summary
    @pagy = pagy
  end

  def view_template
    div(class: "p-6 space-y-4 bg-background text-foreground") do
      div(class: "space-y-0") do
        div(class: "flex gap-2") do
          Remix::ListView(class: "w-6 h-6")
          h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Bảng tổng kết giao dịch" }
        end
        Table do
          TableHeader do
            TableRow do
              TableHead { "Loại hình giao dịch" }
              TableHead { "Thu" }
              TableHead { "Chi" }
              TableHead { "Tổng cộng" }
            end
          end
          TableBody do
            TableRow do
              TableCell { "Tiền đầu ngày" }
              TableCell { "-" }
              TableCell { "-" }
              TableCell(class: "font-semibold #{@summary.opening_balance >= 0 ? 'text-blue-600' : 'text-red-600'}") { @summary.opening_balance.to_currency(unit: "") }
            end
            TableRow do
              TableCell { "Cầm Đồ" }
              TableCell(class: "text-blue-600") { @summary.pawn.amount_in.to_currency(unit: "") }
              TableCell(class: "text-red-600") { @summary.pawn.amount_out.to_currency(unit: "") }
              TableCell(class: "font-semibold #{@summary.pawn.difference >= 0 ? 'text-blue-600' : 'text-red-600'}") { @summary.pawn.difference.to_currency(unit: "") }
            end
            TableRow do
              TableCell { "Trả Góp" }
              TableCell(class: "text-blue-600") { @summary.installment.amount_in.to_currency(unit: "") }
              TableCell(class: "text-red-600") { @summary.installment.amount_out.to_currency(unit: "") }
              TableCell(class: "font-semibold #{@summary.installment.difference >= 0 ? 'text-blue-600' : 'text-red-600'}") { @summary.installment.difference.to_currency(unit: "") }
            end
            TableRow do
              TableCell { "Thu Hoạt Động" }
              TableCell(class: "text-blue-600") { @summary.income.amount_in.to_currency(unit: "") }
              TableCell(class: "text-red-600") { @summary.income.amount_out.to_currency(unit: "") }
              TableCell(class: "font-semibold #{@summary.income.difference >= 0 ? 'text-blue-600' : 'text-red-600'}") { @summary.income.difference.to_currency(unit: "") }
            end
            TableRow do
              TableCell { "Chi Hoạt Động" }
              TableCell(class: "text-blue-600") { @summary.expense.amount_in.to_currency(unit: "") }
              TableCell(class: "text-red-600") { @summary.expense.amount_out.to_currency(unit: "") }
              TableCell(class: "font-semibold #{@summary.expense.difference >= 0 ? 'text-blue-600' : 'text-red-600'}") { @summary.expense.difference.to_currency(unit: "") }
            end
            TableRow do
              TableCell { "Nguồn Vốn" }
              TableCell(class: "text-blue-600") { @summary.capital.amount_in.to_currency(unit: "") }
              TableCell(class: "text-red-600") { @summary.capital.amount_out.to_currency(unit: "") }
              TableCell(class: "font-semibold #{@summary.capital.difference >= 0 ? 'text-blue-600' : 'text-red-600'}") { @summary.capital.difference.to_currency(unit: "") }
            end
            TableRow(class: "border-t-2 border-gray-300") do
              TableCell(class: "font-semibold") { "Tiền mặt còn lại" }
              TableCell { "-" }
              TableCell { "-" }
              TableCell(class: "font-semibold #{@summary.remaining_cash >= 0 ? 'text-blue-600' : 'text-red-600'}") { @summary.remaining_cash.to_currency(unit: "") }
            end
          end
        end
      end
    end
  end
end
