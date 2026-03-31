class CreateTransactionSummaries < ActiveRecord::Migration[8.1]
  def change
    create_view :transaction_summaries
  end
end
