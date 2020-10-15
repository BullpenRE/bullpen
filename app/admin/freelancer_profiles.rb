ActiveAdmin.register FreelancerProfile do
  menu label: 'Freelancers'

  includes :user, :freelancer_asset_classes, :freelancer_real_estate_skills, :freelancer_profile_educations, :freelancer_profile_experiences

  filter :user_email, as: :string, label: 'User Email'

  permit_params :user_id,
                :professional_summary,
                :professional_title,
                :professional_years_experience

  index do
    column :user
    column 'Title', :professional_title
    column 'Years Experience', :professional_years_experience

    actions
  end

  show title: 'Freelancer Profile' do |freelancer_profile|
    attributes_table do
      row 'Email' do
        freelancer_profile.user.email
      end
      row :created_at
      row :updated_at
      row :professional_title
      row :professional_years_experience
      row :professional_summary
      row 'Asset Classes' do
        freelancer_profile.asset_classes.pluck(:description)
      end
      row 'Real Estate Skills' do
        freelancer_profile.real_estate_skills.pluck(:description)
      end
      row 'Education' do
        freelancer_profile.freelancer_profile_educations.map{|f_e| "#{'<i>(current)</i> ' if f_e.currently_studying}#{f_e.graduation_year} #{f_e.degree} in #{f_e.course_of_study} at #{f_e.institution}" }.join('<br>').html_safe
      end
      row 'Experience' do
        freelancer_profile.freelancer_profile_experiences.map{|f_e| "#{'<i>(current)</i> ' if f_e.current_job}#{f_e.start_date.year}#{"-#{f_e.end_date.year}" if f_e.end_date && f_e.end_date.year != f_e.start_date.year} #{f_e.job_title} at #{f_e.company}" }.join('<br>').html_safe
      end
    end
  end

  form do |f|
    f.inputs "#{f.object&.user&.email || 'New'} Freelancer Profile" do

      if f.object.new_record?
        f.input :user,
                as: :select,
                collection: User.no_freelancer_data.order(:email).pluck(:email, :id),
                label: "User (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
      end
      f.input :professional_title
      f.input :professional_years_experience
      f.input :professional_summary
      f.input :asset_classes, as: :check_boxes, collection: AssetClass.order(:description).pluck(:description, :id)
      f.input :real_estate_skills, as: :check_boxes, collection: RealEstateSkill.order(:description).pluck(:description, :id)
      f.actions
    end
  end

  controller do
    def create
      error_message = nil
      freelancer_profile = FreelancerProfile.new(permitted_params[:freelancer_profile])

      ApplicationRecord.transaction do
        freelancer_profile.save!
        update_asset_classes_and_real_estate_skills(freelancer_profile)
      rescue StandardError => e
        error_message = e.message
      end
      message = { alert: error_message } if error_message
      message ||= { notice: 'Successfully created!' }

      redirect_to admin_freelancer_profile_path(freelancer_profile), flash: message
    end

    def update
      error_message = nil

      freelancer_profile = FreelancerProfile.find(params[:id])
      update_asset_classes_and_real_estate_skills(freelancer_profile)

      ApplicationRecord.transaction do
        freelancer_profile.update!(permitted_params[:freelancer_profile])
      rescue StandardError => e
        error_message = e.message
      end

      message = { alert: error_message } if error_message
      message ||= { notice: 'Successfully updated!' }

      redirect_to admin_freelancer_profile_path(freelancer_profile), flash: message
    end

    def update_asset_classes_and_real_estate_skills(freelancer_profile)
      freelancer_profile.freelancer_asset_classes.destroy_all
      freelancer_profile.freelancer_real_estate_skills.destroy_all
      freelancer_profile.reload

      params[:freelancer_profile][:asset_class_ids].reject(&:empty?).each do |asset_class_id|
        freelancer_profile.freelancer_asset_classes.create(asset_class_id: asset_class_id.to_i)
      end
      params[:freelancer_profile][:real_estate_skill_ids].reject(&:empty?).each do |real_estate_skill_id|
        freelancer_profile.freelancer_real_estate_skills.create(real_estate_skill_id: real_estate_skill_id)
      end

      params[:freelancer_profile].delete(:asset_class_ids)
      params[:freelancer_profile].delete(:real_estate_skill_ids)
    end
  end
end
