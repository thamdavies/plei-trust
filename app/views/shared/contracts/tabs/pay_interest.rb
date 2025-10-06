class Views::Shared::Contracts::Tabs::PayInterest < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "pay_interest") do
      div(class: "rounded-lg border p-4 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          Collapsible do
            div(class: "flex items-center justify-start pb-2") do
              CollapsibleTrigger do
                div(class: "flex items-center space-x-2 cursor-pointer") do
                  Remix::ExpandUpDownLine(class: "h-4 w-4")
                  span(class: "text-sm font-semibold") { "Chức năng đóng lãi tùy biến theo ngày" }
                end
                span(class: "sr-only") { "Toggle" }
              end
            end

            CollapsibleContent do
              div(class: "space-y-2 my-2") do
                div(class: "rounded-md border px-4 py-2 font-mono text-sm shadow-sm") do
                  "phlex-ruby/phlex-rails"
                end
                div(class: "rounded-md border px-4 py-2 font-mono text-sm shadow-sm") do
                  "ruby-ui/ruby_ui"
                end
              end
            end
          end

          div(class: "flex gap-2 items-center") do
            Remix::ListCheck3(class: "h-4 w-4")
            Text(size: "2", class: "text-md font-semibold") { "Lịch sử đóng tiền lãi" }
          end

          Table do
            TableCaption { "Danh sách các kỳ đóng lãi sẽ được hiển thị ở đây" } if contract.contract_interest_payments.blank?
            TableHeader do
              TableRow do
                TableHead { "STT" }
                TableHead { "Ngày" }
                TableHead { "Số ngày" }
                TableHead { "Tiền lãi" }
                TableHead { "Tiền khác" }
                TableHead { "Tổng lãi" }
                TableHead { "Tiền khách trả" }
                TableHead { "Hành động" }
              end
            end
            TableBody do
              contract.contract_interest_payments.each_with_index do |item, index|
                TableRow do
                  TableCell(class: "font-medium") { index + 1 }
                  TableCell { item.fm_dates }
                  TableCell { item.number_of_days }
                  TableCell { item.amount_formatted }
                  TableCell { item.other_amount_formatted }
                  TableCell { item.total_amount_formatted }
                  TableCell do
                    if item.paid?
                      span(class: "text-green-600 font-medium") { item.total_paid_formatted }
                    else
                      MaskedInput(
                        data: { maska_number_locale: "vi", maska_number_unsigned: true },
                        class: "w-24 border rounded px-2 py-1",
                        placeholder: item.total_amount_formatted,
                        value: item.total_amount.to_i * 1_000
                      )
                    end
                  end
                  TableCell do
                    div(class: "flex items-center space-x-3") do
                      Tooltip do
                        TooltipTrigger do
                          Checkbox(id: "paid_#{item.id}", class: "cursor-pointer", checked: item.paid?)
                        end
                        TooltipContent do
                          Text(size: :sm) { "Thanh toán" }
                        end
                      end

                      Tooltip do
                        TooltipTrigger do
                          Remix::StickyNoteLine(class: "h-5 w-5 cursor-pointer")
                        end
                        TooltipContent do
                          Text(size: :sm) { "Ghi chú" }
                        end
                      end
                    end
                  end
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
