# Table contract_extensions {
#   id varchar [pk, note: 'KSUID - Mã định danh duy nhất của gia hạn']
#   contract_id varchar [note: 'Hợp đồng được gia hạn']
#   from date [note: 'Ngày bắt đầu gia hạn']
#   to date [note: 'Ngày kết thúc gia hạn']
#   number_of_days integer [note: 'Số ngày gia hạn']
#   content string [note: 'Nội dung gia hạn']
#   notes string [note: 'Ghi chú thêm về gia hạn']
# }
class CreateContractExtensions < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_extensions, id: false do |t|
      t.ksuid :id, primary_key: true
      t.references :contract, null: false, foreign_key: true, type: :string
      t.date :from
      t.date :to
      t.integer :number_of_days
      t.text :content
      t.text :notes

      t.timestamps
    end
  end
end
