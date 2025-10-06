class Views::Shared::Contracts::Tabs::ExtendTerm < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "extend_term") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          Text(size: "4", weight: "semibold") { "Gia hạn" }
          Text(size: "2", class: "text-muted-foreground") { "Thông tin chi tiết về việc gia hạn." }
        end
      end
    end
  end

  private

  attr_reader :contract
end
