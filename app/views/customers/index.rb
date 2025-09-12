class Views::Customers::Index < Views::Base
  def initialize(customers:, form: Customer.new)
    @customers = customers
    @form = form
  end

  def view_template
    render Views::Customers::Modal.new(form: @form)

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
          @customers.each do |customer|
            TableRow do
              TableCell(class: "font-medium") { customer.full_name }
              TableCell(class: "font-medium") { customer.address }
              TableCell(class: "font-medium") { customer.phone }
              TableCell(class: "font-medium") { customer.national_id }
              TableCell(class: "font-medium") { customer.created_at.to_date.to_fs(:date_vn) }
              TableCell(class: "font-medium") do
                if customer.status == "active"
                  Badge(variant: :success) { "Hoạt động" }
                else
                  Badge(variant: :destructive) { "Đã khoá" }
                end
              end
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
  end
end
