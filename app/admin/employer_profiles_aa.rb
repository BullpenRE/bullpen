if SharedMethods.aa_and_table_exists?('employer_profiles')
  ActiveAdmin.register EmployerProfile do
    menu label: 'Employers'

    includes :user, :employer_sectors

    filter :user_email, as: :string, label: 'User Email'

    permit_params :user_id, :company_name, :company_website, :role_in_company, :employee_count, :category,
                  :motivation_one_time, :motivation_ongoing_support, :motivation_backfill, :motivation_augment,
                  :motivation_other, :credit_balance


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
        row 'User' do
          link_to(employer_profile.user.email, admin_user_path(employer_profile.user_id))
        end
        row :created_at
        row :updated_at
        row :company_name
        row 'Company Website' do
          if employer_profile.company_website
            link_to(employer_profile.company_website, "#{employer_profile.company_website[0..3] == 'http' ? '' : 'http://'}#{employer_profile.company_website}", target: '_blank').html_safe
          end
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
          (employer_profile.interview_requests.map{ |i_r| link_to(i_r.freelancer_profile.email, admin_interview_request_path(i_r.id)) }.join('<br>') + link_to('<br>Add New'.html_safe, new_admin_interview_request_path(interview_request: { employer_profile_id: employer_profile.id }), target: '_new')).html_safe
        end
        row 'Jobs' do
          (employer_profile.jobs.map { |job| link_to(job.title, admin_job_path(job.id)) }.join('<br>') + link_to('<br>Add New'.html_safe, new_admin_job_path(job: { employer_profile_id: employer_profile.id }), target: '_new')).html_safe
        end
        row 'Contracts' do
          (employer_profile.contracts.map { |contract| link_to("Hired #{contract.freelancer_profile.email} for $#{contract.pay_rate} #{contract.contract_type}", admin_contract_path(contract.id)) }.join('<br>') + link_to('<br>Add New'.html_safe, new_admin_contract_path(contract: { employer_profile_id: employer_profile.id }), target: '_new')).html_safe
        end
        row 'Reviews' do
          rating = employer_profile.reviews.any? ? "Has written #{employer_profile.reviews.size} review#{'s' if employer_profile.reviews.size != 1} for an average rating of #{(employer_profile.reviews.sum(:rating)/employer_profile.reviews.size.to_f).round(1)}" : ''
          rating.html_safe + link_to('<br>Add New'.html_safe, new_admin_review_path(review: { employer_profile_id: employer_profile.id }), target: '_new')
        end
        row 'Payment Accounts' do
          employer_profile.payment_accounts.map { |account| link_to("#{account.institution} #{account.last_four}#{' (expired)' if account.expired?}#{' (Default)' if account.is_default?}", admin_payment_account_path(account.id)).html_safe }.join('<br>').html_safe + link_to('<br>Add New'.html_safe, new_admin_payment_account_path(payment_account: { employer_profile_id: employer_profile.id }), target: '_new')
        end
        row :credit_balance
      end
    end

    form do |f|
      f.inputs "#{f.object&.user&.email || 'New'} Employer Profile" do

        if f.object.new_record?
          f.input :user,
                  as: :select, input_html: { class: "select2" },
                  collection: User.no_employer_data.order(:email).pluck(:email, :id),
                  label: "User (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
        end
        f.input :company_name
        f.input :company_website
        f.input :role_in_company
        f.input :employee_count
        f.input :category
        f.input :sectors, as: :check_boxes, collection: Sector.order(:description).pluck(:description, :id)
        f.inputs 'Motivations' do
          f.input :motivation_one_time, label: 'One Time'
          f.input :motivation_ongoing_support, label: 'Ongoing Support'
          f.input :motivation_backfill, label: 'Backfill'
          f.input :motivation_augment, label: 'Augment'
          f.input :motivation_other, label: 'Other'
        end
        f.input :credit_balance
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
