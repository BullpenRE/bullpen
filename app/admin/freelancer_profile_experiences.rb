ActiveAdmin.register FreelancerProfileExperience do
  menu false

  permit_params :job_title, :company, :location, :start_date, :end_date, :current_job, :description, :freelancer_profile_id

  filter :freelancer_profile,
         as: :select,
         label: 'User Email',
         collection: FreelancerProfile.find_each.map {|fp| [fp.user.email, fp.id] }


  index do
    column :user, label: 'User Email'
    column :job_title
    column :company
    column :location
    column :start_date
    column :end_date
    column :current_job
    actions
  end

  form do |f|
    f.inputs "Education for #{}" do
      f.input :freelancer_profile,
              as: :select,
              collection: FreelancerProfile.find_each.map{|fp| [fp.user.email, fp.id] }
      f.input :job_title
      f.input :company
      f.input :location
      f.input :start_date, :discard_day => true, start_year: FreelancerProfileExperience::AVAILABLE_YEARS.min, end_year: FreelancerProfileExperience::AVAILABLE_YEARS.max
      f.input :end_date, :discard_day => true, start_year: FreelancerProfileExperience::AVAILABLE_YEARS.min, end_year: FreelancerProfileExperience::AVAILABLE_YEARS.max
      f.input :current_job
      f.input :description
      f.actions
    end
  end
end if defined?(ActiveAdmin)

