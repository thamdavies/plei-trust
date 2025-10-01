class Views::Contracts::Capitals::Modal < Views::Base
  def initialize(form: ::Contract.new)
    @form = form
  end

  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "capital-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :xl) do
        turbo_frame_tag "capital_form" do
          render Views::Contracts::Capitals::Form.new(form:)
        end
      end
    end
  end

  attr_reader :form
end
