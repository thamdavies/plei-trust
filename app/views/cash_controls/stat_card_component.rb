class Views::CashControls::StatCardComponent < Views::Base
  def initialize(amount: "$2,602", title: "TỔNG QUỸ TIỀN MẶT")
    @amount = amount
    @title = title
  end

  def view_template
    Card(class: "w-96 overflow-hidden") do
      CardContent(class: "space-y-1 pt-4") do
        CardDescription(class: "font-medium") { @title }
        h5(class: "font-semibold text-4xl") { @amount }
      end
    end
  end
end
