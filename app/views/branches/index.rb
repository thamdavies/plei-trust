class Views::Branches::Index < Views::Base
  def initialize(branches:, form: Branch.new, pagy: nil)
    @branches = branches
    @form = form
    @pagy = pagy
  end

  def view_template
    render Views::Branches::Modal.new(form: @form)

    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách chi nhánh sẽ được hiển thị ở đây" } if @branches .empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Chi nhánh" }
            TableHead { "Địa chỉ" }
            TableHead { "Điện thoại" }
            TableHead { "Vốn đầu tư" }
            TableHead { "Ngày tạo" }
            TableHead { "Tình trạng" }
            TableHead { "Chức năng" }
          end
        end
        TableBody do
          @branches.each_with_index do |branch, index|
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium") { branch.name }
              TableCell(class: "font-medium") { branch.full_address }
              TableCell(class: "font-medium") { branch.phone }
              TableCell(class: "font-medium") { branch.invest_amount_formatted }
              TableCell(class: "font-medium") { branch.fm_created_date }
              TableCell(class: "font-medium") { branch.status_badge }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  Remix::EditBoxLine(
                    class: "w-5 h-5 cursor-pointer",
                    data: {
                      action: "click->resource#triggerDialog",
                      controller: "resource",
                      resource_path_value: edit_branch_path(branch.id),
                      resource_dialogbutton_value: "branch-dialog-trigger"
                    },
                  )
                  a(href: "#", class: "") do
                    Tooltip do
                      TooltipTrigger do
                        Remix::SwitchLine(class: "w-5 h-5")
                      end
                      TooltipContent do
                        Text(size: :small) { "Chuyển chi nhánh" }
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
