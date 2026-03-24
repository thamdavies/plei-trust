class Views::Expenses::Index < Views::Base
  def initialize(collection:, form:, pagy: nil)
    @collection = collection
    @form = form
    @pagy = pagy
  end

  def view_template
    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách chi tiêu sẽ hiển thị ở đây" } if @collection.empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Ngày chi" }
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
            canceled = item.canceled_at.present? && item.reference_number.blank?
            amount = item.amount_display.negative? ? item.amount_display * -1 : item.amount_display * -1
            fmt_amount = if amount.positive?
              "+#{amount.to_currency(unit: "")}"
            else
              amount.to_currency(unit: "")
            end
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium #{"line-through" if canceled}") { item.fm_transaction_date }
              TableCell(class: "font-medium #{"line-through" if canceled}") { item.party_name }
              TableCell(class: "font-medium #{"line-through" if canceled}") { item.transaction_type.name }
              TableCell(class: "font-medium #{"line-through" if canceled}") { item.description }
              TableCell(class: "font-medium #{"line-through" if canceled}") { fmt_amount }
              TableCell(class: "font-medium #{"line-through" if canceled}") { item.created_by.full_name }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  Remix::PrinterLine(class: "w-5 h-5 cursor-pointer")
                  Link(href: expense_path(item.id), class: "w-5 h-5 cursor-pointer p-0", data: { turbo_method: :delete, turbo_confirm: "Bạn có chắc chắn muốn hủy phiếu chi này?" }) do
                    Remix::DeleteBinLine(class: "w-5 h-5 cursor-pointer")
                  end if item.canceled_at.blank?
                end
              end
            end
          end
        end
      end
    end
  end
end
