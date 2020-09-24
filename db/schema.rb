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

ActiveRecord::Schema.define(version: 2020_09_24_163055) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asset_classes", force: :cascade do |t|
    t.string "description", null: false
    t.boolean "disable", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "freelancer_asset_classes", force: :cascade do |t|
    t.bigint "freelancers_id"
    t.bigint "asset_classes_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["asset_classes_id"], name: "index_freelancer_asset_classes_on_asset_classes_id"
    t.index ["freelancers_id"], name: "index_freelancer_asset_classes_on_freelancers_id"
  end

  create_table "freelancer_real_estate_skills", force: :cascade do |t|
    t.bigint "freelancers_id"
    t.bigint "real_estate_skills_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["freelancers_id"], name: "index_freelancer_real_estate_skills_on_freelancers_id"
    t.index ["real_estate_skills_id"], name: "index_freelancer_real_estate_skills_on_real_estate_skills_id"
  end

  create_table "freelancers", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_freelancers_on_user_id"
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "freelancer_asset_classes", "asset_classes", column: "asset_classes_id"
  add_foreign_key "freelancer_asset_classes", "freelancers", column: "freelancers_id"
  add_foreign_key "freelancer_real_estate_skills", "freelancers", column: "freelancers_id"
  add_foreign_key "freelancer_real_estate_skills", "real_estate_skills", column: "real_estate_skills_id"
  add_foreign_key "freelancers", "users"
end
