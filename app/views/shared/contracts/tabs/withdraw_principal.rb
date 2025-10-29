class Views::Shared::Contracts::Tabs::WithdrawPrincipal < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "withdraw_principal") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          turbo_frame_tag "withdraw_principal_form" do
            render Views::Shared::Contracts::Tabs::WithdrawPrincipal::Form.new(contract:)
          end
        end
      end
    end
  end

  private

  attr_reader :contract
end
