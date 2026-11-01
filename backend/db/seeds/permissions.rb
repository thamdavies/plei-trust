# Static, version-controlled capability catalog mirrored from specs/002-project-init/permissions-catalog.md.
module PermissionSeeds
  GROUPS = [
    ["dashboard", "Dashboard", nil],
    ["reminders", "Reminders", nil],
    ["pawn", "Pawn contracts", nil],
    ["collateral_privacy", "Collateral privacy", "pawn"],
    ["unsecured_credit", "Unsecured credit", nil],
    ["installment", "Installments", nil],
    ["customers", "Customers", nil],
    ["customer_privacy", "Customer privacy", "customers"],
    ["collaborators", "Collaborators", nil],
    ["stores", "Stores and configuration", nil],
    ["cash", "Cash", nil],
    ["capital", "Capital", nil],
    ["staff", "Staff", nil],
    ["reports", "Reports", nil],
  ].freeze

  ACTIONS = [
    ["dashboard.owner.view", "Owner dashboard", "dashboard"],
    ["dashboard.staff.view", "Staff dashboard", "dashboard"],
    ["customers.phone.view", "View customer phone numbers", "customer_privacy"],
    ["customers.identity.view", "View customer identity numbers", "customer_privacy"],
    ["customers.documents.view", "View customer documents", "customer_privacy"],
    ["collateral.unlock_secret.view", "View collateral device access details", "collateral_privacy"],
    ["reminders.pawn.view", "Pawn reminders", "reminders"],
    ["reminders.unsecured_credit.view", "Unsecured-credit reminders", "reminders"],
    ["reminders.installment.view", "Installment reminders", "reminders"],
    ["reminders.capital.view", "Capital reminders", "reminders"],
    ["pawn.summary.view", "View cash, active lending, expected and collected interest", "pawn"],
    ["pawn.contracts.view", "View contract list", "pawn"],
    ["pawn.contracts.create", "Create contract", "pawn"],
    ["pawn.contracts.update", "Edit contract", "pawn"],
    ["pawn.contracts.delete", "Delete contract", "pawn"],
    ["pawn.contracts.origination_date.update", "Change loan date", "pawn"],
    ["pawn.interest.collect", "Collect interest", "pawn"],
    ["pawn.interest.collection.cancel", "Cancel interest collection", "pawn"],
    ["pawn.principal.increase", "Increase principal / lend more", "pawn"],
    ["pawn.principal.repay", "Repay part of principal", "pawn"],
    ["pawn.redemption.complete", "Redeem collateral / close loan", "pawn"],
    ["pawn.redemption.date.update", "Change redemption date", "pawn"],
    ["pawn.redemption.cancel", "Cancel redemption", "pawn"],
    ["pawn.interest_arrears.record", "Record unpaid interest", "pawn"],
    ["pawn.collateral.liquidate", "Liquidate collateral", "pawn"],
    ["unsecured_credit.summary.view", "View cash, active lending, expected and collected interest", "unsecured_credit"],
    ["unsecured_credit.contracts.view", "View contract list", "unsecured_credit"],
    ["unsecured_credit.contracts.create", "Create contract", "unsecured_credit"],
    ["unsecured_credit.contracts.update", "Edit contract", "unsecured_credit"],
    ["unsecured_credit.contracts.delete", "Delete contract", "unsecured_credit"],
    ["unsecured_credit.contracts.origination_date.update", "Change loan date", "unsecured_credit"],
    ["unsecured_credit.interest.collect", "Collect interest", "unsecured_credit"],
    ["unsecured_credit.interest.collection.cancel", "Cancel interest collection", "unsecured_credit"],
    ["unsecured_credit.principal.increase", "Increase principal / lend more", "unsecured_credit"],
    ["unsecured_credit.principal.repay", "Repay part of principal", "unsecured_credit"],
    ["unsecured_credit.contracts.extend", "Extend contract", "unsecured_credit"],
    ["unsecured_credit.contracts.close", "Close contract", "unsecured_credit"],
    ["unsecured_credit.contracts.closure_date.update", "Change closure date", "unsecured_credit"],
    ["unsecured_credit.contracts.closure.cancel", "Cancel closure", "unsecured_credit"],
    ["unsecured_credit.interest_arrears.record", "Record unpaid interest", "unsecured_credit"],
    ["installment.summary.view", "View installment summary", "installment"],
    ["installment.contracts.view", "View contract list", "installment"],
    ["installment.contracts.create", "Create installment contract", "installment"],
    ["installment.contracts.update", "Edit contract", "installment"],
    ["installment.contracts.delete", "Delete contract", "installment"],
    ["installment.payments.collect", "Record installment payment", "installment"],
    ["installment.payments.cancel", "Cancel installment payment", "installment"],
    ["installment.contracts.close", "Close contract", "installment"],
    ["installment.contracts.closure.cancel", "Cancel contract closure", "installment"],
    ["installment.debt.record", "Record arrears/debt", "installment"],
    ["installment.contracts.new_flow", "New installment-contract flow*", "installment"],
    ["customers.manage", "Manage customer records", "customers"],
    ["customers.documents.upload", "Upload customer documents", "customers"],
    ["collaborators.manage", "Manage collaborators", "collaborators"],
    ["stores.chain_summary.view", "View chain summary", "stores"],
    ["stores.details.view", "View store details", "stores"],
    ["stores.list.view", "View store list", "stores"],
    ["asset_categories.manage", "Manage asset categories", "stores"],
    ["cash.opening_balance.create", "Enter opening cash balance", "cash"],
    ["fee_rules.manage", "Manage fee configuration", "stores"],
    ["cash.expenses.create", "Create operating expense", "cash"],
    ["cash.income.create", "Create operating income", "cash"],
    ["cash.transactions.delete", "Delete income/expense voucher*", "cash"],
    ["capital.manage", "Manage capital agreements and payments", "capital"],
    ["staff.list.view", "View staff list", "staff"],
    ["staff.permissions.manage", "Manage staff/store role assignments", "staff"],
    ["reports.transaction_summary.view", "Transaction summary", "reports"],
    ["reports.profit_summary.view", "Profit summary", "reports"],
    ["reports.interest_detail.view", "Interest details", "reports"],
    ["reports.collection_stats.view", "Collection statistics", "reports"],
    ["reports.contracts.awaiting_liquidation.view", "Contracts awaiting liquidation", "reports"],
    ["reports.contracts.settled.view", "Settled contracts", "reports"],
    ["reports.contracts.active.view", "Active contracts", "reports"],
    ["reports.contracts.liquidated.view", "Liquidated contracts", "reports"],
    ["reports.contracts.deleted.view", "Deleted contracts", "reports"],
    ["reports.shift_handover.view", "Shift handover", "reports"],
    ["reports.daily_cash_flow.view", "Daily cash flow", "reports"],
    ["reports.collaborators.view", "Collaborator report", "reports"],
  ].freeze

  def self.call
    groups = {}
    GROUPS.each_with_index do |(key, label, parent_key), index|
      permission = Permission.find_or_initialize_by(key: key)
      permission.update!(parent: groups[parent_key], label: label, category: parent_key || key, assignable: false, sort_order: index)
      groups[key] = permission
    end

    ACTIONS.each_with_index do |(key, label, parent_key), index|
      parent = groups.fetch(parent_key)
      category = parent.parent&.key || parent.key
      Permission.find_or_initialize_by(key: key).update!(parent: parent, label: label, category: category, assignable: true, sort_order: index)
    end
  end
end
