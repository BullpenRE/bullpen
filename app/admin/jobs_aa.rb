if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('jobs')
  ActiveAdmin.register Job do
    menu label: 'Jobs'

    includes :employer_profile, :job_sectors, :job_skills, :job_softwares, :job_questions

    filter :employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :state, as: :select, collection: -> { Job.states }

    permit_params :employer_profile_id,
                  :title,
                  :short_description,
                  :position_length,
                  :hours_needed,
                  :time_zone,
                  :daytime_availability_required,
                  :required_experience,
                  :required_regional_knowledge,
                  :relevant_details,
                  :draft,
                  :contract_type,
                  :pay_range_low,
                  :pay_range_high,
                  :job_announced

    index do
      column :employer_profile
      column :title
      column :short_description
      column :state
      actions
    end

    show title: 'Job' do |job|
      attributes_table do
        row :employer_profile
        row :created_at
        row :updated_at
        row :title
        row :short_description
        row :position_length
        row :hours_needed
        row :time_zone
        row :daytime_availability_required
        row :required_experience
        row :job_announced
        row 'Relevant Details' do
          job.relevant_details.body.to_s
        end
        row :state
        row :contract_type
        row :pay_range_low
        row :pay_range_high
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
          job.job_questions.map { |job_question| link_to(job_question.description, admin_job_question_path(job_question.id)) }.push(link_to('Add', new_admin_job_question_path(:job_question => { :job_id => job.id }))).join('<br>').html_safe
        end
        row 'Job Applications' do
          job.job_applications.map { |job_application| link_to("#{job_application.freelancer_profile.email}: #{job_application.created_at.strftime("%m-%d-%Y")}", admin_job_application_path(job_application.id)) }.push(link_to('Add', new_admin_job_application_path(:job_application=> { :job_id => job.id }))).join('<br>').html_safe
        end
        row 'Contracts' do
          job.contracts.map { |contract| link_to("#{contract.employer_profile.email} hiring #{contract.freelancer_profile.email} for $#{contract.pay_rate} #{contract.contract_type}", admin_contract_path(contract.id)) }.push(link_to('Add', new_admin_contract_path(:contract=> { :job_id => job.id }))).join('<br>').html_safe
        end
      end

      active_admin_comments
    end

    form do |f|
      f.inputs "#{f.object&.employer_profile&.email || 'New'} Job" do

        if f.object.new_record?
          f.input :employer_profile,
                  as: :select, input_html: { class: "select2" },
                  collection: EmployerProfile.all.map{ |profile| [profile.email, profile.id] },
                  label: 'Employer'
        end
        f.input :title
        f.input :short_description
        f.input :position_length
        f.input :hours_needed
        f.input :time_zone, as: :select, collection: Job.time_zones.keys
        f.input :state
        f.input :daytime_availability_required
        f.input :required_experience
        f.input :relevant_details, as: :text
        f.input :contract_type
        f.input :pay_range_low
        f.input :pay_range_high
        f.input :job_announced
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
