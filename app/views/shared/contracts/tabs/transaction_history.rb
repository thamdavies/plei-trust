class Views::Shared::Contracts::Tabs::TransactionHistory < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "transaction_history") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          div(class: "flex gap-2") do
            Remix::ListView(class: "w-6 h-6")
            h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Lịch sử thao tác" }
          end
          Table(class: "mt-4") do
            TableCaption { "Lịch sử thao tác sẽ được hiển thị ở đây" } if contract.activities.blank?
            TableHeader do
              TableRow do
                TableHead { "STT" }
                TableHead(class: "text-center") { "Thời gian" }
                TableHead { "Giao dịch viên" }
                TableHead { "Số tiền ghi nợ" }
                TableHead { "Số tiền ghi có" }
                TableHead { "Nội dung" }
                TableHead { "Ghi chú" }
                TableHead { "Tiền khác" }
              end
            end
            TableBody do
              contract.activities.includes(:owner).each_with_index do |item, index|
                TableRow do
                  TableCell(class: "font-medium") { index + 1 }
                  TableCell(class: "text-center") { item.fm_created_at }
                  TableCell() { item.owner_name }
                  TableCell(class: "text-center") { item.fm_debit_amount }
                  TableCell(class: "text-center") { item.fm_credit_amount }
                  TableCell() { I18n.t(item.key) }
                  TableCell() { item.fm_note }
                  TableCell() { item.fm_other_amount }
                end
              end
            end
          end
        end
      end
    end
  end

  private

  attr_reader :contract
end
