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

ActiveRecord::Schema[7.1].define(version: 2023_09_26_200330) do
  create_table "notifications", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "refresh_id", null: false
    t.string "result_id", null: false
    t.integer "email_status"
    t.index ["refresh_id"], name: "index_notifications_on_refresh_id"
    t.index ["result_id"], name: "index_notifications_on_result_id"
  end

  create_table "refreshes", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subscription_id", null: false
    t.integer "status"
    t.index ["subscription_id"], name: "index_refreshes_on_subscription_id"
  end

  create_table "results", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "search_id", null: false
    t.string "case_name"
    t.string "company_code"
    t.string "company_name"
    t.string "document_code"
    t.string "document_date"
    t.string "document_type"
    t.index ["search_id"], name: "index_results_on_search_id"
  end

  create_table "searches", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "hit_count"
    t.string "url"
    t.string "refresh_id"
    t.index ["refresh_id"], name: "index_searches_on_refresh_id"
  end

  create_table "subscriptions", id: :string, default: -> { "ULID()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.string "company_code"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "notifications", "refreshes"
  add_foreign_key "notifications", "results"
  add_foreign_key "refreshes", "subscriptions"
  add_foreign_key "results", "searches"
  add_foreign_key "searches", "refreshes"
  add_foreign_key "subscriptions", "users"
end
