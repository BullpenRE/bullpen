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

ActiveRecord::Schema.define(version: 2020_12_15_062333) do

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

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
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

  create_table "certifications", force: :cascade do |t|
    t.string "description"
    t.boolean "disable", default: false
    t.boolean "custom", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employer_profiles", force: :cascade do |t|
    t.string "company_name"
    t.string "company_website"
    t.string "role_in_company"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "employee_count"
    t.integer "category"
    t.boolean "motivation_one_time"
    t.boolean "motivation_ongoing_support"
    t.boolean "motivation_backfill"
    t.boolean "motivation_augment"
    t.boolean "motivation_other"
    t.string "current_step"
    t.boolean "completed", default: false
    t.index ["user_id"], name: "index_employer_profiles_on_user_id"
  end

  create_table "employer_sectors", force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "employer_profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employer_profile_id"], name: "index_employer_sectors_on_employer_profile_id"
    t.index ["sector_id"], name: "index_employer_sectors_on_sector_id"
  end

  create_table "freelancer_certifications", force: :cascade do |t|
    t.bigint "freelancer_profile_id", null: false
    t.bigint "certification_id", null: false
    t.string "description"
    t.date "earned"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["certification_id"], name: "index_freelancer_certifications_on_certification_id"
    t.index ["freelancer_profile_id"], name: "index_freelancer_certifications_on_freelancer_profile_id"
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
    t.integer "curation", default: 0
    t.boolean "draft", default: true
    t.string "current_step"
    t.string "slug"
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

  create_table "freelancer_sectors", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "freelancer_profile_id"
    t.bigint "sector_id"
    t.index ["freelancer_profile_id"], name: "index_freelancer_sectors_on_freelancer_profile_id"
    t.index ["sector_id"], name: "index_freelancer_sectors_on_sector_id"
  end

  create_table "freelancer_softwares", force: :cascade do |t|
    t.bigint "freelancer_profile_id", null: false
    t.bigint "software_id", null: false
    t.boolean "license", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["freelancer_profile_id"], name: "index_freelancer_softwares_on_freelancer_profile_id"
    t.index ["software_id"], name: "index_freelancer_softwares_on_software_id"
  end

  create_table "interview_requests", force: :cascade do |t|
    t.bigint "employer_profile_id", null: false
    t.bigint "freelancer_profile_id", null: false
    t.integer "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employer_profile_id"], name: "index_interview_requests_on_employer_profile_id"
    t.index ["freelancer_profile_id"], name: "index_interview_requests_on_freelancer_profile_id"
  end

  create_table "job_application_questions", force: :cascade do |t|
    t.bigint "job_application_id"
    t.bigint "job_question_id"
    t.text "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_application_id"], name: "index_job_application_questions_on_job_application_id"
    t.index ["job_question_id"], name: "index_job_application_questions_on_job_question_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "user_id"
    t.text "cover_letter"
    t.boolean "template", default: false
    t.integer "per_hour_bid"
    t.boolean "available_during_work_hours"
    t.integer "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "job_questions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_job_questions_on_job_id"
  end

  create_table "job_sectors", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "sector_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_job_sectors_on_job_id"
    t.index ["sector_id"], name: "index_job_sectors_on_sector_id"
  end

  create_table "job_skills", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_job_skills_on_job_id"
    t.index ["skill_id"], name: "index_job_skills_on_skill_id"
  end

  create_table "job_softwares", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "software_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_job_softwares_on_job_id"
    t.index ["software_id"], name: "index_job_softwares_on_software_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.string "short_description"
    t.integer "position_length"
    t.integer "hours_needed"
    t.integer "time_zone"
    t.boolean "daytime_availability_required"
    t.integer "required_experience"
    t.string "required_regional_knowledge"
    t.text "relevant_job_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "initial_creation", default: true
    t.integer "state", default: 0
    t.integer "contract_type"
    t.integer "pay_range_low"
    t.integer "pay_range_high"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "real_estate_skills", force: :cascade do |t|
    t.string "description", null: false
    t.boolean "disable", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string "description", null: false
    t.boolean "disable", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "signup_promos", force: :cascade do |t|
    t.string "description"
    t.string "code"
    t.integer "user_type"
    t.datetime "expires"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "description"
    t.boolean "disable", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "softwares", force: :cascade do |t|
    t.string "description"
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
    t.string "location"
    t.integer "role"
    t.bigint "signup_promo_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["signup_promo_id"], name: "index_users_on_signup_promo_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "employer_profiles", "users"
  add_foreign_key "employer_sectors", "employer_profiles"
  add_foreign_key "employer_sectors", "sectors"
  add_foreign_key "freelancer_certifications", "certifications"
  add_foreign_key "freelancer_certifications", "freelancer_profiles"
  add_foreign_key "freelancer_profile_educations", "freelancer_profiles"
  add_foreign_key "freelancer_profile_experiences", "freelancer_profiles"
  add_foreign_key "freelancer_profiles", "users"
  add_foreign_key "freelancer_softwares", "freelancer_profiles"
  add_foreign_key "freelancer_softwares", "softwares"
  add_foreign_key "interview_requests", "employer_profiles"
  add_foreign_key "interview_requests", "freelancer_profiles"
  add_foreign_key "job_application_questions", "job_applications"
  add_foreign_key "job_application_questions", "job_questions"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_applications", "users"
  add_foreign_key "job_questions", "jobs"
  add_foreign_key "job_sectors", "jobs"
  add_foreign_key "job_sectors", "sectors"
  add_foreign_key "job_skills", "jobs"
  add_foreign_key "job_skills", "skills"
  add_foreign_key "job_softwares", "jobs"
  add_foreign_key "job_softwares", "softwares"
  add_foreign_key "jobs", "users"
  add_foreign_key "users", "signup_promos"
end
