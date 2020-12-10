if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('job_questions')
  ActiveAdmin.register JobApplicationQuestion do
    menu false

    permit_params :job_application_id, :job_question_id, :answer
    includes :job_application, :job_question

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
