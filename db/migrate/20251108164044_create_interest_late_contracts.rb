class CreateInterestLateContracts < ActiveRecord::Migration[8.1]
  def change
    create_view :interest_late_contracts
  end
end
