# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190602044453) do

  create_table "attendances", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "beginning_time"
    t.datetime "leaving_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "attendance_day"
    t.string "note"
    t.datetime "scheduled_end_time"
    t.boolean "next_day", default: false
    t.string "business_outline"
    t.integer "instructor_test"
    t.boolean "leaving_next_day", default: false
    t.integer "attendance_test"
    t.boolean "change", default: false
    t.integer "application_status", default: 0
    t.integer "attendance_application_status", default: 0
    t.boolean "attendance_change", default: false
    t.datetime "before_beginning_time"
    t.datetime "before_leaving_time"
    t.date "attendance_approval_date"
    t.boolean "is_display_log", default: false
    t.datetime "first_beginning_time"
    t.datetime "first_leaving_time"
    t.boolean "is_display_log_leaving", default: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.string "base_name"
    t.integer "base_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "base_type"
  end

  create_table "one_month_attendances", force: :cascade do |t|
    t.integer "application_user_id"
    t.integer "authorizer_user_test"
    t.date "application_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "one_month_application_status", default: 0
    t.boolean "one_month_change", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "belong"
    t.time "designate_work_time"
    t.time "basic_work_time"
    t.time "designate_end_time"
    t.integer "number"
    t.integer "card_number"
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
