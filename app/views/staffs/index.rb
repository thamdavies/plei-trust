class Views::Staffs::Index < Views::Base
  def initialize(staffs:, form:, pagy: nil)
    @staffs = staffs
    @form = form
    @pagy = pagy
  end

  def view_template
    render Views::Staffs::Modal.new(form: @form)

    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách nhân viên sẽ được hiển thị ở đây" } if @staffs.empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Tài khoản" }
            TableHead { "Họ tên" }
            TableHead { "Điện thoại" }
            TableHead { "Ngày tạo" }
            TableHead { "Tình trạng" }
            TableHead { "Chức năng" }
          end
        end
        TableBody do
          @staffs.each_with_index do |staff, index|
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium") { staff.email }
              TableCell(class: "font-medium") { staff.full_name }
              TableCell(class: "font-medium") { staff.phone }
              TableCell(class: "font-medium") { staff.fm_created_date }
              TableCell(class: "font-medium") { staff.status_badge }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  Remix::EditBoxLine(
                    class: "w-5 h-5 cursor-pointer",
                    data: {
                      action: "click->resource#triggerDialog",
                      controller: "resource",
                      resource_path_value: edit_staff_path(staff.id),
                      resource_dialogbutton_value: "staff-dialog-trigger"
                    },
                  )
                  Link(href: staff_path(staff.id), class: "w-5 h-5 cursor-pointer p-0", data: { turbo_method: :delete, turbo_confirm: "Bạn có chắc chắn xoá nhân viên này?" }) do
                    Remix::DeleteBinLine(class: "w-5 h-5 cursor-pointer")
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
