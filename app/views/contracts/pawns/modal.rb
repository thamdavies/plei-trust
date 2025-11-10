class Views::Contracts::Pawns::Modal < Views::Base
  def initialize(form: ::Contract.new)
    @form = form
  end

  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "pawn-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :xl) do
        turbo_frame_tag "pawn_form" do
          render Views::Contracts::Pawns::Form.new(form:)
        end
      end
    end
  end

  attr_reader :form
end
