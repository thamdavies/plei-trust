class Views::Shared::Contracts::Tabs::BorrowMore < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "borrow_more") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          Text(size: "4", weight: "semibold") { "Vay thêm" }
          Text(size: "2", class: "text-muted-foreground") { "Thông tin chi tiết về việc vay thêm." }
        end
      end
    end
  end

  private

  attr_reader :contract
end
