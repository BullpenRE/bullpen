if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('job_questions')
  ActiveAdmin.register JobApplication do
    menu label: 'Job Applications'

    permit_params :job_id, :user_id, :cover_letter, :template, :bid_amount, :available_during_work_hours,
                  :state, :work_sample, :applied_at
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
        row :bid_amount
        row :available_during_work_hours
        row :state
        row :liked
        row :work_sample do |jap|
          if jap.work_sample.attached?
            if jap.work_sample.previewable?
              image_tag jap.work_sample.preview(resize: "400x400")
            elsif jap.work_sample.variable?
              image_tag jap.work_sample.variant(resize: "400x400")
            else
              link_to jap.work_sample.filename, rails_blob_path(jap.work_sample, disposition: :attachment)
            end
          end
        end
        row ' ' do |job_application|
          if job_application.work_sample.attached?
            button_to 'Delete work sample',
                      "/admin/job_applications/#{job_application.id}/destroy_work_sample",
                      action: :post,
                      data: { confirm: 'Are you sure?' }
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
        f.input :bid_amount
        f.input :available_during_work_hours
        f.inputs "Work Sample" do
          f.input :work_sample, as: :file, required: false
        end
        f.input :state
        f.input :applied_at
        f.actions
      end
    end

    member_action :destroy_work_sample, method: :post do
      job_application = JobApplication.find(params[:id])
      job_application.work_sample.purge_later
      redirect_to admin_job_application_path(job_application.id), { notice: 'Work Sample deleted.' }
    end

  end
end

