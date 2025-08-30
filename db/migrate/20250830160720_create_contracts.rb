class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts, id: false do |t|
      t.ksuid :id, primary_key: true
      t.string :code
      t.references :customer, null: false, foreign_key: true, type: :string
      t.references :branch, null: false, foreign_key: true, type: :string
      t.references :cashier, null: false, foreign_key: { to_table: :users }, type: :string
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :string

      # Thông tin tài sản
      t.references :asset_setting, null: true, foreign_key: true, type: :string
      t.string :asset_name

      # Loại hợp đồng và số tiền
      t.references :service, null: false, foreign_key: true, type: :string
      t.string :service_type
      t.decimal :loan_amount, precision: 15, scale: 2

      # Cấu hình lãi suất
      t.string :interest_calculation_method
      t.decimal :interest_rate, precision: 8, scale: 5

      # Điều khoản thời hạn
      t.integer :contract_term_days
      t.integer :payment_frequency_days

      # Ngày quan trọng
      t.date :contract_date

      # Trạng thái và cài đặt
      t.string :status, default: 'pending'
      t.text :notes

      t.timestamps
    end
  end
end
