class Views::Shared::Contracts::ShowModal < Views::Base
  def initialize(contract:)
    @contract = contract
  end

  def view_template
    Dialog do
      DialogTrigger(class: "hidden", id: "contract-modal-dialog-trigger") do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :xl) do
        turbo_frame_tag "contract_show_modal" do
          render Views::Shared::Contracts::Show.new(contract: @contract)
        end
      end
    end
  end
end
