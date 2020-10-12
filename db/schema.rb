# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_12_111627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "asset_classes", force: :cascade do |t|
    t.string "description", null: false
    t.boolean "disable", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "freelancer_asset_classes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "freelancer_profile_id"
    t.bigint "asset_class_id"
    t.index ["asset_class_id"], name: "index_freelancer_asset_classes_on_asset_class_id"
    t.index ["freelancer_profile_id"], name: "index_freelancer_asset_classes_on_freelancer_profile_id"
  end

  create_table "freelancer_profile_educations", force: :cascade do |t|
    t.bigint "freelancer_profile_id", null: false
    t.string "institution"
    t.integer "degree"
    t.string "course_of_study"
    t.integer "graduation_year"
    t.boolean "currently_studying", default: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["freelancer_profile_id"], name: "index_freelancer_profile_educations_on_freelancer_profile_id"
  end

  create_table "freelancer_profile_experiences", force: :cascade do |t|
    t.string "job_title"
    t.string "company"
    t.string "location"
    t.date "start_date"
    t.date "end_date"
    t.boolean "current_job", default: false
    t.text "description"
    t.bigint "freelancer_profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["freelancer_profile_id"], name: "index_freelancer_profile_experiences_on_freelancer_profile_id"
  end

  create_table "freelancer_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "professional_title"
    t.integer "professional_years_experience"
    t.text "professional_summary"
    t.index ["user_id"], name: "index_freelancer_profiles_on_user_id"
  end

  create_table "freelancer_real_estate_skills", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "freelancer_profile_id"
    t.bigint "real_estate_skill_id"
    t.index ["freelancer_profile_id"], name: "index_freelancer_real_estate_skills_on_freelancer_profile_id"
    t.index ["real_estate_skill_id"], name: "index_freelancer_real_estate_skills_on_real_estate_skill_id"
  end

  create_table "real_estate_skills", force: :cascade do |t|
    t.string "description", null: false
    t.boolean "disable", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.boolean "is_employer"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "freelancer_profile_educations", "freelancer_profiles"
  add_foreign_key "freelancer_profile_experiences", "freelancer_profiles"
  add_foreign_key "freelancer_profiles", "users"
end
