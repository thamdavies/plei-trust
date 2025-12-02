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
                  Text(size: "3", class: "font-semibold") { "Chức năng đóng lãi tùy biến theo ngày" }
                end
                span(class: "sr-only") { "Toggle" }
              end
            end

            CollapsibleContent do
              div(class: "space-y-2 my-2") do
                turbo_frame_tag "pay_by_day_form" do
                  render Views::Shared::Contracts::Tabs::PayInterest::PayByDayForm.new(contract:)
                end
              end unless contract.no_interest?
              div(class: "text-sm text-muted-foreground") { "Hợp đồng không có lãi suất không hỗ trợ chức năng này" } if contract.no_interest?
              Separator(class: "my-4")
            end
          end

          div(class: "flex gap-2 items-center") do
            Remix::ListCheck3(class: "h-4 w-4")
            Text(size: "3", class: "font-semibold") { "Lịch sử đóng tiền lãi" }
          end

          if contract.contract_type_code == ContractType.codes[:installment]
            render Views::Shared::Contracts::Tabs::PayInterest::InstallmentTable.new(contract:)
          else
            render Views::Shared::Contracts::Tabs::PayInterest::StandardTable.new(contract:)
          end
        end
      end
    end
  end

  private

  attr_reader :contract
end
