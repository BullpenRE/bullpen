if SharedMethods.aa_and_table_exists?('credits')
  ActiveAdmin.register Credit do
    menu label: 'Credit Entries'

    permit_params :timesheet_id, :applied_to, :description, :amount
    actions :all

    index do
      id_column
      column 'Timesheet' do |credit|
        link_to("#{credit.timesheet.description} from contract #{credit.timesheet.contract.title}: #{credit.timesheet.contract.employer_profile.email} to #{credit.timesheet.contract.freelancer_profile.email}", admin_timesheet_path(credit.timesheet_id)) if credit.timesheet.present?
      end
      column :applied_to
      column :description
      column :amount

      actions defaults: true
    end

    filter :timesheet_contract_employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :timesheet_contract_freelancer_profile_user_email, as: :string, label: 'Freelancer Email'

    show title: 'Credit' do |credit|
      attributes_table do
        row 'Timesheet' do
          link_to("#{credit.timesheet.description} from contract #{credit.timesheet.contract.title}: #{credit.timesheet.contract.employer_profile.email} to #{credit.timesheet.contract.freelancer_profile.email}", admin_timesheet_path(credit.timesheet_id)) if credit.timesheet
        end
        row :applied_to
        row :description
        row :amount
        row :created_at
        row :updated_at

      end
      active_admin_comments
    end

    form do |f|
      f.inputs 'Credit Entry' do
        f.input :timesheet_id,
                  as: :select, input_html: { class: 'select2' },
                  collection: Timesheet.all.map { |timesheet| ["#{timesheet.description} from contract #{timesheet.contract.title}", timesheet.id] },
                  label: 'Timesheet'
        f.input :applied_to
        f.input :description
        f.input :amount
        f.actions
      end
    end
  end
end
