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
              TableCell(class: "font-semibold text-blue-600") { "450,120,000" }
            end
            TableRow do
              TableCell { "Cầm Đồ" }
              TableCell(class: "text-blue-600") { "0" }
              TableCell(class: "text-red-600") { "-25,000,000" }
              TableCell(class: "font-semibold text-red-600") { "-25,000,000" }
            end
            TableRow do
              TableCell { "Tín Chấp" }
              TableCell(class: "text-blue-600") { "0" }
              TableCell(class: "text-red-600") { "0" }
              TableCell(class: "font-semibold text-blue-600") { "0" }
            end
            TableRow do
              TableCell { "Trả Góp" }
              TableCell(class: "text-blue-600") { "0" }
              TableCell(class: "text-red-600") { "0" }
              TableCell(class: "font-semibold text-blue-600") { "0" }
            end
            TableRow do
              TableCell { "Thu Hoạt Động" }
              TableCell(class: "text-blue-600") { "0" }
              TableCell(class: "text-red-600") { "0" }
              TableCell(class: "font-semibold text-blue-600") { "0" }
            end
            TableRow do
              TableCell { "Chi Hoạt Động" }
              TableCell(class: "text-blue-600") { "0" }
              TableCell(class: "text-red-600") { "0" }
              TableCell(class: "font-semibold text-blue-600") { "0" }
            end
            TableRow do
              TableCell { "Nguồn Vốn" }
              TableCell(class: "text-blue-600") { "0" }
              TableCell(class: "text-red-600") { "0" }
              TableCell(class: "font-semibold text-blue-600") { "0" }
            end
            TableRow(class: "border-t-2 border-gray-300") do
              TableCell(class: "font-semibold") { "Tiền mặt còn lại" }
              TableCell { "-" }
              TableCell { "-" }
              TableCell(class: "font-semibold text-blue-600") { "425,120,000" }
            end
          end
        end
      end
    end
  end
end
