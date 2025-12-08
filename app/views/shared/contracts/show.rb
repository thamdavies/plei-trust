class Views::Shared::Contracts::Show < Views::Base
  def initialize(contract:, tab: "pay_interest")
    @contract = contract.presence || Contract.new.decorate
    @tab = tab
  end

  def view_template
    div(data: { controller: "shared--contract-detail" }) do
      Text(size: "5", weight: "bold") { "Chi tiết hợp đồng" }
      Separator(class: "my-4")
      render Views::Shared::Contracts::ContractInfo.new(contract:)

      Tabs(default: tab, class: "w-full") do
        TabsList do
          TabsTrigger(value: "pay_interest") { "Trả tiền lãi" }
          TabsTrigger(value: "reduce_principal") { "Rút bớt gốc" }
          TabsTrigger(value: "additional_loan") { "Vay thêm" }
          TabsTrigger(value: "extend_term") { "Gia hạn" }
          TabsTrigger(value: "withdraw_principal") { contract_labels("withdraw_principal") }
          TabsTrigger(value: "debt") { "Nợ" } if contract.has_debt_tab?
          TabsTrigger(value: "file") { "Chứng từ" } if contract.has_file_tab?
          TabsTrigger(value: "reminder") { "Hẹn giờ" } if contract.has_reminder_tab?
          TabsTrigger(value: "transaction_history") { "Lịch sử" }
        end

        render Views::Shared::Contracts::Tabs::PayInterest.new(contract:)
        render Views::Shared::Contracts::Tabs::ReducePrincipal.new(contract:)
        render Views::Shared::Contracts::Tabs::AdditionalLoan.new(contract:)
        render Views::Shared::Contracts::Tabs::ExtendTerm.new(contract:)
        render Views::Shared::Contracts::Tabs::WithdrawPrincipal.new(contract:)
        render Views::Shared::Contracts::Tabs::Debt.new(contract:) if contract.has_debt_tab?
        render Views::Shared::Contracts::Tabs::File.new(contract:) if contract.has_file_tab?
        render Views::Shared::Contracts::Tabs::Reminder.new(contract:) if contract.has_reminder_tab?
        render Views::Shared::Contracts::Tabs::TransactionHistory.new(contract:)
      end
    end
  end

  private

  attr_reader :contract, :tab
end
