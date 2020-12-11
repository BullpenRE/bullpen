if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('job_questions')
  ActiveAdmin.register JobApplication do
    menu label: 'Job Applications'

    permit_params :job_id, :user_id, :cover_letter, :template, :per_hour_bid, :available_during_work_hours,
                  :state, :work_sample
    includes :job, :user

    filter :job_short_description, as: :string, label: 'Job description'
    filter :user_email, as: :string, label: 'Freelancer email'
    filter :job_user_email, as: :string, label: 'Employer email'
    filter :state, as: :select, collection: JobApplication.states


    index do
      column :job
      column :user
      column :state
      column :template
      column :per_hour_bid
      column :available_during_work_hours
      column :created_at
      column :updated_at
      actions
    end

    show title: 'Job Applications' do |application|
      attributes_table do
        row 'Job' do
          link_to(application.job.short_description, admin_job_path(application.job_id))
        end
        row 'Employer email' do
          link_to(application.job.user.email, admin_user_path(application.job.user_id))
        end
        row 'Freelancer email' do
          link_to(application.user.email, admin_user_path(application.job.user_id))
        end
        row :cover_letter
        row :template
        row :per_hour_bid
        row :available_during_work_hours
        row :state
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
        row :created_at

        if application.job.job_questions.present?
          row 'Question Answers' do
            application.job.job_questions.map{|job_application_question| link_to("#{job_application_question.description}", admin_job_question_path(job_application_question.id)) }
                .push(link_to('Add', new_admin_job_question_path(:job_question => { :job_id => application.job.id }))).join('<br><br>').html_safe
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
        f.input :cover_letter
        f.input :template
        f.input :per_hour_bid
        f.input :available_during_work_hours
        f.inputs "Work Sample" do
          f.input :work_sample, as: :file, required: false
        end
        f.input :state
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

