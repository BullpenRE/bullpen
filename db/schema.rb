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

ActiveRecord::Schema.define(version: 2021_04_18_200022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
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

  create_table "billings", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.date "work_done"
    t.integer "hours"
    t.integer "minutes"
    t.string "description"
    t.integer "state", default: 0
    t.string "dispute_comments"
    t.date "dispute_resolved"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "timesheet_id"
    t.index ["contract_id"], name: "index_billings_on_contract_id"
    t.index ["timesheet_id"], name: "index_billings_on_timesheet_id"
  end

  create_table "certifications", force: :cascade do |t|
    t.string "description"
    t.boolean "disable", default: false
    t.boolean "custom", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "employer_profile_id", null: false
    t.bigint "freelancer_profile_id", null: false
    t.bigint "job_id"
    t.string "title"
    t.integer "contract_type"
    t.integer "pay_rate"
    t.integer "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "hide_from_freelancer", default: false
    t.boolean "hide_from_employer", default: false
    t.bigint "payment_account_id"
    t.index ["employer_profile_id"], name: "index_contracts_on_employer_profile_id"
    t.index ["freelancer_profile_id"], name: "index_contracts_on_freelancer_profile_id"
    t.index ["job_id"], name: "index_contracts_on_job_id"
    t.index ["payment_account_id"], name: "index_contracts_on_payment_account_id"
  end

  create_table "credits", force: :cascade do |t|
    t.bigint "timesheet_id"
    t.integer "applied_to", default: 0
    t.string "description"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["timesheet_id"], name: "index_credits_on_timesheet_id"
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
    t.string "stripe_id_account"
    t.string "stripe_id_customer"
    t.integer "credit_balance", default: 0
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
    t.float "latitude"
    t.float "longitude"
    t.index ["freelancer_profile_id"], name: "index_freelancer_profile_experiences_on_freelancer_profile_id"
    t.index ["latitude", "longitude"], name: "index_freelancer_profile_experiences_on_latitude_and_longitude"
  end

  create_table "freelancer_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "professional_title"
    t.text "professional_summary"
    t.integer "curation", default: 0
    t.boolean "draft", default: true
    t.string "current_step"
    t.string "slug"
    t.integer "desired_hourly_rate"
    t.boolean "new_jobs_alert", default: true
    t.boolean "searchable", default: true
    t.integer "payout_percentage", default: 70
    t.string "stripe_id_account"
    t.integer "credit_balance", default: 0
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
    t.boolean "hide_from_freelancer", default: false
    t.boolean "hide_from_employer", default: false
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
    t.boolean "template", default: false
    t.integer "bid_amount"
    t.boolean "available_during_work_hours"
    t.integer "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "applied_at", precision: 6
    t.boolean "liked", default: false
    t.bigint "freelancer_profile_id"
    t.index ["freelancer_profile_id"], name: "index_job_applications_on_freelancer_profile_id"
    t.index ["job_id"], name: "index_job_applications_on_job_id"
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
    t.string "title"
    t.string "short_description"
    t.integer "position_length"
    t.integer "hours_needed"
    t.integer "time_zone"
    t.boolean "daytime_availability_required"
    t.integer "required_experience"
    t.string "required_regional_knowledge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "initial_creation", default: true
    t.integer "state", default: 3
    t.integer "contract_type"
    t.integer "pay_range_low"
    t.integer "pay_range_high"
    t.string "slug"
    t.boolean "job_announced", default: false
    t.bigint "employer_profile_id"
    t.index ["employer_profile_id"], name: "index_jobs_on_employer_profile_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "from_user_id", null: false
    t.bigint "to_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_user_id"], name: "index_messages_on_from_user_id"
    t.index ["to_user_id"], name: "index_messages_on_to_user_id"
  end

  create_table "payment_accounts", force: :cascade do |t|
    t.bigint "employer_profile_id", null: false
    t.integer "stripe_object"
    t.string "id_stripe"
    t.string "last_four"
    t.string "fingerprint"
    t.string "card_brand"
    t.date "card_expires"
    t.string "card_cvc_check"
    t.string "bank_name"
    t.string "bank_routing_number"
    t.string "bank_status"
    t.boolean "is_default", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employer_profile_id"], name: "index_payment_accounts_on_employer_profile_id"
  end

  create_table "real_estate_skills", force: :cascade do |t|
    t.string "description", null: false
    t.boolean "disable", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "employer_profile_id", null: false
    t.bigint "freelancer_profile_id", null: false
    t.integer "rating"
    t.text "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employer_profile_id"], name: "index_reviews_on_employer_profile_id"
    t.index ["freelancer_profile_id"], name: "index_reviews_on_freelancer_profile_id"
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

  create_table "timesheets", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.string "description"
    t.date "starts"
    t.date "ends"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "employer_notified_of_freelancer_changes", default: true
    t.string "stripe_id_invoice"
    t.string "invoice_number"
    t.datetime "employer_charged_on"
    t.string "pdf_invoice_link"
    t.index ["contract_id"], name: "index_timesheets_on_contract_id"
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
    t.string "uid"
    t.string "provider"
    t.float "latitude"
    t.float "longitude"
    t.boolean "disable", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["signup_promo_id"], name: "index_users_on_signup_promo_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "billings", "contracts"
  add_foreign_key "billings", "timesheets"
  add_foreign_key "contracts", "employer_profiles"
  add_foreign_key "contracts", "freelancer_profiles"
  add_foreign_key "contracts", "jobs"
  add_foreign_key "contracts", "payment_accounts"
  add_foreign_key "credits", "timesheets"
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
  add_foreign_key "job_applications", "freelancer_profiles"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_questions", "jobs"
  add_foreign_key "job_sectors", "jobs"
  add_foreign_key "job_sectors", "sectors"
  add_foreign_key "job_skills", "jobs"
  add_foreign_key "job_skills", "skills"
  add_foreign_key "job_softwares", "jobs"
  add_foreign_key "job_softwares", "softwares"
  add_foreign_key "jobs", "employer_profiles"
  add_foreign_key "payment_accounts", "employer_profiles"
  add_foreign_key "reviews", "employer_profiles"
  add_foreign_key "reviews", "freelancer_profiles"
  add_foreign_key "timesheets", "contracts"
  add_foreign_key "users", "signup_promos"
end
