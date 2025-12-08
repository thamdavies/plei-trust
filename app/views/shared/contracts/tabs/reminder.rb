class Views::Shared::Contracts::Tabs::Reminder < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "reminder") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          turbo_frame_tag "reminder_form" do
            render Views::Shared::Contracts::Tabs::Reminder::Form.new(contract:)
          end

          div(class: "flex gap-2") do
            Remix::ListView(class: "w-6 h-6")
            h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Lịch sử hẹn giờ" }
          end
          Table do
            TableCaption { "Lịch sử hẹn giờ sẽ được hiển thị ở đây" } if contract.reminders.empty?
            TableHeader do
              TableRow do
                TableHead { "STT" }
                TableHead { "Trạng thái" }
                TableHead { "Hẹn đến ngày" }
                TableHead { "Ghi chú" }
                TableHead { "Ngày tạo" }
              end
            end
            TableBody do
              contract.reminders.each_with_index do |item, index|
                TableRow do
                  TableCell(class: "font-medium") { index + 1 }
                  TableCell { item.fm_state }
                  TableCell { item.fm_remind_date }
                  TableCell { item.note }
                  TableCell { item.fm_created_at }
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
