class Views::Customers::Index < Views::Base
  def initialize(customers:)
    @customers = customers
  end

  def page_title = I18n.t("sidebar.customer")

  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "customer-dialog-trigger") do
        Button { "Open Dialog" }
      end
      DialogContent(size: :sm) do
        Form do
          DialogHeader do
            DialogTitle { I18n.t("page.customer_management.new") }
          end
          DialogMiddle do
            FormField do
              FormFieldLabel { "Tên khách hàng" }
              Input(placeholder: "Nhập tên khách hàng", required: true)
              FormFieldError()
            end

            FormField do
              FormFieldLabel { "Số điện thoại" }
              Input(placeholder: "Nhập số điện thoại", required: true)
              FormFieldError()
            end

            FormField do
              FormFieldLabel { "Số CMND" }
              Input(placeholder: "Nhập số CMND", required: true)
              FormFieldError()
            end

            FormField do
              FormFieldLabel { "Ngày cấp" }
              Input(placeholder: "Nhập ngày cấp", required: true)
              FormFieldError()
            end

            FormField do
              FormFieldLabel { "Nơi cấp" }
              Input(placeholder: "Nhập nơi cấp", required: true)
              FormFieldError()
            end

            FormField do
              FormFieldLabel { "Địa chỉ" }
              Input(placeholder: "Nhập địa chỉ", required: true)
              FormFieldError()
            end

            FormField do
              FormFieldLabel(for: "active") { "Trạng thái" }
              div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
                div(class: "flex items-center space-x-2") do
                  RadioButton(id: "form-active", name: :status, checked: false)
                  FormFieldLabel(for: "form-active", class: "cursor-pointer") { "Hoạt động" }
                end

                div(class: "flex items-center space-x-2 ml-3") do
                  RadioButton(id: "form-inactive", name: :status, checked: false)
                  FormFieldLabel(for: "form-inactive", class: "cursor-pointer") { "Đã khoá" }
                end
              end
              FormFieldError()
            end
          end
          DialogFooter do
            Button(variant: :outline, data: { action: "click->ruby-ui--dialog#dismiss" }) { I18n.t("button.close") }
            Button(type: "submit") { I18n.t("button.save") }
          end
        end
      end
    end

    div(class: "p-2 bg-white") do
      Table do
        TableHeader do
          TableRow do
            TableHead { "Khách hàng" }
            TableHead { "Địa chỉ" }
            TableHead { "Điện thoại" }
            TableHead { "CMND" }
            TableHead { "Ngày tạo" }
            TableHead { "Tình trạng" }
            TableHead { "Chức năng" }
          end
        end
        TableBody do
          TableRow do
            TableCell(class: "font-medium") { "Tham" }
            TableCell(class: "font-medium") { "Làng Toak, Kon Chiêng, Mang Yang, Gia Lai" }
            TableCell(class: "font-medium") { "0355627748" }
            TableCell(class: "font-medium") { "231101119" }
            TableCell(class: "font-medium") { "26/06/2023" }
            TableCell(class: "font-medium") { Badge(variant: :success) { "Hoạt động" } }
            TableCell(class: "font-medium") do
              div(class: "flex space-x-2") do
                a(href: "#", class: "") do
                  Remix::EditBoxLine(class: "w-5 h-5")
                end
                a(href: "#", class: "") do
                  Remix::FileTextLine(class: "w-5 h-5")
                end
              end
            end
          end
        end
      end
    end
  end

  def breadcrumbs
    [
      { title: I18n.t("sidebar.dashboard"), path: root_path },
      { title: I18n.t("sidebar.customer"), path: customers_path }
    ]
  end

  def subtitle = "Danh sách Khách hàng"

  def filter_form = :customer
end
