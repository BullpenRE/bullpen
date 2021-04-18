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

    scope :all, -> { Timesheet.all }
    scope :ready_for_payment, -> { Timesheet.ready_for_payment }
    scope :paid, -> { Timesheet.paid }

    show title: 'Timesheet' do
      attributes_table do
        row :contract
        row :description
        row :starts
        row :ends
        row :created_at
        row :updated_at
        row 'Billing Entries' do
          (timesheet.billings.order(work_done: :desc).map { |billing| link_to("#{billing.description} done on #{billing.work_done}", admin_billing_path(billing.id))}.join('<br>') + link_to('<br>Add New'.html_safe, new_admin_billing_path(:billing=> { :contract_id => timesheet.contract_id, :timesheet_id => timesheet.id }), target: '_new')).html_safe
        end
        row ' ' do |timesheet|
          if timesheet.stripe_id_invoice.blank? && timesheet.contract.employer_profile.payment_accounts.present? && Date.current > timesheet.end
            button_to 'Charge Employer', charge_employer_admin_timesheet_path(timesheet.id), action: :post
          end
        end
      end
      active_admin_comments
    end

    member_action :charge_employer, method: :post do
      timesheet = Timesheet.find_by(id: params[:id])
      response = Stripe::Customer::InvoiceService.new(timesheet)

      if response.present?
        redirect_to admin_timesheets_path, notice: 'Invoice created'
      else
        redirect_to admin_timesheets_path, alert: 'Error'
      end
    end

    form do |f|
      f.inputs 'Timesheet Entry' do
        f.input :contract_id,
                as: :select, input_html: { class: 'select2' },
                collection: Contract.find_each.map {|contract| ["#{contract.title} from #{contract.employer_profile.email}", contract.id]},
                label: 'Contract'

        f.input :description
        f.input :starts
        f.input :ends
        f.actions
      end
    end
  end
end
