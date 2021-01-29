if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('contracts')
  ActiveAdmin.register Contract do
    menu label: 'Contracts'
    includes :from_user, :to_user, :job

    permit_params :from_user_id, :to_user_id, :job_id, :title, :short_description, :contract_type, :pay_rate, :state
    actions :all

    index do
      id_column
      column 'Employer' do |contract|
        link_to contract.from_user.email, admin_user_path(contract.from_user_id)
      end
      column 'Contractor' do |contract|
        link_to contract.to_user.email, admin_user_path(contract.to_user_id)
      end
      column :job
      column :title
      column :short_description
      column :contract_type
      column :pay_rate
      column :state
      column :created_at

      actions defaults: true
    end

    filter :from_user_email, as: :string, label: 'Employer Email'
    filter :to_user_email, as: :string, label: 'Contractor Email'
    filter :contract_type
    filter :state

    show title: 'Contract' do |contract|
      attributes_table do
        row 'Employer' do
          link_to contract.from_user.email, admin_user_path(contract.from_user_id)
        end
        row 'Contractor' do
          link_to contract.to_user.email, admin_user_path(contract.to_user_id)
        end
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
        f.input :from_user_id,
                as: :select, input_html: { class: 'select2' },
                collection: User.pluck(:email, :id),
                label: "Employer (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
        f.input :to_user_id,
                as: :select, input_html: { class: 'select2' },
                collection: User.pluck(:email, :id),
                label: "Contractor (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
        f.input :job_id,
                as: :select, input_html: { class: 'select2' },
                collection: Job.find_each.map{ |job| ["#{job.title} by #{job.user.email}", job.id] },
                label: "Job (#{link_to('Create new', new_admin_job_path, target: '_blank')})".html_safe
        f.input :title
        f.input :short_description
        f.input :contract_type
        f.input :pay_rate
        f.input :state
        f.actions
      end
    end
  end
end
