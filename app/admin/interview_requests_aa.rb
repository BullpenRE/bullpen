if SharedMethods.aa_and_table_exists?('interview_requests')
  ActiveAdmin.register InterviewRequest do
    menu label: 'Interview Requests'
    includes :employer_profile, :freelancer_profile

    permit_params :employer_profile_id, :freelancer_profile_id, :state, :message, :hide_from_freelancer,
                  :hide_from_employer
    actions :all

    index do
      id_column
      column 'Employer' do |interview_request|
        link_to interview_request.employer_profile.email, admin_employer_profile_path(interview_request.employer_profile_id)
      end
      column 'Freelancer' do |interview_request|
        link_to interview_request.freelancer_profile.email, admin_freelancer_profile_path(interview_request.freelancer_profile_id)
      end
      column :state
      column :created_at

      actions defaults: true
    end

    filter :employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :freelancer_profile_user_email, as: :string, label: 'Freelancer Email'

    show title: 'Interview Requested' do |interview_request|
      attributes_table do
        row 'Employer' do
          link_to interview_request.employer_profile.email, admin_employer_profile_path(interview_request.employer_profile_id)
        end
        row 'Freelancer' do
          link_to interview_request.freelancer_profile.email, admin_freelancer_profile_path(interview_request.freelancer_profile_id)
        end
        row :created_at
        row :updated_at
        row :state
        row 'Message' do
          interview_request.message.body.to_s
        end
        row :hide_from_freelancer
        row :hide_from_employer
      end
      active_admin_comments
    end

    form do |f|
      f.inputs 'Interview Requests' do
        if f.object.new_record?
          f.input :employer_profile_id,
                  as: :select, input_html: { class: "select2" },
                  collection: EmployerProfile.users.order(:id).pluck(:email, :id),
                  label: "Employer (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
          f.input :freelancer_profile_id,
                  as: :select, input_html: { class: "select2" },
                  collection: FreelancerProfile.users.order(:id).pluck(:email, :id),
                  label: "Freelancer (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
        end
        f.input :state, as: :select
        f.input :message, as: :text
        f.input :hide_from_freelancer
        f.input :hide_from_employer
        f.actions
      end
    end
  end
end
