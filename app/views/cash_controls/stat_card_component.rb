class Views::CashControls::StatCardComponent < Views::Base
  def initialize(amount: "$2,602", title: "TỔNG QUỸ TIỀN MẶT")
    @amount = amount
    @title = title
  end

  def view_template
    Card(class: "w-96 overflow-hidden") do
      CardHeader do
        div(class: "w-10 h-10 rounded-xl flex items-center justify-center bg-violet-100 text-violet-700 -rotate-6") do
          Remix::CashLine(class: "w-6 h-6 rotate-6")
        end
      end
      CardContent(class: "space-y-1") do
        CardDescription(class: "font-medium") { @title }
        h5(class: "font-semibold text-4xl") { @amount }
      end
    end
  end
end
