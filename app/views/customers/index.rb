class Views::Customers::Index < Views::Base
  def initialize(customers:, form: Customer.new, pagy: nil)
    @customers = customers
    @form = form
    @pagy = pagy
  end

  def view_template
    render Views::Customers::Modal.new(form: @form)

    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách khách hàng sẽ được hiển thị ở đây" } if @customers.empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Khách hàng" }
            TableHead { "Địa chỉ" }
            TableHead { "Điện thoại" }
            TableHead { "CCCD" }
            TableHead { "Ngày tạo" }
            TableHead { "Tình trạng" }
            TableHead { "Chức năng" }
          end
        end
        TableBody do
          @customers.each_with_index do |customer, index|
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium") { customer.full_name }
              TableCell(class: "font-medium") { customer.address }
              TableCell(class: "font-medium") { customer.phone }
              TableCell(class: "font-medium") { customer.national_id }
              TableCell(class: "font-medium") { customer.fm_created_date }
              TableCell(class: "font-medium") { customer.status_badge }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  Remix::EditBoxLine(
                    class: "w-5 h-5 cursor-pointer",
                    data: {
                      action: "click->resource#triggerDialog",
                      controller: "resource",
                      resource_path_value: edit_customer_path(customer.id),
                      resource_dialogbutton_value: "customer-dialog-trigger"
                    },
                  )
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
  end
end
