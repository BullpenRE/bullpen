if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('employer_profiles')
  ActiveAdmin.register EmployerProfile do
    menu label: 'Employers'

    includes :user

    filter :user_email, as: :string, label: 'User Email'

    permit_params :user_id, :company_name, :company_website, :role_in_company, :employee_count, :category,
                  :motivation_one_time, :motivation_ongoing_support, :motivation_backfill, :motivation_augment,
                  :motivation_other


    index do
      column :user
      column :company_name
      column :role_in_company
      column :employee_count
      column :category

      actions
    end

    show title: 'Employer Profile' do |employer_profile|
      attributes_table do
        row 'Email' do
          employer_profile.user.email
        end
        row :created_at
        row :updated_at
        row :company_name
        row 'Company Website' do
          link_to(employer_profile.company_website, "#{employer_profile.company_website[0..3] == 'http' ? '' : 'http://'}#{employer_profile.company_website}", target: '_blank').html_safe
        end
        row :role_in_company
        row :employee_count
        row :category
        row :motivation_one_time
        row :motivation_ongoing_support
        row :motivation_backfill
        row :motivation_augment
        row :motivation_other
        row "ALL Interview Requests Sent to Freelancers", :interview_requests do
          employer_profile.interview_requests
        end
      end
    end

    form do |f|
      f.inputs "#{f.object&.user&.email || 'New'} Employer Profile" do

        if f.object.new_record?
          f.input :user,
                  as: :select,
                  collection: User.no_employer_data.order(:email).pluck(:email, :id),
                  label: "User (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
        end
        f.input :company_name
        f.input :company_website
        f.input :role_in_company
        f.input :employee_count
        f.input :category
        f.inputs 'Motivations' do
          f.input :motivation_one_time, label: 'One Time'
          f.input :motivation_ongoing_support, label: 'Ongoing Support'
          f.input :motivation_backfill, label: 'Backfill'
          f.input :motivation_augment, label: 'Augment'
          f.input :motivation_other, label: 'Other'
        end
        f.actions
      end
    end

    controller do
      def create
        error_message = nil
        employer_profile = EmployerProfile.new(permitted_params[:employer_profile])

        ApplicationRecord.transaction do
          employer_profile.save!
        rescue StandardError => e
          error_message = e.message
        end
        message = { alert: error_message } if error_message
        message ||= { notice: 'Successfully created!' }

        redirect_to admin_employer_profile_path(employer_profile), flash: message
      end
    end
  end
end
