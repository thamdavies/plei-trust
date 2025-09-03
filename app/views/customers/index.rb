class Views::Customers::Index < Views::Base
  def page_title = I18n.t("sidebar.customer")

  def view_template
  end

  def breadcrumbs
    [
      { title: I18n.t("sidebar.dashboard"), path: root_path },
      { title: I18n.t("sidebar.customer"), path: customers_path }
    ]
  end

  def subtitle = "Danh sách Khách hàng"

  def header
    div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
      Form(action: "#", method: "GET", class: "sm:pr-3 space-y-6") do |f|
        FormField(class: "relative w-48 mt-1 sm:w-64 xl:w-96") do
          SearchInput(placeholder: I18n.t("placeholders.search_customers"), required: true, minlength: "3") { "Joel Drapper" }
        end
      end
    end
  end
end
