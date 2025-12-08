class Views::Contracts::Installments::Modal < Views::Base
  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "installment-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :xl) do
        turbo_frame_tag "installment_form" do; end
      end
    end
  end
end
