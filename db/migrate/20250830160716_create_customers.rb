class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers, id: :uuid, default: 'uuidv7()' do |t|
      t.string :customer_code
      t.string :full_name
      t.string :phone
      t.string :national_id
      t.date :national_id_issued_date
      t.string :national_id_issued_place
      t.string :address
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :branch, null: false, foreign_key: true, type: :uuid
      t.string :status

      t.timestamps
    end
  end
end
