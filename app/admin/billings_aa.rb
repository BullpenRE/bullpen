if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('billings')
  ActiveAdmin.register Billing do
    menu label: 'Billing Entries'

    permit_params :contract_id, :work_done, :hours, :minutes, :description, :state,
                  :dispute_comments, :dispute_resolved, :timesheet_id
    actions :all

    index do
      id_column
      column :contract
      column 'Timesheet' do |billing|
        link_to(billing.timesheet.description || "#{billing.timesheet.starts} to #{billing.timesheet.ends}", admin_timesheet_path(billing.timesheet_id)) if billing.timesheet.present?
      end
      column :hours
      column :minutes
      column :work_done
      column :description
      column :state

      actions defaults: true
    end

    filter :contract_employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :contract_freelancer_profile_user_email, as: :string, label: 'Freelancer Email'
    filter :state, as: :select, collection: -> { Billing.states }

    show title: 'Billing' do |billing|
      attributes_table do
        row :contract
        row 'Timesheet' do
          link_to(billing.timesheet.description || "#{billing.timesheet.starts} to #{billing.timesheet.ends}", admin_timesheet_path(billing.timesheet_id)) if billing.timesheet
        end
        row :work_done
        row :hours
        row :minutes
        row :description
        row :state
        row :dispute_comments
        row :dispute_resolved
        row :created_at
        row :updated_at

      end
      active_admin_comments
    end


    form do |f|
      f.inputs 'Billing Entry' do
        f.input :contract_id,
                as: :select, input_html: { class: 'select2' },
                collection: Contract.find_each.map { |contract| ["#{contract.title} from #{contract.employer_profile.email}", contract.id] },
                label: 'Contract'
        if f.object.new_record?
          f.input :timesheet_id,
                  as: :select, input_html: { class: 'select2' },
                  collection: Timesheet.find_each.map { |timesheet| ["#{timesheet.description} from contract #{timesheet.contract.title}", timesheet.id] },
                  label: 'Timesheet'
        else
          f.input :timesheet_id,
                  as: :select, input_html: { class: 'select2' },
                  collection: Timesheet.where(contract_id: f.object.contract_id).map { |timesheet| ["#{timesheet.description} from contract #{timesheet.contract.title}", timesheet.id] },
                  label: 'Timesheet'
        end
        f.input :work_done
        f.input :hours
        f.input :minutes
        f.input :description
        f.input :state
        f.input :dispute_comments
        f.input :dispute_resolved
        f.actions
      end
    end

    before_create do |billing|
      billing.skip_work_done_in_current_week_validation = true
    end

    before_update do |billing|
      billing.skip_work_done_in_timesheet_validation = true
    end
  end
end
