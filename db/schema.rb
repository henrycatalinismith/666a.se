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

ActiveRecord::Schema[7.1].define(version: 2023_10_27_193305) do
  create_table "days", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.integer "ingestion_status"
    t.index ["date"], name: "index_days_on_date", unique: true
  end

  create_table "legal_documents", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_name"
    t.string "document_code"
    t.index ["document_code"], name: "index_legal_documents_on_document_code", unique: true
  end

  create_table "legal_revisions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_id", null: false
    t.string "revision_name"
    t.string "revision_code"
    t.index ["document_id"], name: "index_legal_revisions_on_document_id"
    t.index ["revision_code"], name: "index_legal_revisions_on_revision_code", unique: true
  end

  create_table "policies", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "icon"
    t.text "slug"
    t.string "body"
    t.index ["slug"], name: "index_policies_on_slug", unique: true
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

  create_table "roles", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.integer "name"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "users", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
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
    t.integer "notification_status"
    t.date "case_date"
    t.index ["document_code"], name: "index_work_environment_documents_on_document_code", unique: true
    t.index ["notification_status"], name: "index_work_environment_documents_on_notification_status"
  end

  create_table "work_environment_notifications", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_id", null: false
    t.string "subscription_id", null: false
    t.integer "email_status"
    t.index ["document_id", "subscription_id"], name: "idx_on_document_id_subscription_id_0026b0deb2", unique: true
    t.index ["document_id"], name: "index_work_environment_notifications_on_document_id"
    t.index ["subscription_id"], name: "index_work_environment_notifications_on_subscription_id"
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

  create_table "work_environment_subscriptions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.string "company_code"
    t.integer "subscription_status", default: 1
    t.integer "subscription_type"
    t.string "workplace_code"
    t.index ["subscription_status"], name: "index_work_environment_subscriptions_on_subscription_status"
    t.index ["user_id"], name: "index_work_environment_subscriptions_on_user_id"
  end

  add_foreign_key "legal_revisions", "legal_documents", column: "document_id"
  add_foreign_key "roles", "users"
  add_foreign_key "work_environment_notifications", "work_environment_documents", column: "document_id"
  add_foreign_key "work_environment_notifications", "work_environment_subscriptions", column: "subscription_id"
  add_foreign_key "work_environment_results", "work_environment_searches", column: "search_id"
  add_foreign_key "work_environment_searches", "days"
  add_foreign_key "work_environment_subscriptions", "users"
end
