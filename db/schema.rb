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

ActiveRecord::Schema[8.1].define(version: 2025_11_08_164044) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "activities", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.uuid "owner_id"
    t.string "owner_type"
    t.text "parameters"
    t.uuid "recipient_id"
    t.string "recipient_type"
    t.uuid "trackable_id"
    t.string "trackable_type"
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable"
  end

  create_table "administrative_regions", id: :integer, default: nil, force: :cascade do |t|
    t.string "code_name", limit: 255
    t.string "code_name_en", limit: 255
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255, null: false
  end

  create_table "administrative_units", id: :integer, default: nil, force: :cascade do |t|
    t.string "code_name", limit: 255
    t.string "code_name_en", limit: 255
    t.string "full_name", limit: 255
    t.string "full_name_en", limit: 255
    t.string "short_name", limit: 255
    t.string "short_name_en", limit: 255
  end

  create_table "asset_setting_attributes", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "asset_setting_id", null: false
    t.string "attribute_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_setting_id"], name: "index_asset_setting_attributes_on_asset_setting_id"
  end

  create_table "asset_setting_categories", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "asset_setting_id", null: false
    t.string "contract_type_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_setting_id"], name: "index_asset_setting_categories_on_asset_setting_id"
  end

  create_table "asset_setting_values", primary_key: ["contract_id", "asset_setting_attribute_id"], force: :cascade do |t|
    t.uuid "asset_setting_attribute_id", null: false
    t.uuid "contract_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["contract_id", "asset_setting_attribute_id"], name: "idx_on_contract_id_asset_setting_attribute_id_b35d1be676", unique: true
  end

  create_table "asset_settings", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.float "asset_appraisal_fee"
    t.string "asset_code"
    t.string "asset_name"
    t.float "asset_rental_fee"
    t.uuid "branch_id", null: false
    t.boolean "collect_interest_in_advance", default: false
    t.decimal "contract_initiation_fee", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.integer "default_contract_term"
    t.float "default_interest_rate"
    t.decimal "default_loan_amount", precision: 12, scale: 2
    t.float "early_termination_fee"
    t.string "interest_calculation_method", default: "monthly"
    t.integer "interest_period"
    t.integer "liquidation_after_days"
    t.float "management_fee"
    t.string "status", default: "active"
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_asset_settings_on_branch_id"
  end

  create_table "branch_contract_types", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "branch_id", null: false
    t.string "contract_type_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_branch_contract_types_on_branch_id"
  end

  create_table "branches", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.decimal "invest_amount", precision: 12, scale: 2
    t.string "name"
    t.string "phone"
    t.string "province_id"
    t.string "representative"
    t.string "status", default: "active"
    t.datetime "updated_at", null: false
    t.string "ward_id"
    t.index ["province_id"], name: "index_branches_on_province_id"
    t.index ["ward_id"], name: "index_branches_on_ward_id"
  end

  create_table "contract_amount_changes", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.date "action_date"
    t.decimal "amount", precision: 15, scale: 2
    t.uuid "contract_id", null: false
    t.datetime "created_at", null: false
    t.text "note"
    t.uuid "processed_by_id", null: false
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_amount_changes_on_contract_id"
    t.index ["processed_by_id"], name: "index_contract_amount_changes_on_processed_by_id"
  end

  create_table "contract_extensions", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.text "content"
    t.uuid "contract_id", null: false
    t.datetime "created_at", null: false
    t.date "from"
    t.text "note"
    t.integer "number_of_days"
    t.date "to"
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_extensions_on_contract_id"
  end

  create_table "contract_interest_payments", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, default: "0.0"
    t.uuid "contract_id", null: false
    t.datetime "created_at", null: false
    t.boolean "custom_payment", default: false
    t.date "from"
    t.text "note"
    t.integer "number_of_days"
    t.decimal "other_amount", precision: 15, scale: 2, default: "0.0"
    t.string "payment_status", default: "unpaid"
    t.date "to"
    t.decimal "total_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_paid", precision: 15, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_interest_payments_on_contract_id"
  end

  create_table "contract_terminations", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2
    t.uuid "contract_id", null: false
    t.datetime "created_at", null: false
    t.decimal "interest_amount", precision: 15, scale: 2
    t.decimal "old_debt", precision: 15, scale: 2
    t.decimal "other_amount", precision: 15, scale: 2
    t.uuid "processed_by_id", null: false
    t.date "termination_date"
    t.decimal "total_amount", precision: 15, scale: 2
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_terminations_on_contract_id"
    t.index ["processed_by_id"], name: "index_contract_terminations_on_processed_by_id"
  end

  create_table "contract_types", primary_key: "code", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "contracts", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.string "asset_name"
    t.uuid "asset_setting_id"
    t.uuid "branch_id", null: false
    t.uuid "cashier_id", null: false
    t.string "code"
    t.boolean "collect_interest_in_advance", default: false
    t.date "contract_date"
    t.integer "contract_term"
    t.string "contract_type_code", null: false
    t.datetime "created_at", null: false
    t.uuid "created_by_id", null: false
    t.uuid "customer_id", null: false
    t.string "interest_calculation_method"
    t.integer "interest_period"
    t.decimal "interest_rate", precision: 8, scale: 5
    t.decimal "loan_amount", precision: 15, scale: 2
    t.text "note"
    t.string "status", default: "active"
    t.datetime "updated_at", null: false
    t.index ["asset_setting_id"], name: "index_contracts_on_asset_setting_id"
    t.index ["branch_id"], name: "index_contracts_on_branch_id"
    t.index ["cashier_id"], name: "index_contracts_on_cashier_id"
    t.index ["created_by_id"], name: "index_contracts_on_created_by_id"
    t.index ["customer_id"], name: "index_contracts_on_customer_id"
  end

  create_table "customers", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.string "address"
    t.uuid "branch_id", null: false
    t.datetime "created_at", null: false
    t.uuid "created_by_id", null: false
    t.string "customer_code", null: false
    t.string "full_name", null: false
    t.boolean "is_seed_capital", default: false
    t.string "national_id"
    t.date "national_id_issued_date"
    t.string "national_id_issued_place"
    t.string "phone"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_customers_on_branch_id"
    t.index ["created_by_id"], name: "index_customers_on_created_by_id"
  end

  create_table "financial_transactions", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.uuid "contract_id", null: false
    t.datetime "created_at", null: false
    t.uuid "created_by_id", null: false
    t.string "description"
    t.string "reference_number"
    t.date "transaction_date", null: false
    t.string "transaction_number", null: false
    t.uuid "transaction_type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_financial_transactions_on_contract_id"
    t.index ["created_by_id"], name: "index_financial_transactions_on_created_by_id"
    t.index ["transaction_type_id"], name: "index_financial_transactions_on_transaction_type_id"
  end

  create_table "interest_rate_histories", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.date "effective_date", null: false
    t.float "interest_rate", null: false
    t.uuid "processed_by_id", null: false
    t.datetime "updated_at", null: false
    t.index ["processed_by_id"], name: "index_interest_rate_histories_on_processed_by_id"
  end

  create_table "provinces", primary_key: "code", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.integer "administrative_unit_id"
    t.string "code_name", limit: 255
    t.string "full_name", limit: 255, null: false
    t.string "full_name_en", limit: 255
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255
    t.index ["administrative_unit_id"], name: "idx_provinces_unit"
  end

  create_table "transaction_types", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "is_income"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "branch_id", null: false
    t.string "confirmation_token", limit: 128
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "full_name", null: false
    t.string "phone"
    t.string "remember_token", limit: 128, null: false
    t.string "status", default: "active"
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

  create_table "versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.string "item_id", null: false
    t.string "item_type", null: false
    t.text "object"
    t.text "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "wards", primary_key: "code", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.integer "administrative_unit_id"
    t.string "code_name", limit: 255
    t.string "full_name", limit: 255
    t.string "full_name_en", limit: 255
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255
    t.string "province_code", limit: 20
    t.index ["administrative_unit_id"], name: "idx_wards_unit"
    t.index ["province_code"], name: "idx_wards_province"
  end

  add_foreign_key "asset_setting_attributes", "asset_settings"
  add_foreign_key "asset_setting_categories", "asset_settings"
  add_foreign_key "asset_setting_categories", "contract_types", column: "contract_type_code", primary_key: "code"
  add_foreign_key "asset_setting_values", "asset_setting_attributes"
  add_foreign_key "asset_setting_values", "contracts"
  add_foreign_key "asset_settings", "branches"
  add_foreign_key "branch_contract_types", "branches"
  add_foreign_key "branch_contract_types", "contract_types", column: "contract_type_code", primary_key: "code"
  add_foreign_key "branches", "provinces", primary_key: "code"
  add_foreign_key "branches", "wards", primary_key: "code"
  add_foreign_key "contract_amount_changes", "contracts"
  add_foreign_key "contract_amount_changes", "users", column: "processed_by_id"
  add_foreign_key "contract_extensions", "contracts"
  add_foreign_key "contract_interest_payments", "contracts"
  add_foreign_key "contract_terminations", "contracts"
  add_foreign_key "contract_terminations", "users", column: "processed_by_id"
  add_foreign_key "contracts", "asset_settings"
  add_foreign_key "contracts", "branches"
  add_foreign_key "contracts", "contract_types", column: "contract_type_code", primary_key: "code"
  add_foreign_key "contracts", "customers"
  add_foreign_key "contracts", "users", column: "cashier_id"
  add_foreign_key "contracts", "users", column: "created_by_id"
  add_foreign_key "customers", "branches"
  add_foreign_key "customers", "users", column: "created_by_id"
  add_foreign_key "financial_transactions", "contracts"
  add_foreign_key "financial_transactions", "transaction_types"
  add_foreign_key "financial_transactions", "users", column: "created_by_id"
  add_foreign_key "interest_rate_histories", "users", column: "processed_by_id"
  add_foreign_key "provinces", "administrative_units", name: "provinces_administrative_unit_id_fkey"
  add_foreign_key "users", "branches"
  add_foreign_key "wards", "administrative_units", name: "wards_administrative_unit_id_fkey"
  add_foreign_key "wards", "provinces", column: "province_code", primary_key: "code", name: "wards_province_code_fkey"

  create_view "interest_late_contracts", sql_definition: <<-SQL
      WITH client_timezone AS (
           SELECT ((now() AT TIME ZONE 'Asia/Ho_Chi_Minh'::text))::date AS "current_date"
          ), interest_payment_schedule AS (
           SELECT contract_interest_payments.contract_id,
              min(contract_interest_payments."to") AS date,
              max(contract_interest_payments."to") AS end_date
             FROM contract_interest_payments
            WHERE ((contract_interest_payments.payment_status)::text = 'unpaid'::text)
            GROUP BY contract_interest_payments.contract_id
          )
   SELECT c.id,
      c.code,
      c.customer_id,
      c.branch_id,
      c.cashier_id,
      c.created_by_id,
      c.asset_setting_id,
      c.asset_name,
      c.contract_type_code,
      c.loan_amount,
      c.interest_calculation_method,
      c.interest_rate,
      c.collect_interest_in_advance,
      c.contract_term,
      c.interest_period,
      c.contract_date,
      c.status,
      c.note,
      c.created_at,
      c.updated_at
     FROM (contracts c
       CROSS JOIN client_timezone)
    WHERE ((( SELECT interest_payment_schedule.date
             FROM interest_payment_schedule
            WHERE (interest_payment_schedule.contract_id = c.id)) < client_timezone."current_date") AND (client_timezone."current_date" < ( SELECT interest_payment_schedule.end_date
             FROM interest_payment_schedule
            WHERE (interest_payment_schedule.contract_id = c.id))) AND ((c.status)::text <> 'closed'::text));
  SQL
  create_view "on_time_contracts", sql_definition: <<-SQL
      WITH client_timezone AS (
           SELECT ((now() AT TIME ZONE 'Asia/Ho_Chi_Minh'::text))::date AS "current_date"
          ), interest_payment_schedule AS (
           SELECT contract_interest_payments.contract_id,
              min(contract_interest_payments."to") AS date,
              max(contract_interest_payments."to") AS end_date
             FROM contract_interest_payments
            WHERE ((contract_interest_payments.payment_status)::text = 'unpaid'::text)
            GROUP BY contract_interest_payments.contract_id
          )
   SELECT c.id,
      c.code,
      c.customer_id,
      c.branch_id,
      c.cashier_id,
      c.created_by_id,
      c.asset_setting_id,
      c.asset_name,
      c.contract_type_code,
      c.loan_amount,
      c.interest_calculation_method,
      c.interest_rate,
      c.collect_interest_in_advance,
      c.contract_term,
      c.interest_period,
      c.contract_date,
      c.status,
      c.note,
      c.created_at,
      c.updated_at
     FROM (contracts c
       CROSS JOIN client_timezone)
    WHERE ((client_timezone."current_date" <= ( SELECT interest_payment_schedule.date
             FROM interest_payment_schedule
            WHERE (interest_payment_schedule.contract_id = c.id))) AND (client_timezone."current_date" <= ( SELECT interest_payment_schedule.end_date
             FROM interest_payment_schedule
            WHERE (interest_payment_schedule.contract_id = c.id))) AND ((c.status)::text <> 'closed'::text));
  SQL
  create_view "overdue_contracts", sql_definition: <<-SQL
      WITH client_timezone AS (
           SELECT ((now() AT TIME ZONE 'Asia/Ho_Chi_Minh'::text))::date AS date
          ), interest_payment_schedule AS (
           SELECT contract_interest_payments.contract_id,
              max(contract_interest_payments."to") AS date
             FROM contract_interest_payments
            GROUP BY contract_interest_payments.contract_id
          )
   SELECT c.id,
      c.code,
      c.customer_id,
      c.branch_id,
      c.cashier_id,
      c.created_by_id,
      c.asset_setting_id,
      c.asset_name,
      c.contract_type_code,
      c.loan_amount,
      c.interest_calculation_method,
      c.interest_rate,
      c.collect_interest_in_advance,
      c.contract_term,
      c.interest_period,
      c.contract_date,
      c.status,
      c.note,
      c.created_at,
      c.updated_at
     FROM (contracts c
       CROSS JOIN client_timezone)
    WHERE ((( SELECT interest_payment_schedule.date
             FROM interest_payment_schedule
            WHERE (interest_payment_schedule.contract_id = c.id)) < client_timezone.date) AND ((c.status)::text <> 'closed'::text));
  SQL
end
