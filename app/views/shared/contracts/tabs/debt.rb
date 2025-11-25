class Views::Shared::Contracts::Tabs::Debt < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "debt") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        # Payment sections
        div(class: "grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6") do
          # Left section - Overdue debt
          turbo_frame_tag "overdue_debt_form" do
            render Views::Shared::Contracts::Tabs::Debt::OverdueDebtForm.new(contract:)
          end
          # Right section - Payment
          turbo_frame_tag "payment_form" do
            render Views::Shared::Contracts::Tabs::Debt::PaymentForm.new(contract:)
          end
        end
      end
    end
  end

  private

  attr_reader :contract
end
