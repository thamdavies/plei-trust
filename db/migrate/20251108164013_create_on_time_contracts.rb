class CreateOnTimeContracts < ActiveRecord::Migration[8.1]
  def change
    create_view :on_time_contracts
  end
end
