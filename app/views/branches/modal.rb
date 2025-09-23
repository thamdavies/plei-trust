class Views::Branches::Modal < Views::Base
  def initialize(form: Branch.new)
    @form = form
  end

  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "branch-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :sm) do
        turbo_frame_tag "branch_form" do
          render Views::Branches::Form.new(form:)
        end
      end
    end
  end

  attr_reader :form
end
