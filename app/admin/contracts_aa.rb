if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('contracts')
  ActiveAdmin.register Contract do
    menu label: 'Contracts'
    includes :employer_profile, :freelancer_profile, :job

    permit_params :freelancer_profile_id, :employer_profile_id, :job_id, :title, :short_description, :contract_type, :pay_rate, :state
    actions :all

    index do
      id_column
      column :employer_profile
      column :freelancer_profile
      column :job
      column :title
      column :short_description
      column :contract_type
      column :pay_rate
      column :state
      column :created_at

      actions defaults: true
    end

    filter :employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :freelancer_profile_user_email, as: :string, label: 'Freelancer Email'
    filter :contract_type, as: :select, collection: Contract.contract_types
    filter :state, as: :select, collection: Contract.states

    show title: 'Contract' do |contract|
      attributes_table do
        row :employer_profile
        row :freelancer_profile
        row :job
        row :title
        row :short_description
        row :contract_type
        row :pay_rate
        row :state
        row :created_at
        row :updated_at

      end
      active_admin_comments
    end


    form do |f|
      f.inputs "Contract" do
        f.input :employer_profile_id,
                as: :select, input_html: { class: 'select2' },
                collection: EmployerProfile.find_each.map{ |employer_profile| [employer_profile.email, employer_profile.id] },
                label: 'Employer'
        f.input :freelancer_profile_id,
                as: :select, input_html: { class: 'select2' },
                collection: FreelancerProfile.find_each.map{ |freelancer_profile| [freelancer_profile.email, freelancer_profile.id] },
                label: 'Freelancer'
        f.input :job_id,
                as: :select, input_html: { class: 'select2' },
                collection: Job.find_each.map{ |job| ["#{job.title} by #{job.user.email}", job.id] },
                label: "Job (#{link_to('Create new', new_admin_job_path, target: '_blank')})".html_safe
        f.input :title
        f.input :short_description, as: :text
        f.input :contract_type
        f.input :pay_rate
        f.input :state
        f.actions
      end
    end
  end
end
