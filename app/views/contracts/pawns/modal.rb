class Views::Contracts::Pawns::Modal < Views::Base
  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "pawn-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :xl) do
        turbo_frame_tag "pawn_form" do; end
      end
    end
  end
end
