class Views::Shared::Contracts::ShowModal < Views::Base
  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "contract-modal-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :xl) do
        turbo_frame_tag "contract_show_modal" do; end
      end
    end
  end
end
