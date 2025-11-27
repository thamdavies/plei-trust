class Views::Shared::Contracts::Tabs::File < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "file") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6") do
          # Left section - Customer file
          turbo_frame_tag "customer_file_form" do
            render Views::Shared::Contracts::Tabs::File::CustomerFileForm.new(contract:)
          end
          # Right section - Contract file
          turbo_frame_tag "contract_file_form" do
            render Views::Shared::Contracts::Tabs::File::ContractFileForm.new(contract:)
          end
        end
      end
    end
  end

  private

  attr_reader :contract
end
