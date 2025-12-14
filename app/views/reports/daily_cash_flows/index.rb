class Views::Reports::DailyCashFlows::Index < Views::Base
  include Phlex::Rails::Helpers::NumberWithDelimiter

  def initialize(daily_flows:, summary:, pagy: nil)
    @daily_flows = daily_flows
    @summary = summary
    @pagy = pagy
  end

  def view_template
    div(class: "p-4 bg-white") do
      div(class: "overflow-x-auto") do
        Table do
          TableCaption(class: "mb-3") { "Báo cáo dòng tiền lưu chuyển theo ngày" } if @daily_flows&.empty?
          TableHeader do
            TableRow(style: "background-color: #3f86c3;") do
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "STT [1]" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Ngày" }
                br
                span { "[2]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "Tiền đầu ngày [3]" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "Cầm đồ [4]" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "Tín Chấp [5]" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "Trả Góp [6]" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "Thu chi [7]" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "Vốn [8]" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "Tiền cuối ngày [9]=[3+4+5+6+7+8]" }
              TableHead(class: "text-center text-white border border-gray-300", colspan: 3) { "Đang cho vay+Khách nợ" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") { "Vốn đi vay [13]" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Tổng tài sản" }
                br
                span { "[14]=[9+10+11+12-13]" }
              end
            end
            TableRow(style: "background-color: #3f86c3;") do
              TableHead(class: "text-center text-white border border-gray-300") { "Cầm đồ [10]" }
              TableHead(class: "text-center text-white border border-gray-300") { "Tín Chấp [11]" }
              TableHead(class: "text-center text-white border border-gray-300") { "Trả Góp [12]" }
            end
          end
          TableBody do
            if @daily_flows&.any?
              @daily_flows.each_with_index do |flow, index|
                TableRow(class: "hover:bg-gray-50") do
                  TableCell(class: "text-center border border-gray-300") { index + 1 }
                  TableCell(class: "text-center border border-gray-300") { flow[:date] }
                  TableCell(class: "text-right border border-gray-300") { number_with_delimiter(flow[:opening_balance]) }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow[:pawn])}") { number_with_delimiter(flow[:pawn]) }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow[:credit])}") { number_with_delimiter(flow[:credit]) }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow[:installment])}") { number_with_delimiter(flow[:installment]) }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow[:income_expense])}") { number_with_delimiter(flow[:income_expense]) }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow[:capital])}") { number_with_delimiter(flow[:capital]) }
                  TableCell(class: "text-right border border-gray-300", style: "background-color: #fffaed;") { number_with_delimiter(flow[:closing_balance]) }
                  TableCell(class: "text-right border border-gray-300") { number_with_delimiter(flow[:pawn_receivable]) }
                  TableCell(class: "text-right border border-gray-300") { number_with_delimiter(flow[:credit_receivable]) }
                  TableCell(class: "text-right border border-gray-300") { number_with_delimiter(flow[:installment_receivable]) }
                  TableCell(class: "text-right border border-gray-300") { number_with_delimiter(flow[:capital_payable]) }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow[:total_assets])}", style: "background-color: #fffaed;") { number_with_delimiter(flow[:total_assets]) }
                end
              end
            end

            # Summary rows
            TableRow(style: "background-color: #ede8ab;") do
              TableCell(colspan: 2, class: "border border-gray-300 font-semibold text-amber-900") { "Quỹ tiền đầu kỳ" }
              TableCell(colspan: 2, class: "text-right border border-gray-300 font-semibold #{number_color_class(@summary[:opening_balance])}") { number_with_delimiter(@summary[:opening_balance]) }
              TableCell(colspan: 2, class: "border border-gray-300 font-semibold text-amber-900") { "Quỹ tiền cuối kỳ" }
              TableCell(colspan: 2, class: "text-right border border-gray-300 font-semibold #{number_color_class(@summary[:closing_balance])}") { number_with_delimiter(@summary[:closing_balance]) }
              TableCell(class: "border border-gray-300 font-semibold text-amber-900") { "Tài sản đầu kỳ" }
              TableCell(colspan: 2, class: "text-right border border-gray-300 font-semibold #{number_color_class(@summary[:opening_assets])}") { number_with_delimiter(@summary[:opening_assets]) }
              TableCell(colspan: 2, class: "border border-gray-300 font-semibold text-amber-900") { "Tài sản cuối kỳ" }
              TableCell(colspan: 2, class: "text-right border border-gray-300 font-semibold #{number_color_class(@summary[:closing_assets])}") { number_with_delimiter(@summary[:closing_assets]) }
            end

            TableRow(style: "background-color: #ede8ab;") do
              TableCell(colspan: 4, class: "border border-gray-300 font-semibold text-amber-900") { "Chênh lệch" }
              TableCell(colspan: 3, class: "text-center border border-gray-300 font-semibold #{number_color_class(@summary[:difference])}") { number_with_delimiter(@summary[:difference]) }
              TableCell(colspan: 4, class: "border border-gray-300 font-semibold text-amber-900") { "Lợi nhuận" }
              TableCell(colspan: 3, class: "text-center border border-gray-300 font-semibold #{number_color_class(@summary[:profit])}") { number_with_delimiter(@summary[:profit]) }
            end
          end
        end
      end
    end
  end

  private

  def number_color_class(value)
    return "text-red-600" if value.nil? || value <= 0

    "text-blue-600"
  end
end
