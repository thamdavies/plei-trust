class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services, id: false do |t|
      t.ksuid :id, primary_key: true
      t.string :code
      t.string :name
      t.references :branch, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
