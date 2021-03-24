if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('billings')
  ActiveAdmin.register Billing do
    menu label: 'Billing Entries'

    permit_params :contract_id, :work_done, :hours, :minutes, :description, :state,
                  :dispute_comments, :dispute_resolved
    actions :all

    index do
      id_column
      column :contract
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

    show title: 'Contract' do |contract|
      attributes_table do
        row :contract
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
      f.inputs "Billing Entry" do
        f.input :contract_id,
                as: :select, input_html: { class: 'select2' },
                collection: Contract.find_each.map {|contract| ["#{contract.title} from #{contract.employer_profile.email}", contract.id]},
                label: 'Contract'

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
  end
end
