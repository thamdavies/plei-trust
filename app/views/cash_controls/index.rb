class Views::CashControls::Index < Views::Base
  def initialize(transactions: [])
    @transactions = transactions
  end

  def view_template
    div(class: "grid grid-cols-1 md:grid-cols-3 gap-4 m-4") do
      # Left Column: Forms (Takes up 1/3 of the space on medium screens and up)
      div(class: "md:col-span-1 space-y-4") do
        turbo_frame_tag "deposit_form" do
          render Views::CashControls::DepositForm.new
        end

        div(class: "h-1") # Spacer between forms

        turbo_frame_tag "opening_balance_form" do
          render Views::CashControls::OpeningBalanceForm.new
        end
      end

      # Right Column: Transaction Table (Takes up 2/3 of the space)
      div(class: "md:col-span-2") do
        render Views::CashControls::TransactionTable.new(transactions: @transactions)
      end
    end
  end
end
