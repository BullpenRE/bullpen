if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('timesheets')
  ActiveAdmin.register Timesheet do
    permit_params :contract_id, :description, :starts, :ends
    actions :all

    index do
      id_column
      column :contract
      column :description
      column :starts
      column :ends

      actions defaults: true
    end

    filter :contract_employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :contract_freelancer_profile_user_email, as: :string, label: 'Freelancer Email'
    filter :contract_title, as: :string, label: 'Contract Title'

    show title: 'Timesheet' do |timesheet|
      attributes_table do
        row :contract
        row :description
        row :starts
        row :ends
        row :created_at
        row :updated_at
        row 'Billing Entries' do
          (timesheet.billings.order(work_done: :desc).map{|billing| link_to("#{billing.description} done on #{billing.work_done}", admin_billing_path(billing.id))}.join('<br>') + link_to('<br>Add New'.html_safe, new_admin_billing_path(:billing=> { :contract_id => timesheet.contract_id, :timesheet_id => timesheet.id }), target: '_new')).html_safe
        end

      end
      active_admin_comments
    end


    form do |f|
      f.inputs 'Timesheet Entry' do
        f.input :contract_id,
                as: :select, input_html: { class: 'select2' },
                collection: Contract.find_each.map {|contract| ["#{contract.title(true)} from #{contract.employer_profile.email}", contract.id]},
                label: 'Contract'

        f.input :description
        f.input :starts
        f.input :ends
        f.actions
      end
    end
  end
end
