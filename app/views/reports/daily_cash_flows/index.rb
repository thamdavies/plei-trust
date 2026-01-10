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
          TableCaption(class: "mb-3") { "Báo cáo dòng tiền lưu chuyển theo ngày" } if @daily_flows.blank?
          TableHeader do
            TableRow(style: "background-color: #3f86c3;") do
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "STT" }
                br
                span { "[1]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Ngày" }
                br
                span { "[2]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Tiền đầu ngày" }
                br
                span { "[3]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Cầm đồ" }
                br
                span { "[4]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Thuê xe" }
                br
                span { "[5]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Trả Góp" }
                br
                span { "[6]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Thu chi" }
                br
                span { "[7]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Vốn" }
                br
                span { "[8]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Tiền cuối ngày" }
                br
                span { "[9]=[3+4+5+6+7+8]" }
              end
              TableHead(class: "text-center text-white border border-gray-300", colspan: 3) { "Đang cho vay + Khách nợ" }
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Vốn đi vay" }
                br
                span { "[13]" }
              end
              TableHead(rowspan: 2, class: "text-center text-white border border-gray-300") do
                span { "Tổng tài sản " }
                br
                span { "[14]=[9+10+11+12-13]" }
              end
            end
            TableRow(style: "background-color: #3f86c3;") do
              TableHead(class: "text-center text-white border border-gray-300 p-2") do
                span { "Cầm đồ" }
                br
                span { "[10]" }
              end
              TableHead(class: "text-center text-white border border-gray-300 p-2") do
                span { "Thuê xe" }
                br
                span { "[11]" }
              end
              TableHead(class: "text-center text-white border border-gray-300 p-2") do
                span { "Trả Góp" }
                br
                span { "[12]" }
              end
            end
          end
          TableBody do
            if @daily_flows.present?
              @daily_flows.each_with_index do |flow, index|
                TableRow(class: "hover:bg-gray-50") do
                  TableCell(class: "text-center border border-gray-300") { index + 1 }
                  TableCell(class: "text-center border border-gray-300") { flow.fm_date }
                  TableCell(class: "text-right border border-gray-300") { flow.fm_opening_balance }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow.pawn_total_amount)}") { flow.fm_pawn_total }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow.credit_total_amount)}") { flow.fm_credit_total }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow.installment_total_amount)}") { flow.fm_installment_total }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow.income_expense_total_amount)}") { flow.fm_income_expense_total }
                  TableCell(class: "text-right border border-gray-300 #{number_color_class(flow.capital_total_amount)}") { flow.fm_capital_total }
                  TableCell(class: "text-right border border-gray-300 bg-[#fffaed]") { flow.fm_closing_balance }
                  TableCell(class: "text-right border border-gray-300") { flow.fm_active_pawn_total }
                  TableCell(class: "text-right border border-gray-300") { flow.fm_active_credit_total }
                  TableCell(class: "text-right border border-gray-300") { flow.fm_active_installment_total }
                  TableCell(class: "text-right border border-gray-300") { flow.fm_capital_payable_total }
                  TableCell(class: "text-right border border-gray-300 bg-[#fffaed]") { flow.fm_asset_total }
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
