class Views::Shared::Contracts::Tabs::ReducePrincipal < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    TabsContent(value: "reduce_principal") do
      div(class: "rounded-lg border p-6 space-y-4 bg-background text-foreground") do
        div(class: "space-y-0") do
          turbo_frame_tag "reduce_principal_form" do
            render Views::Shared::Contracts::Tabs::ReducePrincipal::Form.new(contract:)
          end

          div(class: "flex gap-2") do
            Remix::ListView(class: "w-6 h-6")
            h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Danh sách tiền gốc" }
          end
          Table do
            TableCaption { "Lịch sử rút gốc sẽ được hiển thị ở đây" } if contract.reduce_principals.blank?
            TableHeader do
              TableRow do
                TableHead { "STT" }
                TableHead(class: "text-center") { "Ngày" }
                TableHead { "Loại hình" }
                TableHead { "Ghi chú" }
                TableHead { "Số tiền" }
                TableHead { "" }
              end
            end
            TableBody do
              contract.reduce_principals.includes(:transaction_type).each_with_index do |item, index|
                TableRow do
                  TableCell(class: "font-medium") { index + 1 }
                  TableCell(class: "text-center") { item.fm_transaction_date }
                  TableCell() { item.transaction_type.name }
                  TableCell(class: "text-center") { item.description }
                  TableCell() { item.amount_formatted }
                  TableCell do
                    div(class: "flex items-center space-x-3") do
                      Tooltip do
                        TooltipTrigger do
                          AlertDialog do
                            AlertDialogTrigger do
                              Remix::CloseLine(class: "h-5 w-5 cursor-pointer text-red-500")
                            end
                            AlertDialogContent do
                              AlertDialogHeader do
                                AlertDialogTitle { "Bạn có chắc chắn hủy thanh toán tiền gốc này không?" }
                                AlertDialogDescription { "Bạn sẽ không thể khôi phục thanh toán này nữa!" }
                              end
                              AlertDialogFooter do
                                AlertDialogAction(
                                  data: {
                                    controller: "shared--reduce-principal",
                                    "shared--reduce-principal-cancel-url-value": contracts_reduce_principal_path(item),
                                    "shared--reduce-principal-contract-id-value": contract.id,
                                    action: "click->shared--reduce-principal#cancelReduction"
                                  }
                                ) { "Đồng ý huỷ" }
                                AlertDialogCancel(id: "btn-cancel-reduction") { "Nghĩ lại" }
                              end
                            end
                          end
                        end
                        TooltipContent do
                          Text(size: :sm) { "Huỷ" }
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
