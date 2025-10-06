class Views::Shared::Contracts::Tabs::ReducePrincipal < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "reduce_principal") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          Text(size: "4", weight: "semibold") { "Reduce Principal" }
          Text(size: "2", class: "text-muted-foreground") { "This is the reduce principal tab content." }
        end
      end
    end
  end

  private

  attr_reader :contract
end
