class Views::Shared::Contracts::Tabs::ExtendTerm < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "extend_term") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          turbo_frame_tag "extend_term_form" do
            render Views::Shared::Contracts::Tabs::ExtendTerm::Form.new(contract:)
          end

          div(class: "flex gap-2") do
            Remix::ListView(class: "w-6 h-6")
            h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Lịch sử gia hạn" }
          end

          Table do
            TableCaption { "Lịch sử gia hạn sẽ được hiển thị ở đây" } if contract.contract_extensions.empty?
            TableHeader do
              TableRow do
                TableHead { "STT" }
                TableHead(class: "text-center") { "Gia hạn từ ngày" }
                TableHead { "Đến ngày" }
                TableHead { "Số ngày" }
                TableHead { "Ghi chú" }
              end
            end
            TableBody do
              contract.contract_extensions.each_with_index do |item, index|
                TableRow do
                  TableCell(class: "font-medium") { index + 1 }
                  TableCell(class: "text-center") { item.fm_from_date }
                  TableCell(class: "text-center") { item.fm_to_date }
                  TableCell { item.number_of_days }
                  TableCell(class: "text-center") { item.note }
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
