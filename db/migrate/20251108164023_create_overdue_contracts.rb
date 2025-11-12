class CreateOverdueContracts < ActiveRecord::Migration[8.1]
  def change
    create_view :overdue_contracts
  end
end
