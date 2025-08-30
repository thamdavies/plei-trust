# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_30_152925) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "administrative_regions", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255, null: false
    t.string "code_name", limit: 255
    t.string "code_name_en", limit: 255
  end

  create_table "administrative_units", id: :integer, default: nil, force: :cascade do |t|
    t.string "full_name", limit: 255
    t.string "full_name_en", limit: 255
    t.string "short_name", limit: 255
    t.string "short_name_en", limit: 255
    t.string "code_name", limit: 255
    t.string "code_name_en", limit: 255
  end

  create_table "provinces", primary_key: "code", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255
    t.string "full_name", limit: 255, null: false
    t.string "full_name_en", limit: 255
    t.string "code_name", limit: 255
    t.integer "administrative_unit_id"
    t.index ["administrative_unit_id"], name: "idx_provinces_unit"
  end

  create_table "wards", primary_key: "code", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255
    t.string "full_name", limit: 255
    t.string "full_name_en", limit: 255
    t.string "code_name", limit: 255
    t.string "province_code", limit: 20
    t.integer "administrative_unit_id"
    t.index ["administrative_unit_id"], name: "idx_wards_unit"
    t.index ["province_code"], name: "idx_wards_province"
  end

  add_foreign_key "provinces", "administrative_units", name: "provinces_administrative_unit_id_fkey"
  add_foreign_key "wards", "administrative_units", name: "wards_administrative_unit_id_fkey"
  add_foreign_key "wards", "provinces", column: "province_code", primary_key: "code", name: "wards_province_code_fkey"
end
