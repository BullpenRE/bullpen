class InitSchemaAfterSquash < ActiveRecord::Migration[6.1]
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"

    create_table "action_text_rich_texts", force: false do |t|
      t.string "name", null: false
      t.text "body"
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
    end unless table_exists?(:action_text_rich_texts)

    create_table "active_admin_comments", force: false do |t|
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
    end unless table_exists?(:active_admin_comments)

    create_table "active_storage_attachments", force: false do |t|
      t.string "name", null: false
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.bigint "blob_id", null: false
      t.datetime "created_at", null: false
      t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
      t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    end unless table_exists?(:active_storage_attachments)

    create_table "active_storage_blobs", force: false do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.bigint "byte_size", null: false
      t.string "checksum", null: false
      t.datetime "created_at", null: false
      t.string "service_name", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end unless table_exists?(:active_storage_blobs)

    create_table "active_storage_variant_records", force: false do |t|
      t.bigint "blob_id", null: false
      t.string "variation_digest", null: false
      t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
    end unless table_exists?(:active_storage_variant_records)

    create_table "admin_users", force: false do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["email"], name: "index_admin_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    end unless table_exists?(:admin_users)

    create_table "billings", force: false do |t|
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
    end unless table_exists?(:billings)

    create_table "certifications", force: false do |t|
      t.string "description"
      t.boolean "disable", default: false
      t.boolean "custom", default: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:certifications)

    create_table "contracts", force: false do |t|
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
    end unless table_exists?(:contracts)

    create_table "credits", force: false do |t|
      t.bigint "timesheet_id"
      t.integer "applied_to", default: 0
      t.string "description"
      t.integer "amount"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["timesheet_id"], name: "index_credits_on_timesheet_id"
    end unless table_exists?(:credits)

    create_table "employer_profiles", force: false do |t|
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
    end unless table_exists?(:employer_profiles)

    create_table "employer_sectors", force: false do |t|
      t.bigint "sector_id", null: false
      t.bigint "employer_profile_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["employer_profile_id"], name: "index_employer_sectors_on_employer_profile_id"
      t.index ["sector_id"], name: "index_employer_sectors_on_sector_id"
    end unless table_exists?(:employer_sectors)

    create_table "freelancer_certifications", force: false do |t|
      t.bigint "freelancer_profile_id", null: false
      t.bigint "certification_id", null: false
      t.string "description"
      t.date "earned"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["certification_id"], name: "index_freelancer_certifications_on_certification_id"
      t.index ["freelancer_profile_id"], name: "index_freelancer_certifications_on_freelancer_profile_id"
    end unless table_exists?(:freelancer_certifications)

    create_table "freelancer_profile_educations", force: false do |t|
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
    end unless table_exists?(:freelancer_profile_educations)

    create_table "freelancer_profile_experiences", force: false do |t|
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
    end unless table_exists?(:freelancer_profile_experiences)

    create_table "freelancer_profiles", force: false do |t|
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
    end unless table_exists?(:freelancer_profiles)

    create_table "freelancer_real_estate_skills", force: false do |t|
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "freelancer_profile_id"
      t.bigint "real_estate_skill_id"
      t.index ["freelancer_profile_id"], name: "index_freelancer_real_estate_skills_on_freelancer_profile_id"
      t.index ["real_estate_skill_id"], name: "index_freelancer_real_estate_skills_on_real_estate_skill_id"
    end unless table_exists?(:freelancer_real_estate_skills)

    create_table "freelancer_sectors", force: false do |t|
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.bigint "freelancer_profile_id"
      t.bigint "sector_id"
      t.index ["freelancer_profile_id"], name: "index_freelancer_sectors_on_freelancer_profile_id"
      t.index ["sector_id"], name: "index_freelancer_sectors_on_sector_id"
    end unless table_exists?(:freelancer_sectors)

    create_table "freelancer_softwares", force: false do |t|
      t.bigint "freelancer_profile_id", null: false
      t.bigint "software_id", null: false
      t.boolean "license", default: true
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["freelancer_profile_id"], name: "index_freelancer_softwares_on_freelancer_profile_id"
      t.index ["software_id"], name: "index_freelancer_softwares_on_software_id"
    end unless table_exists?(:freelancer_softwares)

    create_table "interview_requests", force: false do |t|
      t.bigint "employer_profile_id", null: false
      t.bigint "freelancer_profile_id", null: false
      t.integer "state"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.boolean "hide_from_freelancer", default: false
      t.boolean "hide_from_employer", default: false
      t.index ["employer_profile_id"], name: "index_interview_requests_on_employer_profile_id"
      t.index ["freelancer_profile_id"], name: "index_interview_requests_on_freelancer_profile_id"
    end unless table_exists?(:interview_requests)

    create_table "job_application_questions", force: false do |t|
      t.bigint "job_application_id"
      t.bigint "job_question_id"
      t.text "answer"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["job_application_id"], name: "index_job_application_questions_on_job_application_id"
      t.index ["job_question_id"], name: "index_job_application_questions_on_job_question_id"
    end unless table_exists?(:job_application_questions)

    create_table "job_applications", force: false do |t|
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
    end unless table_exists?(:job_applications)

    create_table "job_questions", force: false do |t|
      t.bigint "job_id", null: false
      t.string "description"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["job_id"], name: "index_job_questions_on_job_id"
    end unless table_exists?(:job_questions)

    create_table "job_sectors", force: false do |t|
      t.bigint "job_id", null: false
      t.bigint "sector_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["job_id"], name: "index_job_sectors_on_job_id"
      t.index ["sector_id"], name: "index_job_sectors_on_sector_id"
    end unless table_exists?(:job_sectors)

    create_table "job_skills", force: false do |t|
      t.bigint "job_id", null: false
      t.bigint "skill_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["job_id"], name: "index_job_skills_on_job_id"
      t.index ["skill_id"], name: "index_job_skills_on_skill_id"
    end unless table_exists?(:job_skills)

    create_table "job_softwares", force: false do |t|
      t.bigint "job_id", null: false
      t.bigint "software_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["job_id"], name: "index_job_softwares_on_job_id"
      t.index ["software_id"], name: "index_job_softwares_on_software_id"
    end unless table_exists?(:job_softwares)

    create_table "jobs", force: false do |t|
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
    end unless table_exists?(:jobs)

    create_table "messages", force: false do |t|
      t.bigint "from_user_id", null: false
      t.bigint "to_user_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["from_user_id"], name: "index_messages_on_from_user_id"
      t.index ["to_user_id"], name: "index_messages_on_to_user_id"
    end unless table_exists?(:messages)

    create_table "payment_accounts", force: false do |t|
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
    end unless table_exists?(:payment_accounts)

    create_table "real_estate_skills", force: false do |t|
      t.string "description", null: false
      t.boolean "disable", default: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:real_estate_skills)

    create_table "reviews", force: false do |t|
      t.bigint "employer_profile_id", null: false
      t.bigint "freelancer_profile_id", null: false
      t.integer "rating"
      t.text "comments"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["employer_profile_id"], name: "index_reviews_on_employer_profile_id"
      t.index ["freelancer_profile_id"], name: "index_reviews_on_freelancer_profile_id"
    end unless table_exists?(:reviews)

    create_table "sectors", force: false do |t|
      t.string "description", null: false
      t.boolean "disable", default: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:sectors)

    create_table "signup_promos", force: false do |t|
      t.string "description"
      t.string "code"
      t.integer "user_type"
      t.datetime "expires"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:signup_promos)

    create_table "skills", force: false do |t|
      t.string "description"
      t.boolean "disable", default: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:skills)

    create_table "softwares", force: false do |t|
      t.string "description"
      t.boolean "disable", default: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:softwares)

    create_table "timesheets", force: false do |t|
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
    end unless table_exists?(:timesheets)

    create_table "users", force: false do |t|
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
    end unless table_exists?(:users)

    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id" unless foreign_key_exists?(:active_storage_attachments, :active_storage_blobs, column: "blob_id")
    add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id" unless foreign_key_exists?(:active_storage_variant_records, :active_storage_blobs, column: "blob_id")
    add_foreign_key "billings", "contracts" unless foreign_key_exists?(:billings, :contracts)
    add_foreign_key "billings", "timesheets" unless foreign_key_exists?(:billings, :timesheets)
    add_foreign_key "contracts", "employer_profiles" unless foreign_key_exists?(:contracts, :employer_profiles)
    add_foreign_key "contracts", "freelancer_profiles" unless foreign_key_exists?(:contracts, :freelancer_profiles)
    add_foreign_key "contracts", "jobs" unless foreign_key_exists?(:contracts, :jobs)
    add_foreign_key "contracts", "payment_accounts" unless foreign_key_exists?(:contracts, :payment_accounts)
    add_foreign_key "credits", "timesheets" unless foreign_key_exists?(:credits, :timesheets)
    add_foreign_key "employer_profiles", "users" unless foreign_key_exists?(:employer_profiles, :users)
    add_foreign_key "employer_sectors", "employer_profiles" unless foreign_key_exists?(:employer_sectors, :employer_profiles)
    add_foreign_key "employer_sectors", "sectors" unless foreign_key_exists?(:employer_sectors, :sectors)
    add_foreign_key "freelancer_certifications", "certifications" unless foreign_key_exists?(:freelancer_certifications, :certifications)
    add_foreign_key "freelancer_certifications", "freelancer_profiles" unless foreign_key_exists?(:freelancer_certifications, :freelancer_profiles)
    add_foreign_key "freelancer_profile_educations", "freelancer_profiles" unless foreign_key_exists?(:freelancer_profile_educations, :freelancer_profiles)
    add_foreign_key "freelancer_profile_experiences", "freelancer_profiles" unless foreign_key_exists?(:freelancer_profile_experiences, :freelancer_profiles)
    add_foreign_key "freelancer_profiles", "users" unless foreign_key_exists?(:freelancer_profiles, :users)
    add_foreign_key "freelancer_softwares", "freelancer_profiles" unless foreign_key_exists?(:freelancer_softwares, :freelancer_profiles)
    add_foreign_key "freelancer_softwares", "softwares" unless foreign_key_exists?(:freelancer_softwares, :softwares)
    add_foreign_key "interview_requests", "employer_profiles" unless foreign_key_exists?(:interview_requests, :employer_profiles)
    add_foreign_key "interview_requests", "freelancer_profiles" unless foreign_key_exists?(:interview_requests, :freelancer_profiles)
    add_foreign_key "job_application_questions", "job_applications" unless foreign_key_exists?(:job_application_questions, :job_applications)
    add_foreign_key "job_application_questions", "job_questions" unless foreign_key_exists?(:job_application_questions, :job_questions)
    add_foreign_key "job_applications", "freelancer_profiles" unless foreign_key_exists?(:job_applications, :freelancer_profies)
    add_foreign_key "job_applications", "jobs" unless foreign_key_exists?(:job_applications, :jobs)
    add_foreign_key "job_questions", "jobs" unless foreign_key_exists?(:job_questions, :jobs)
    add_foreign_key "job_sectors", "jobs" unless foreign_key_exists?(:job_sectors, :jobs)
    add_foreign_key "job_sectors", "sectors" unless foreign_key_exists?(:job_sectors, :sectors)
    add_foreign_key "job_skills", "jobs" unless foreign_key_exists?(:job_skills, :jobs)
    add_foreign_key "job_skills", "skills" unless foreign_key_exists?(:job_skills, :skills)
    add_foreign_key "job_softwares", "jobs" unless foreign_key_exists?(:job_softwares, :jobs)
    add_foreign_key "job_softwares", "softwares" unless foreign_key_exists?(:job_softwares, :softwares)
    add_foreign_key "jobs", "employer_profiles" unless foreign_key_exists?(:jobs, :employer_profiles)
    add_foreign_key "payment_accounts", "employer_profiles" unless foreign_key_exists?(:payment_accounts, :employer_profiles)
    add_foreign_key "reviews", "employer_profiles" unless foreign_key_exists?(:reviews, :employer_profiles)
    add_foreign_key "reviews", "freelancer_profiles" unless foreign_key_exists?(:review, :freelancer_profiles)
    add_foreign_key "timesheets", "contracts" unless foreign_key_exists?(:timesheets, :contracts)
    add_foreign_key "users", "signup_promos" unless foreign_key_exists?(:users, :signup_promos)

    # The below code exists because we squashed migrations at the end of the project, in order to make it easier for
    # y'all to get it running on new environments. We had some database fields renamed which causes issues with new installs.
    old_migrations = %w[20200907191600 20201112133449 20201112133942 20201028094522 20201029074519 20201117143117 20201117145029 20201117173954 20201117141614 20201125152018 20201125161747 20201127034021 20201201202936 20201201205326 20201215062333 20201218003911 20201218011332 20201204105249 20201225113060 20201225121741 20201227172000 20201231005235 20210101085355 20210101085957 20210112021221 20210114190132 20210114191418 20210115025440 20210111162425 20210119133622 20210123162058 20210123162059 20210119204227 20210123121351 20210124074703 20210128193142 20210129133757 20210129135701 20210203010547 20210203162357 20210211104521 20210215232954 20210216235813 20210217023414 20210217231109 20210216164324 20210223144401 20210225175356 20210303162813 20210305071812 20210309131027 20210324034654 20210324092221 20210324103441 20210327041112 20210330051146 20210406200114 20210403101812 20210318155321 20210322180502 20210414061139 20210415142735 20210408092306 20210418200022 20210416054513 20210415163916]
    old_migrations.each do |migration|
      ActiveRecord::Base.connection.execute("DELETE FROM schema_migrations WHERE version = '#{migration}'")
    end
    Rails.application.load_seed
  end
end
