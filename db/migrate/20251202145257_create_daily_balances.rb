class CreateDailyBalances < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_balances, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.date :date, null: false             # Ngày ghi nhận
      t.decimal :opening_balance, precision: 15, scale: 4, default: 0 # Tiền đầu ngày
      t.decimal :closing_balance, precision: 15, scale: 4 # Tiền chốt cuối ngày (để đối soát)
      t.uuid :created_by_id                 # Người chốt sổ/tạo
      t.timestamps
    end

    # Đảm bảo mỗi chi nhánh chỉ có 1 bản ghi chốt số cho 1 ngày
    add_index :daily_balances, [ :branch_id, :date ], unique: true
  end
end
