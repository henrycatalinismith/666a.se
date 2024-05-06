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

ActiveRecord::Schema[7.1].define(version: 2024_05_06_191043) do
  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "labour_law_documents", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_name"
    t.string "document_code"
    t.string "document_slug"
    t.index ["document_code"], name: "index_labour_law_documents_on_document_code", unique: true
    t.index ["document_slug"], name: "index_labour_law_documents_on_document_slug", unique: true
  end

  create_table "labour_law_elements", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "revision_id", null: false
    t.string "element_code"
    t.string "element_text"
    t.decimal "element_index"
    t.string "element_chapter"
    t.string "element_section"
    t.string "element_paragraph"
    t.integer "element_type", default: 0
    t.index ["element_code"], name: "index_labour_law_elements_on_element_code"
    t.index ["revision_id", "element_chapter", "element_section", "element_paragraph"], name: "idx_on_revision_id_element_chapter_element_section__60f325e081"
    t.index ["revision_id"], name: "index_labour_law_elements_on_revision_id"
  end

  create_table "labour_law_revisions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_id", null: false
    t.string "revision_name"
    t.string "revision_code"
    t.integer "revision_status"
    t.text "revision_notice"
    t.index "\"element_index\"", name: "index_legal_revisions_on_element_index"
    t.index "\"element_locale\"", name: "index_legal_revisions_on_element_locale"
    t.index ["document_id"], name: "index_labour_law_revisions_on_document_id"
    t.index ["revision_code"], name: "index_labour_law_revisions_on_revision_code"
  end

  create_table "labour_law_translations", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "element_id", null: false
    t.string "translation_locale"
    t.string "translation_text"
    t.index ["element_id"], name: "index_labour_law_translations_on_element_id"
    t.index ["translation_locale"], name: "index_labour_law_translations_on_translation_locale"
  end

  create_table "posts", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "slug"
    t.date "date"
    t.string "body_en"
    t.string "body_sv"
    t.string "description"
    t.index ["date"], name: "index_posts_on_date"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "time_period_days", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.integer "ingestion_status"
    t.string "week_id"
    t.decimal "request_count"
    t.index ["date"], name: "index_time_period_days_on_date", unique: true
    t.index ["week_id"], name: "index_time_period_days_on_week_id"
  end

  create_table "time_period_weeks", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "week_code"
    t.index ["week_code"], name: "index_time_period_weeks_on_week_code"
  end

  create_table "user_accounts", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "company_code"
    t.string "locale", default: "en"
    t.index ["email"], name: "index_user_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_user_accounts_on_reset_password_token", unique: true
  end

  create_table "user_notifications", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_id", null: false
    t.string "subscription_id", null: false
    t.integer "email_status"
    t.index ["document_id", "subscription_id"], name: "index_user_notifications_on_document_id_and_subscription_id", unique: true
    t.index ["document_id"], name: "index_user_notifications_on_document_id"
    t.index ["subscription_id"], name: "index_user_notifications_on_subscription_id"
  end

  create_table "user_roles", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_id", null: false
    t.integer "name"
    t.index ["account_id"], name: "index_user_roles_on_account_id"
  end

  create_table "user_subscriptions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_id", null: false
    t.string "company_code"
    t.integer "subscription_status", default: 1
    t.integer "subscription_type"
    t.string "workplace_code"
    t.index ["account_id"], name: "index_user_subscriptions_on_account_id"
    t.index ["subscription_status"], name: "index_user_subscriptions_on_subscription_status"
  end

  create_table "work_environment_documents", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_code"
    t.date "document_date"
    t.integer "document_direction"
    t.string "document_type"
    t.string "case_code"
    t.string "case_name"
    t.integer "case_status"
    t.string "company_code"
    t.string "company_name"
    t.string "workplace_code"
    t.string "workplace_name"
    t.string "county_code"
    t.string "county_name"
    t.string "municipality_code"
    t.string "municipality_name"
    t.date "case_date"
    t.index ["document_code"], name: "index_work_environment_documents_on_document_code", unique: true
  end

  create_table "work_environment_results", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "search_id", null: false
    t.integer "metadata_status"
    t.string "document_code"
    t.string "case_name"
    t.string "document_type"
    t.string "document_date"
    t.string "organisation_name"
    t.string "metadata"
    t.integer "document_status"
    t.index ["document_status"], name: "index_work_environment_results_on_document_status"
    t.index ["metadata_status"], name: "index_work_environment_results_on_metadata_status"
    t.index ["search_id"], name: "index_work_environment_results_on_search_id"
  end

  create_table "work_environment_searches", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "day_id", null: false
    t.integer "page_number"
    t.integer "result_status"
    t.string "hit_count"
    t.index ["day_id"], name: "index_work_environment_searches_on_day_id"
  end

  add_foreign_key "labour_law_elements", "labour_law_revisions", column: "revision_id"
  add_foreign_key "labour_law_revisions", "labour_law_documents", column: "document_id"
  add_foreign_key "labour_law_translations", "labour_law_elements", column: "element_id"
  add_foreign_key "time_period_days", "time_period_weeks", column: "week_id"
  add_foreign_key "user_notifications", "user_subscriptions", column: "subscription_id"
  add_foreign_key "user_notifications", "work_environment_documents", column: "document_id"
  add_foreign_key "user_roles", "user_accounts", column: "account_id"
  add_foreign_key "user_subscriptions", "user_accounts", column: "account_id"
  add_foreign_key "work_environment_results", "work_environment_searches", column: "search_id"
  add_foreign_key "work_environment_searches", "time_period_days", column: "day_id"
end
