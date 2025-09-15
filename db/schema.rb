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

ActiveRecord::Schema[8.0].define(version: 2025_09_15_091844) do
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

  create_table "asset_setting_attributes", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "asset_setting_id", null: false
    t.string "attribute_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_setting_id"], name: "index_asset_setting_attributes_on_asset_setting_id"
  end

  create_table "asset_setting_categories", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "asset_setting_id", null: false
    t.string "contract_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_setting_id"], name: "index_asset_setting_categories_on_asset_setting_id"
    t.index ["contract_type_id"], name: "index_asset_setting_categories_on_contract_type_id"
  end

  create_table "asset_setting_values", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "asset_setting_attribute_id", null: false
    t.string "contract_id", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_setting_attribute_id"], name: "index_asset_setting_values_on_asset_setting_attribute_id"
    t.index ["contract_id"], name: "index_asset_setting_values_on_contract_id"
  end

  create_table "asset_settings", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "asset_code"
    t.string "asset_name"
    t.string "status", default: "active"
    t.string "interest_calculation_method", default: "monthly"
    t.decimal "default_loan_amount", precision: 12, scale: 2
    t.float "default_interest_rate"
    t.integer "interest_period"
    t.integer "default_loan_duration_days"
    t.integer "liquidation_after_days"
    t.boolean "collect_interest_in_advance", default: false
    t.decimal "contract_initiation_fee", precision: 12, scale: 2
    t.float "asset_appraisal_fee"
    t.float "management_fee"
    t.float "asset_rental_fee"
    t.float "early_termination_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "branch_contract_types", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "branch_id", null: false
    t.string "contract_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_branch_contract_types_on_branch_id"
    t.index ["contract_type_id"], name: "index_branch_contract_types_on_contract_type_id"
  end

  create_table "branches", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "name"
    t.integer "province_id"
    t.integer "ward_id"
    t.string "address"
    t.string "phone"
    t.string "representative"
    t.decimal "invest_amount", precision: 12, scale: 2
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contract_amount_changes", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "contract_id", null: false
    t.date "action_date"
    t.string "type"
    t.decimal "amount", precision: 15, scale: 2
    t.text "notes"
    t.string "processed_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_amount_changes_on_contract_id"
    t.index ["processed_by_id"], name: "index_contract_amount_changes_on_processed_by_id"
  end

  create_table "contract_extensions", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "contract_id", null: false
    t.date "from"
    t.date "to"
    t.integer "number_of_days"
    t.text "content"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_extensions_on_contract_id"
  end

  create_table "contract_interest_payments", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "contract_id", null: false
    t.date "from"
    t.date "to"
    t.integer "number_of_days"
    t.decimal "amount", precision: 15, scale: 2
    t.decimal "other_amount", precision: 15, scale: 2
    t.decimal "total_amount", precision: 15, scale: 2
    t.decimal "total_paid", precision: 15, scale: 2
    t.string "payment_status", default: "unpaid"
    t.text "notes"
    t.string "processed_by_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_interest_payments_on_contract_id"
    t.index ["processed_by_id"], name: "index_contract_interest_payments_on_processed_by_id"
  end

  create_table "contract_terminations", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "contract_id", null: false
    t.date "termination_date"
    t.decimal "amount", precision: 15, scale: 2
    t.decimal "old_debt", precision: 15, scale: 2
    t.decimal "interest_amount", precision: 15, scale: 2
    t.decimal "other_amount", precision: 15, scale: 2
    t.decimal "total_amount", precision: 15, scale: 2
    t.string "processed_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_terminations_on_contract_id"
    t.index ["processed_by_id"], name: "index_contract_terminations_on_processed_by_id"
  end

  create_table "contract_types", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contracts", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "code"
    t.string "customer_id", null: false
    t.string "branch_id", null: false
    t.string "cashier_id", null: false
    t.string "created_by_id", null: false
    t.string "asset_setting_id"
    t.string "asset_name"
    t.string "contract_type_id", null: false
    t.decimal "loan_amount", precision: 15, scale: 2
    t.string "interest_calculation_method"
    t.decimal "interest_rate", precision: 8, scale: 5
    t.integer "contract_term_days"
    t.integer "payment_frequency_days"
    t.date "contract_date"
    t.string "status", default: "pending"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_setting_id"], name: "index_contracts_on_asset_setting_id"
    t.index ["branch_id"], name: "index_contracts_on_branch_id"
    t.index ["cashier_id"], name: "index_contracts_on_cashier_id"
    t.index ["contract_type_id"], name: "index_contracts_on_contract_type_id"
    t.index ["created_by_id"], name: "index_contracts_on_created_by_id"
    t.index ["customer_id"], name: "index_contracts_on_customer_id"
  end

  create_table "customers", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "customer_code"
    t.string "full_name"
    t.string "phone"
    t.string "national_id"
    t.date "national_id_issued_date"
    t.string "national_id_issued_place"
    t.string "address"
    t.string "created_by_id", null: false
    t.string "branch_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_customers_on_created_by_id"
  end

  create_table "financial_transactions", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "transaction_number", null: false
    t.date "transaction_date", null: false
    t.string "transaction_type_id", null: false
    t.string "contract_id", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "description"
    t.string "reference_number"
    t.string "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_financial_transactions_on_contract_id"
    t.index ["created_by_id"], name: "index_financial_transactions_on_created_by_id"
    t.index ["transaction_type_id"], name: "index_financial_transactions_on_transaction_type_id"
  end

  create_table "interest_rate_histories", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.date "effective_date", null: false
    t.float "interest_rate", null: false
    t.text "description"
    t.string "processed_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["processed_by_id"], name: "index_interest_rate_histories_on_processed_by_id"
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

  create_table "transaction_types", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.boolean "is_income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: { type: :string, limit: 27 }, force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name", null: false
    t.string "branch_id", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "phone"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
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

  add_foreign_key "asset_setting_attributes", "asset_settings"
  add_foreign_key "asset_setting_categories", "asset_settings"
  add_foreign_key "asset_setting_categories", "contract_types"
  add_foreign_key "asset_setting_values", "asset_setting_attributes"
  add_foreign_key "asset_setting_values", "contracts"
  add_foreign_key "branch_contract_types", "branches"
  add_foreign_key "branch_contract_types", "contract_types"
  add_foreign_key "contract_amount_changes", "contracts"
  add_foreign_key "contract_amount_changes", "users", column: "processed_by_id"
  add_foreign_key "contract_extensions", "contracts"
  add_foreign_key "contract_interest_payments", "contracts"
  add_foreign_key "contract_interest_payments", "users", column: "processed_by_id"
  add_foreign_key "contract_terminations", "contracts"
  add_foreign_key "contract_terminations", "users", column: "processed_by_id"
  add_foreign_key "contracts", "asset_settings"
  add_foreign_key "contracts", "branches"
  add_foreign_key "contracts", "contract_types"
  add_foreign_key "contracts", "customers"
  add_foreign_key "contracts", "users", column: "cashier_id"
  add_foreign_key "contracts", "users", column: "created_by_id"
  add_foreign_key "customers", "users", column: "created_by_id"
  add_foreign_key "financial_transactions", "contracts"
  add_foreign_key "financial_transactions", "transaction_types"
  add_foreign_key "financial_transactions", "users", column: "created_by_id"
  add_foreign_key "interest_rate_histories", "users", column: "processed_by_id"
  add_foreign_key "provinces", "administrative_units", name: "provinces_administrative_unit_id_fkey"
  add_foreign_key "users", "branches"
  add_foreign_key "wards", "administrative_units", name: "wards_administrative_unit_id_fkey"
  add_foreign_key "wards", "provinces", column: "province_code", primary_key: "code", name: "wards_province_code_fkey"
end
