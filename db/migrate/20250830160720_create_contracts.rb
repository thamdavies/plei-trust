class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts, id: :uuid, default: 'uuidv7()' do |t|
      t.string :code
      t.references :customer, null: false, foreign_key: true, type: :uuid
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.references :cashier, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :uuid

      # Thông tin tài sản
      t.references :asset_setting, null: true, foreign_key: true, type: :uuid
      t.string :asset_name

      # Loại hợp đồng và số tiền
      t.string :contract_type_code, null: false
      t.decimal :loan_amount, precision: 15, scale: 4

      # Cấu hình lãi suất
      t.string :interest_calculation_method
      t.decimal :interest_rate, precision: 8, scale: 5
      t.boolean :collect_interest_in_advance, default: false

      # Điều khoản thời hạn
      t.integer :contract_term
      t.integer :interest_period

      t.date :contract_date
      t.datetime :contract_ended_at

      # Trạng thái và cài đặt
      t.string :status, default: 'active'
      t.text :note

      t.boolean :is_default_capital, default: false, null: false

      t.timestamps
    end

    add_foreign_key :contracts, :contract_types, column: :contract_type_code, primary_key: :code
  end
end
