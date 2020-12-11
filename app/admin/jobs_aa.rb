if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('jobs')
  ActiveAdmin.register Job do
    menu label: 'Jobs'

    includes :user, :job_sectors, :job_skills, :job_softwares, :job_questions

    filter :user_email, as: :string, label: 'User Email'
    filter :state

    permit_params :user_id,
                  :title,
                  :short_description,
                  :position_length,
                  :hours_needed,
                  :time_zone,
                  :daytime_availability_required,
                  :required_experience,
                  :required_regional_knowledge,
                  :relevant_job_details,
                  :draft

    index do
      column :user
      column :title
      column :short_description
      column :draft
      actions
    end

    show title: 'Job' do |job|
      attributes_table do
        row 'Email' do
          job.user.email
        end
        row :created_at
        row :updated_at
        row :title
        row :short_description
        row :position_length
        row :hours_needed
        row :time_zone
        row :daytime_availability_required
        row :required_experience
        row :relevant_job_details
        row :state
        row 'Sectors' do
          job.sectors.pluck(:description)
        end
        row 'Skills' do
          job.skills.pluck(:description)
        end
        row 'Software' do
          job.softwares.pluck(:description)
        end
        row 'Questions' do
          job.job_questions.map(&:description).push(link_to('Add', new_admin_job_question_path(:job_question => { :job_id => job.id }))).join('<br>').html_safe
        end
        row 'Job Applications' do
           User.where(id: job.job_applications.map(&:user_id)).map{|user| "#{user.email} on #{user.created_at.strftime("%m-%Y")}" }.push(link_to('Add', new_admin_job_application_path(:job_application=> { :job_id => job.id }))).join('<br>').html_safe
        end
      end

      active_admin_comments
    end

    form do |f|
      f.inputs "#{f.object&.user&.email || 'New'} Job" do

        if f.object.new_record?
          f.input :user,
                  as: :select,
                  collection: User.employers.order(:email).pluck(:email, :id),
                  label: "User (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
        end
        f.input :title
        f.input :short_description
        f.input :position_length
        f.input :time_zone, as: :select, collection: Job.time_zones.keys
        f.input :state
        f.input :daytime_availability_required
        f.input :required_experience
        f.input :relevant_job_details
        f.input :skills, as: :check_boxes, collection: Skill.order(:description).pluck(:description, :id)
        f.input :sectors, as: :check_boxes, collection: Sector.order(:description).pluck(:description, :id)
        f.input :softwares, as: :check_boxes, collection: Software.order(:description).pluck(:description, :id)
        f.actions
      end
    end

    controller do
      def create
        error_message = nil
        job = Job.new(permitted_params[:job])

        ApplicationRecord.transaction do
          job.save!
          update_sectors_skills_and_software(job)
        rescue StandardError => e
          error_message = e.message
        end
        message = { alert: error_message } if error_message
        message ||= { notice: 'Successfully created!' }

        redirect_to admin_job_path(job.id), flash: message
      end

      def update
        error_message = nil

        job = Job.find(params[:id])
        update_sectors_skills_and_software(job)

        ApplicationRecord.transaction do
          job.update!(permitted_params[:job])
        rescue StandardError => e
          error_message = e.message
        end

        message = { alert: error_message } if error_message
        message ||= { notice: 'Successfully updated!' }

        redirect_to admin_job_path(job.id), flash: message
      end

      def update_sectors_skills_and_software(job)
        job.job_sectors.destroy_all
        job.job_skills.destroy_all
        job.job_softwares.destroy_all
        job.reload

        params[:job][:sector_ids].reject(&:empty?).each do |sector_id|
          job.job_sectors.create(sector_id: sector_id.to_i)
        end
        params[:job][:skill_ids].reject(&:empty?).each do |skill_id|
          job.job_skills.create(skill_id: skill_id)
        end
        params[:job][:software_ids].reject(&:empty?).each do |software_id|
          job.job_softwares.create(software_id: software_id)
        end

        params[:job].delete(:sector_ids)
        params[:job].delete(:skill_ids)
        params[:job].delete(:software_ids)
      end
    end
  end
end
