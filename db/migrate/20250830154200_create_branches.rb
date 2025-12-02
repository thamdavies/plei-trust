class CreateBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :branches, id: :uuid, default: 'uuidv7()' do |t|
      t.string :name
      t.references :province, type: :string, foreign_key: { to_table: :provinces, primary_key: :code }, index: true
      t.references :ward, type: :string, foreign_key: { to_table: :wards, primary_key: :code }, index: true
      t.string :address
      t.string :phone
      t.string :representative
      t.decimal :invest_amount, precision: 12, scale: 4
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
