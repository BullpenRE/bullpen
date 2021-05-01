if SharedMethods.aa_and_table_exists?('payment_accounts')
  ActiveAdmin.register PaymentAccount do
    menu label: 'Employer Payment Accounts'

    includes :employer_profile

    filter :employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :stripe_object, as: :select, collection: -> { PaymentAccount.stripe_objects }, label: 'Account Type'
    filter :is_default, label: 'Default Payment Account', as: :check_boxes, collection: [['Yes', true]]

    permit_params :employer_profile_id, :stripe_object, :id_stripe, :last_four, :fingerprint, :card_brand,
                  :card_expires, :card_cvc_check, :bank_name, :bank_routing_number, :bank_status, :is_default


    index do
      column :employer_profile
      column 'Account Type' do |payment_account|
        payment_account.stripe_object.capitalize
      end
      column 'Institution' do |payment_account|
        payment_account.institution
      end
      column 'Status' do |payment_account|
        payment_account.status
      end
      column :is_default

      actions
    end

    show title: 'Employer Payment Account' do |payment_account|
      attributes_table do
        row :employer_profile
        row 'Account Type' do
          payment_account.stripe_object.split('_').join(' ').capitalize
        end
        row 'Stripe ID' do
          payment_account.id_stripe
        end
        row :last_four
        row :fingerprint
        if payment_account.stripe_object == 'card'
          row :card_brand
          row 'Expires' do
            if payment_account.card_expires.present?
              "#{payment_account.card_expires.month} / #{payment_account.card_expires.year}#{' <b style="color: red;">(expired)</b>' if payment_account.expired?}".html_safe
            end
          end
          row :card_cvc_check
        end
        if payment_account.stripe_object == 'bank_account'
          row :bank_name
          row :bank_routing_number
          row :bank_status
        end
        row :is_default
        row :created_at
        row :updated_at
        row 'Contracts' do
          payment_account.contracts.map{|contract| link_to(contract.title, admin_contract_path(contract.id))}.join('<br>').html_safe
        end
      end
      active_admin_comments
    end

    form do |f|
      f.inputs 'Employer Payment Account' do
        f.input :is_default
        f.input :employer_profile,
                as: :select, input_html: { class: "select2" },
                collection: EmployerProfile.all.map{|profile| [profile.email, profile.id]}
        f.input :stripe_object, label: 'Account Type'
        f.input :id_stripe, label: 'Stripe ID'
        f.input :last_four
        f.input :fingerprint
        f.input :card_brand
        f.input :card_expires, as: :date_select, discard_day: true, order: [:month, :year]
        f.input :card_cvc_check
        f.input :bank_name
        f.input :bank_routing_number
        f.input :bank_status
        f.actions
      end
    end
  end
end
