if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('job_questions')
  ActiveAdmin.register JobApplication do
    menu label: 'Job Applications'

    permit_params :job_id, :freelancer_profile_id, :cover_letter, :template, :bid_amount, :available_during_work_hours,
                  :state, :work_sample, :liked, :applied_at, work_samples: []
    includes :job, :user

    filter :job_short_description, as: :string, label: 'Job description'
    filter :freelancer_profile_user_email, as: :string, label: 'Freelancer email'
    filter :job_user_email, as: :string, label: 'Employer email'
    filter :state, as: :select, collection: JobApplication.states


    index do
      column 'Job Title' do |job_application|
        "#{job_application.job.title} by #{job_application.job.employer_profile.email}"
      end
      column 'Freelancer' do |job_application|
        link_to(job_application.freelancer_profile.email, admin_user_path(job_application.freelancer_profile.user_id))
      end
      column :state
      column :template
      column :bid_amount
      column :liked
      column :available_during_work_hours
      column :created_at
      column :applied_at
      actions
    end

    show title: 'Job Applications' do |application|
      attributes_table do
        row 'Job' do
          link_to(application.job.title, admin_job_path(application.job_id))
        end
        row 'Employer' do
          link_to(application.job.employer_profile.email, admin_user_path(application.job.employer_profile.user_id))
        end
        row 'Freelancer' do
          link_to(application.freelancer_profile.email, admin_user_path(application.freelancer_profile.user_id))
        end
        row 'Cover Letter' do
          application.cover_letter.body.to_s
        end
        row :template
        row :bid_amount
        row :available_during_work_hours
        row :state
        row :liked
        row :work_samples do |jap|
          if jap.work_samples.attached?
            jap.work_samples.each do |work_sample|
              columns do
                column do
                  if work_sample.previewable?
                    image_tag work_sample.preview(resize: '400x400')
                  else
                    link_to work_sample.filename, rails_blob_path(work_sample, disposition: :attachment)
                  end
                end
                column do
                  button_to 'Delete work sample',
                            destroy_work_sample_admin_job_application_path(
                              id: job_application.id,
                              destroy_work_sample_id: work_sample.signed_id
                            ),
                            action: :post,
                            data: { confirm: 'Are you sure?' }
                end
              end
            end
            nil
          end
        end
        row :applied_at
        row :created_at

        if application.job.job_questions.present?
          row 'Question Answers' do
            application.job
                       .job_questions
                       .map do |job_question|
                          link_to("#{job_question.description}",
                                  job_question.job_application_questions.find_by(job_application_id: application.id).present? ? admin_job_application_question_path(job_question.job_application_questions.find_by(job_application_id: application.id).id) : new_admin_job_application_question_path(:job_application_question => { :job_application_id => application.id, :job_question_id => job_question.id })
                          )
                        end.join('<br><br>').html_safe
          end
        end
      end
    end

    form html: { multipart: true } do |f|
      f.inputs 'Job Application' do
        f.input :job,
                as: :select, input_html: { class: 'select2' },
                collection: Job.find_each.map { |j| ["#{j.title} - #{j.employer_profile.email} (#{j.contract_type || 'contract type missing'})", j.id] }
        f.input :freelancer_profile,
                as: :select, input_html: { class: "select2" },
                collection: FreelancerProfile.all.map{ |profile| [profile.email, profile.id] }
        f.input :liked
        f.input :cover_letter, as: :text
        f.input :template
        f.input :bid_amount
        f.input :available_during_work_hours
        f.inputs do
          f.input :work_samples, as: :file, required: false, input_html: { multiple: true }
        end
        f.input :state
        f.input :applied_at
        f.actions
      end
    end

    controller do
      def create
        error_message = nil
        job_application = JobApplication.new(permitted_params[:job_application])
        job_application.user_id = FreelancerProfile.find_by(id: permitted_params[:job_application][:freelancer_profile_id]).user_id
        job_application.applied_at = Time.current if permitted_params[:job_application][:applied_at].blank?

        ApplicationRecord.transaction do
          job_application.save!
        rescue StandardError => e
          error_message = e.message
        end

        message = { alert: error_message } if error_message
        message ||= { notice: 'Successfully created!' }

        redirect_to admin_job_application_path(job_application.id), flash: message
      end

      def update
        super do |success, failure|
          success.html { render action: :view }
          failure.html { render action: :edit }
        end
      end
    end

    member_action :destroy_work_sample, method: :post do
      blob = ActiveStorage::Blob.find_signed(params[:destroy_work_sample_id])
      job_application = JobApplication.find(params[:id])
      blob.attachments[0].purge_later
      redirect_to admin_job_application_path(job_application.id), { notice: 'Work Sample deleted.' }
    end
  end
end

