module Branch::Writer
  extend ActiveSupport::Concern

  def update_opening_balance_for_date(date: Date.current)
    ActiveRecord::Base.transaction do
      previous_date = date - 1.day
      previous_daily_balance = daily_balances.find_by(date: previous_date)

      if previous_daily_balance.blank?
        message = "Previous daily balance for branch #{id} on #{previous_date} not found."
        Rails.logger.error(message)
        return
      end

      previous_cash_balance = current_cash_balance(previous_date)

      pawn_total = branch.pawn_total(previous_date)
      installment_total = branch.installment_total(previous_date)
      credit_total = branch.credit_total(previous_date)
      income_expense_total = branch.income_expense_total(previous_date)
      capital_total = branch.capital_total(previous_date)

      active_pawn_total = previous_daily_balance.active_pawn_total_amount
      active_credit_total = previous_daily_balance.active_credit_total_amount
      active_installment_total = previous_daily_balance.active_installment_total_amount
      capital_payable_total = previous_daily_balance.capital_payable_total_amount
      asset_total = previous_cash_balance.asset_total_amount

      previous_daily_balance.update!(
        closing_balance: previous_cash_balance,
        pawn_total:,
        installment_total:,
        credit_total:,
        income_expense_total:,
        capital_total:,
        active_pawn_total:,
        active_credit_total:,
        active_installment_total:,
        capital_payable_total:,
        asset_total:
      )

      daily_balance_record = daily_balances.find_or_initialize_by(date: date)
      if daily_balance_record.new_record?
        daily_balance_record.opening_balance = previous_cash_balance
        daily_balance_record.save!
      end

      branch = previous_daily_balance.branch
      msg = ">>>> Cập nhập tiền đầu ngày ngày #{date} cho chi nhánh #{branch.name}"
      Rails.logger.info(msg)
    rescue => e
      Rails.logger.error("Error updating opening balance for branch #{id} on #{date}: #{e.message}")
      raise ActiveRecord::Rollback
    end
  end

  def cancel_transaction(financial_transaction)
    financial_transactions.create!(
      transaction_date: Date.current,
      transaction_type_code: financial_transaction.transaction_type_code,
      amount: financial_transaction.amount_display * -1,
      created_by: financial_transaction.created_by,
      owner: financial_transaction.owner,
      recordable_type_code: financial_transaction.recordable_type_code,
      canceled_at: Time.current,
      description: "Hủy giao dịch ID #{financial_transaction.id}"
    )
    financial_transaction.update!(canceled_at: Time.current)
  end

  class_methods do
    def update_opening_balance_for_all_branches(date: Date.current)
      Branch.find_each do |branch|
        branch.update_opening_balance_for_date(date: date)
      end
    end

    def seed_daily_balances_for_all_branches(end_date: Date.current)
      Branch.find_each do |branch|
        start_date = branch.daily_balances.minimum(:date) || branch.created_at.to_date
        (start_date..end_date).each do |date|
          branch.update_opening_balance_for_date(date: date)
        end
      end
    end
  end
end
