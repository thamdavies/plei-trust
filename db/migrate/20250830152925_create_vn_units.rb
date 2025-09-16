class CreateVnUnits < ActiveRecord::Migration[8.0]
  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    ActiveRecord::Base.connection.execute(File.read(Rails.root.join("db", "fixtures", "CreateTables_vn_units.sql")))
  end

  def down
    ActiveRecord::Base.connection.execute(File.read(Rails.root.join("db", "fixtures", "DropTables_vn_units.sql")))
  end
end
