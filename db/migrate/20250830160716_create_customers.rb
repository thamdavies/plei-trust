class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers, id: false do |t|
      t.ksuid :id, primary_key: true
      t.string :customer_code
      t.string :full_name
      t.string :phone
      t.string :national_id
      t.date :national_id_issued_at
      t.string :national_id_issued_place
      t.string :address
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :string
      t.string :branch_id
      t.string :status

      t.timestamps
    end
  end
end
