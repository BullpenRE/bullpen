if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('freelancer_profiles')
  ActiveAdmin.register FreelancerProfile do
    menu label: 'Freelancers'

    includes :user, :freelancer_sectors, :freelancer_real_estate_skills, :freelancer_profile_educations, :freelancer_profile_experiences, :freelancer_softwares

    filter :user_email, as: :string, label: 'User Email'
    filter :draft
    filter :curation, as: :select, collection: FreelancerProfile::curations.keys

    permit_params :user_id,
                  :professional_summary,
                  :professional_title,
                  :professional_years_experience,
                  :curation,
                  :draft,
                  :new_jobs_alert,
                  :searchable,
                  :desired_hourly_rate

    index do
      column :user
      column 'Title', :professional_title
      column 'Years Experience', :professional_years_experience
      column :draft
      column :curation
      actions
    end

    show title: 'Freelancer Profile' do |freelancer_profile|
      attributes_table do
        row 'User' do
          link_to freelancer_profile.user.email, admin_user_path(freelancer_profile.user_id)
        end
        row :created_at
        row :updated_at
        row :professional_title
        row :professional_years_experience
        row :professional_summary
        row 'Sectors' do
          freelancer_profile.sectors.pluck(:description)
        end
        row 'Real Estate Skills' do
          freelancer_profile.real_estate_skills.pluck(:description)
        end
        row 'Software Licenses' do
          freelancer_profile.softwares.pluck(:description)
        end
        row 'Education' do
          freelancer_profile.freelancer_profile_educations.map{|f_e| "#{'<i>(current)</i> ' if f_e.currently_studying}#{f_e.graduation_year} #{f_e.degree} in #{f_e.course_of_study} at #{f_e.institution}" }.push(link_to('Add/Edit/Remove', admin_freelancer_profile_educations_path(q: {freelancer_profile_id_eq: params[:id]}), target: '_blank')).join('<br>').html_safe
        end
        row 'Experience' do
          freelancer_profile.freelancer_profile_experiences.map{|f_e| "#{'<i>(current)</i> ' if f_e.current_job}#{f_e.start_date.year}#{"-#{f_e.end_date.year}" if f_e.end_date && f_e.end_date.year != f_e.start_date.year} #{f_e.job_title} at #{f_e.company}" }.push(link_to('Add/Edit/Remove', admin_freelancer_profile_experiences_path(q: {freelancer_profile_id_eq: params[:id]}), target: '_blank')).join('<br>').html_safe
        end
        row 'Certifications' do
          freelancer_profile.freelancer_certifications.order(:earned).map{|f_c| "#{f_c.earned.year}: #{f_c.description}" }.push(link_to('Add/Edit/Remove', admin_freelancer_certifications_path(q: {freelancer_profile_id_eq: params[:id]}), target: '_blank')).join('<br>').html_safe
        end
        row :draft
        row :new_jobs_alert
        row :searchable
        row :curation
        row :desired_hourly_rate
        row "ALL Interview Requests Received From Employers", :interview_requests do
          freelancer_profile.interview_requests.map{ |i_r| link_to(i_r.employer_profile.email, admin_interview_request_path(i_r.id)) }
        end
      end

      active_admin_comments

      if !freelancer_profile.draft? && freelancer_profile.pending?
        columns do
          column do
            button_to 'Accept',
                      "/admin/freelancer_profiles/#{freelancer_profile.id}/accept",
                      action: :post,
                      data: { confirm: 'Are you sure?' }
          end
          column do
            button_to 'Decline',
                      "/admin/freelancer_profiles/#{freelancer_profile.id}/decline",
                      action: :post,
                      data: { confirm: 'Are you sure?' }
          end
        end
      end
    end

    form do |f|
      f.inputs "#{f.object&.user&.email || 'New'} Freelancer Profile" do

        if f.object.new_record?
          f.input :user,
                  as: :select, input_html: { class: "select2" },
                  collection: User.no_freelancer_data.order(:email).pluck(:email, :id),
                  label: "User (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
        end
        f.input :professional_title
        f.input :professional_years_experience
        f.input :professional_summary
        f.input :sectors, as: :check_boxes, collection: Sector.order(:description).pluck(:description, :id)
        f.input :real_estate_skills, as: :check_boxes, collection: RealEstateSkill.order(:description).pluck(:description, :id)
        f.input :softwares, as: :check_boxes, collection: Software.order(:description).pluck(:description, :id)
        f.input :draft
        f.input :new_jobs_alert
        f.input :searchable
        f.input :curation
        f.input :desired_hourly_rate
        f.actions
      end
    end

    member_action :accept, method: :post do
      freelancer_profile = FreelancerProfile.find(params[:id])
      freelancer_profile.update(curation: 'accepted')
      FreelancerMailer.freelancer_approved(freelancer_profile.user).deliver_now
      redirect_to admin_freelancer_profile_path(freelancer_profile.id), { notice: 'Application Accepted.' }
    end

    member_action :decline, method: :post do
      freelancer_profile = FreelancerProfile.find(params[:id])
      freelancer_profile.update(curation: 'declined')
      FreelancerMailer.freelancer_rejected(freelancer_profile.user).deliver_now
      redirect_to admin_freelancer_profile_path(freelancer_profile.id), { notice: 'Application Declined.' }
    end

    controller do
      def create
        error_message = nil
        freelancer_profile = FreelancerProfile.new(permitted_params[:freelancer_profile])

        ApplicationRecord.transaction do
          freelancer_profile.save!
          update_many_to_many_attributes(freelancer_profile)
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
        update_many_to_many_attributes(freelancer_profile)

        if send_accept_or_reject_freelancer_email?
          accepted? ? FreelancerMailer.freelancer_approved(freelancer_profile.user).deliver_now : FreelancerMailer.freelancer_rejected(freelancer_profile.user).deliver_now
        end

        ApplicationRecord.transaction do
          freelancer_profile.update!(permitted_params[:freelancer_profile])
        rescue StandardError => e
          error_message = e.message
        end

        message = { alert: error_message } if error_message
        message ||= { notice: 'Successfully updated!' }

        redirect_to admin_freelancer_profile_path(freelancer_profile), flash: message
      end

      def update_many_to_many_attributes(freelancer_profile)
        freelancer_profile.freelancer_sectors.destroy_all
        freelancer_profile.freelancer_real_estate_skills.destroy_all
        freelancer_profile.freelancer_softwares.destroy_all
        freelancer_profile.reload

        params[:freelancer_profile][:sector_ids].reject(&:empty?).each do |sector_id|
          freelancer_profile.freelancer_sectors.create(sector_id: sector_id.to_i)
        end
        params[:freelancer_profile][:real_estate_skill_ids].reject(&:empty?).each do |real_estate_skill_id|
          freelancer_profile.freelancer_real_estate_skills.create(real_estate_skill_id: real_estate_skill_id)
        end
        params[:freelancer_profile][:software_ids].reject(&:empty?).each do |software_id|
          freelancer_profile.freelancer_softwares.create(software_id: software_id)
        end
        params[:freelancer_profile].delete(:sector_ids)
        params[:freelancer_profile].delete(:real_estate_skill_ids)
        params[:freelancer_profile].delete(:software_ids)
      end

      def send_accept_or_reject_freelancer_email?
        FreelancerProfile.find(params[:id]).curation != permitted_params[:freelancer_profile][:curation]
      end

      def accepted?
        permitted_params[:freelancer_profile][:curation] == 'accepted'
      end

    end
  end
end
