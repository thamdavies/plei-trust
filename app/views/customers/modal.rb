class Views::Customers::Modal < Views::Base
  def initialize(form: Customer.new)
    @form = form
  end

  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "customer-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :sm) do
        turbo_frame_tag "customer_form" do
          render Views::Customers::Form.new(form:, url: customers_path, method: :post)
        end
      end
    end
  end

  attr_reader :form
end
