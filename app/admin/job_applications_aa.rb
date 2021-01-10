if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('job_questions')
  ActiveAdmin.register JobApplication do
    menu label: 'Job Applications'

    permit_params :job_id, :user_id, :cover_letter, :template, :per_hour_bid, :available_during_work_hours,
                  :state, :work_samples, :applied_at
    includes :job, :user

    filter :job_short_description, as: :string, label: 'Job description'
    filter :user_email, as: :string, label: 'Freelancer email'
    filter :job_user_email, as: :string, label: 'Employer email'
    filter :state, as: :select, collection: JobApplication.states


    index do
      column 'Job Title' do |job_application|
        "#{job_application.job.title} by #{job_application.job.user.email}"
      end
      column 'User' do |job_application|
        link_to(job_application.user.email, admin_user_path(job_application.user_id))
      end
      column :state
      column :template
      column :per_hour_bid
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
        row 'Employer email' do
          link_to(application.job.user.email, admin_user_path(application.job.user_id))
        end
        row 'Freelancer email' do
          link_to(application.user.email, admin_user_path(application.job.user_id))
        end
        row 'Cover Letter' do
          application.cover_letter.body.to_s
        end
        row :template
        row :per_hour_bid
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

    form do |f|
      f.inputs "Job Application" do
        f.input :job,
                as: :select,
                collection: Job.find_each.map{|j| ["#{j.title} - #{j.user.email}", j.id]}
        f.input :user,
                as: :select,
                collection: User.freelancer.order(:email).pluck(:email, :id)
        f.input :liked
        f.input :cover_letter, as: :text
        f.input :template
        f.input :per_hour_bid
        f.input :available_during_work_hours
        f.inputs "Work Samples" do
          f.input :work_samples, as: :file, required: false
        end
        f.input :state
        f.input :applied_at
        f.actions
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

