ActiveAdmin.register FreelancerProfileEducation do
  menu false

  permit_params :freelancer_profile_id, :institution, :degree, :course_of_study, :graduation_year, :currently_studying, :description

  filter :freelancer_profile,
         as: :select,
         label: 'User Email',
         collection: FreelancerProfile.find_each.map {|fp| [fp.user.email, fp.id] }


  index do
    column :user, label: 'User Email'
    column :institution
    column :degree
    column :course_of_study
    column :graduation_year
    column :currently_studying
    actions
  end

  form do |f|
    f.inputs "Education for #{}" do
      f.input :freelancer_profile,
              as: :select,
              collection: FreelancerProfile.find_each.map{|fp| [fp.user.email, fp.id] }
      f.input :institution
      f.input :degree
      f.input :course_of_study
      f.input :graduation_year
      f.input :currently_studying
      f.input :description
      f.actions
    end
  end
end if defined?(ActiveAdmin)

