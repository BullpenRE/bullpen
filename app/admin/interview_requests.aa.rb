if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('interview_requests')
  ActiveAdmin.register InterviewRequest do
    menu label: 'Interview Requests'
    includes :employer_profile, :freelancer_profile

    permit_params :employer_profile_id, :freelancer_profile_id, :state
    actions :all

    index do
      id_column
      column 'Employer Email', :employer_profile
      column 'Freelancer Email', :freelancer_profile
      column :state
      column :created_at
      column :updated_at

      actions defaults: true
    end

    filter :employer_profile,
           as: :select,
           label: 'Employer Email',
           collection: EmployerProfile.find_each.map {|ep| [ep.user.email, ep.id] }

    filter :freelancer_profile,
           as: :select,
           label: 'Freelancer Email',
           collection: FreelancerProfile.find_each.map {|fp| [fp.user.email, fp.id] }

    show title: 'Interview Requested' do
      attributes_table do
        row :employer_profile
        row :freelancer_profile
        row :created_at
        row :updated_at
        row :state
      end
      active_admin_comments
    end


    form do |f|
        f.inputs "Interview Requests" do

          if f.object.new_record?
            f.input :employer_profile_id,
                    as: :select,
                    collection: User.employers.order(:id).pluck(:email, :id),
                    label: "Employer (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
            f.input :freelancer_profile_id,
                    as: :select,
                    collection: User.freelancers.order(:id).pluck(:email, :id),
                    label: "Freelancer (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
          end
          f.input :state, as: :select
      f.actions
      end
    end
  end
end