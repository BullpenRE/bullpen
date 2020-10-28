ActiveAdmin.register JobQuestion do
  menu false

  permit_params :job_id, :description
  includes :job

  filter :job_id,
         as: :select,
         label: 'Job',
         collection: Job.find_each.map {|job| ["#{job.title} - #{job.user.email}", job.id] }


  index do
    column :job
    column 'User' do |question|
      link_to(question.job.user.email, admin_user_path(question.job.user_id))
    end
    column :description
    actions
  end

  show title: 'Job Questions' do |question|
    attributes_table do
      row 'Job' do
        link_to(question.job.title, admin_job_path(question.job_id))
      end
      row 'User' do
        link_to(job_question.job.user.email, admin_user_path(job_question.job.user_id))
      end
      row :description
      row :created_at
    end
  end

  form do |f|
    f.inputs "Job Question" do
      f.input :job,
              as: :select,
              collection: Job.find_each.map{|j| ["#{j.title} - #{j.user.email}", j.id]}
      f.input :description
      f.actions
    end
  end
end if defined?(ActiveAdmin)

