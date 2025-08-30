# Table branches {
#   id varchar [pk, note: 'KSUID - Mã định danh duy nhất của chi nhánh']
#   name varchar [note: 'Tên chi nhánh']
#   province_id integer [note: 'Mã tỉnh/thành phố']
#   ward_id integer [note: 'Mã phường/xã']
#   address varchar [note: 'Địa chỉ chi tiết của chi nhánh']
#   phone varchar [note: 'Số điện thoại liên hệ']
#   representative varchar [note: 'Người đại diện chi nhánh']
#   invest_amount decimal [note: 'Số tiền đầu tư ban đầu']
#   status varchar [note: 'Trạng thái hoạt động (active/inactive)']
# }

class CreateBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :branches, id: false do |t|
      t.ksuid :id, primary_key: true
      t.string :name
      t.integer :province_id
      t.integer :ward_id
      t.string :address
      t.string :phone
      t.string :representative
      t.decimal :invest_amount, precision: 12, scale: 2
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
