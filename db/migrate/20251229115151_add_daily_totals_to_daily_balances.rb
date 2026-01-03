class AddDailyTotalsToDailyBalances < ActiveRecord::Migration[8.1]
  def change
    add_column :daily_balances, :pawn_total, :decimal, precision: 15, scale: 2
    add_column :daily_balances, :credit_total, :decimal, precision: 15, scale: 2
    add_column :daily_balances, :installment_total, :decimal, precision: 15, scale: 2
    add_column :daily_balances, :income_expense_total, :decimal, precision: 15, scale: 2
    add_column :daily_balances, :capital_total, :decimal, precision: 15, scale: 2
  end
end
