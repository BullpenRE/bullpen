if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('contracts')
  ActiveAdmin.register Contract do
    menu label: 'Contracts'
    includes :employer_profile, :freelancer_profile, :job

    permit_params :freelancer_profile_id, :employer_profile_id, :job_id, :title, :job_description, :contract_type,
                  :pay_rate, :state, :hide_from_freelancer, :hide_from_employer, :payment_account_id
    actions :all

    index do
      id_column
      column :employer_profile
      column :freelancer_profile
      column :job
      column :title
      column :contract_type
      column :pay_rate
      column :state
      column :payment_account
      column :created_at

      actions defaults: true
    end

    filter :employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :freelancer_profile_user_email, as: :string, label: 'Freelancer Email'
    filter :contract_type, as: :select, collection: -> { Contract.contract_types }
    filter :state, as: :select, collection: -> { Contract.states }

    show title: 'Contract' do |contract|
      attributes_table do
        row :employer_profile
        row :freelancer_profile
        row :job
        row :title
        row 'Job Description' do
          contract.job_description.body.to_s
        end
        row :contract_type
        row :pay_rate
        row :state
        row 'Payment account' do
          link_to contract.payment_account.short_description, admin_payment_account_path(contract.payment_account_id) if contract.payment_account.present?
        end
        row :created_at
        row :updated_at
        row :hide_from_freelancer
        row :hide_from_employer
        row 'Billing Entries' do
          (contract.billings.order(work_done: :desc).map { |billing| link_to("#{billing.description} (#{(billing.multiplier * 100).round / 100.0} hours on #{billing.work_done})", admin_billing_path(billing.id)) }.join('<br>') + link_to('<br>Add New'.html_safe, new_admin_billing_path(:billing=> { :contract_id => contract.id }), target: '_new')).html_safe
        end
      end
      active_admin_comments
    end


    form do |f|
      f.inputs "Contract" do
        f.input :employer_profile_id,
                as: :select, input_html: { class: 'select2' },
                collection: EmployerProfile.find_each.map {|employer_profile| [employer_profile.email, employer_profile.id]},
                label: 'Employer'
        f.input :freelancer_profile_id,
                as: :select, input_html: { class: 'select2' },
                collection: FreelancerProfile.find_each.map {|freelancer_profile| [freelancer_profile.email, freelancer_profile.id]},
                label: 'Freelancer'
        f.input :job_id,
                as: :select, input_html: { class: 'select2' },
                collection: Job.find_each.map{ |job| ["#{job.title} by #{job.employer_profile.email}", job.id] },
                label: "Job (#{link_to('Create new', new_admin_job_path, target: '_blank')})".html_safe
        f.input :title
        f.input :job_description, as: :text
        f.input :contract_type
        f.input :pay_rate
        f.input :state
        f.input :hide_from_freelancer
        f.input :hide_from_employer
        if f.object && f.object.employer_profile_id.present? && f.object.employer_profile.payment_accounts.any?
          f.input :payment_account, as: :select, collection: PaymentAccount.where(employer_profile_id: f.object.employer_profile_id).map{|account| [account.short_description, account.id] }
        end
        f.actions
      end
    end
  end
end
