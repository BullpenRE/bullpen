class InitSchema < ActiveRecord::Migration[6.0]
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"

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
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end unless table_exists?(:active_storage_blobs)

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

    create_table "certifications", force: false do |t|
      t.string "description"
      t.boolean "disable", default: false
      t.boolean "custom", default: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:certifications)

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
      t.index ["freelancer_profile_id"], name: "index_freelancer_profile_experiences_on_freelancer_profile_id"
    end unless table_exists?(:freelancer_profile_experiences)

    create_table "freelancer_profiles", force: false do |t|
      t.bigint "user_id"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "professional_title"
      t.integer "professional_years_experience"
      t.text "professional_summary"
      t.integer "curation", default: 0
      t.boolean "draft", default: true
      t.string "current_step"
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
      t.bigint "user_id", null: false
      t.string "title"
      t.string "short_description"
      t.integer "position_length"
      t.integer "hours_needed"
      t.string "time_zone"
      t.boolean "daytime_availability_required"
      t.integer "required_experience"
      t.string "required_regional_knowledge"
      t.text "relevant_job_details"
      t.boolean "draft", default: true
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["user_id"], name: "index_jobs_on_user_id"
    end unless table_exists?(:jobs)

    create_table "real_estate_skills", force: false do |t|
      t.string "description", null: false
      t.boolean "disable", default: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:real_estate_skills)

    create_table "sectors", force: false do |t|
      t.string "description", null: false
      t.boolean "disable", default: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end unless table_exists?(:sectors)

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
      t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end unless table_exists?(:users)

    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id" unless foreign_key_exists?(:active_storage_attachments, :active_storage_blobs, column: "blob_id")
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
    add_foreign_key "job_questions", "jobs" unless foreign_key_exists?(:job_questions, :jobs)
    add_foreign_key "job_sectors", "jobs" unless foreign_key_exists?(:job_sectors, :jobs)
    add_foreign_key "job_sectors", "sectors" unless foreign_key_exists?(:job_sectors, :sectors)
    add_foreign_key "job_skills", "jobs" unless foreign_key_exists?(:job_skills, :jobs)
    add_foreign_key "job_skills", "skills" unless foreign_key_exists?(:job_skills, :skills)
    add_foreign_key "job_softwares", "jobs" unless foreign_key_exists?(:job_softwares, :jobs)
    add_foreign_key "job_softwares", "softwares" unless foreign_key_exists?(:job_softwares, :softwares)
    add_foreign_key "jobs", "users" unless foreign_key_exists?(:jobs, :users)

    old_migrations = %w[20201020124904 20200907191608 20200917151355 20200924152923 20200924153819 20200924160340 20200924162030 20200924163055 20201001055908 20201005095926 20201005172119 20201006161758 20201006161801 20201007161510 20201008073835 20201012111627 20201014041729 20201014152203 20201015130543 20201015131212 20201016221149 20201023223210 20201023223219 20201023230813 20201023230827 20201023231529 20201023231638 20201023231651 20201024224220 20201026111622 20201026112815 20201026115708 20201014170018 20201026205706 20201026213008 20201029003206 20201103022531 20201103235518 20201104004611 20201027150253]
    old_migrations.each do |migration|
      ActiveRecord::Base.connection.execute("DELETE FROM schema_migrations WHERE version = '#{migration}'")
    end
    Rails.application.load_seed

  end
end
