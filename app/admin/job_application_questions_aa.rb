if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('job_questions')
  ActiveAdmin.register JobApplicationQuestion do
    menu false

    permit_params :job_application_id, :job_question_id, :answer
    includes :job_application, :job_question

    show title: 'Answer to Job Application' do |job_application_question|
      attributes_table do
        row 'Job' do
          link_to(job_application_question.job_question.job.title, admin_job_path(job_application_question.job_question.job_id))
        end
        row 'Application for' do
          link_to(job_application_question.job_application.freelancer_profile.email, admin_job_application_path(job_application_question.job_application_id))
        end
        row 'Question' do
          link_to(job_application_question.job_question.description, admin_job_question_path(job_application_question.job_question_id))
        end
        row :answer
      end
    end

    form do |f|
      f.inputs "Job Application Question" do
        f.input :job_application,
                as: :select,
                collection: JobApplication.find_each.map{|j| ["#{j.job.title} - #{j.user.email}", j.id]}
        f.input :job_question,
                as: :select,
                collection: JobQuestion.find_each.map{|j| ["#{j.description} - #{j.job.title}", j.id]}
        f.input :answer
        f.actions
      end
    end
  end
end
