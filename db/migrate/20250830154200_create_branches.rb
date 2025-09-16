class CreateBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :branches, id: :uuid, default: 'uuidv7()' do |t|
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
