class Views::Shared::StatCardComponent < Views::Base
  def initialize(amount: "N/A", title: "N/A", variant: :simple)
    @amount = amount
    @title = title
    @color_class = random_color_class
    @variant = variant
  end

  def view_template
    Card(class: "w-96 overflow-hidden") do
      if @variant == :icon
        CardHeader do
          div(class: "w-10 h-10 rounded-xl flex items-center justify-center #{@color_class} -rotate-6") do
            Remix::CashLine(class: "w-6 h-6 rotate-6")
          end
        end
      end

      CardContent(class: "space-y-1 #{'pt-4' if @variant == :simple}") do
        CardDescription(class: "font-medium") { @title }
        h5(class: "font-semibold text-4xl") { @amount }
      end
    end
  end

  private

  def random_color_class
    colors = [
      "bg-violet-100 text-violet-700",
      "bg-blue-100 text-blue-700",
      "bg-green-100 text-green-700",
      "bg-red-100 text-red-700",
      "bg-yellow-100 text-yellow-700",
      "bg-pink-100 text-pink-700",
      "bg-indigo-100 text-indigo-700",
      "bg-orange-100 text-orange-700",
      "bg-teal-100 text-teal-700",
      "bg-cyan-100 text-cyan-700"
    ]
    colors.sample
  end
end
