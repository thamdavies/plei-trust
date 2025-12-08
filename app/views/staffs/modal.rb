class Views::Staffs::Modal < Views::Base
  def initialize(form: User.new)
    @form = form
  end

  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "staff-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :sm) do
        turbo_frame_tag "staff_form" do
          render Views::Staffs::Form.new(form:)
        end
      end
    end
  end

  attr_reader :form
end
