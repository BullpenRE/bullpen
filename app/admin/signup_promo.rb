ActiveAdmin.register SignupPromo do
  menu label: 'Promo'

  index do
    column :user
    column :description
    column :code
    column :user_type
    column :enabled
    actions
  end

  show title: 'Promo' do |promo|
    attributes_table do
      row 'Email' do
        promo.users
      end
      row :description
      row :created_at
      row :updated_at
      row :code
      row :user_type
      row :enabled
    end

    active_admin_comments
  end

  form do |f|
    f.inputs "#{f.object&.users || 'New'} Promo" do

      if f.object.new_record?
        f.input :users,
                label: "User (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
      end
      f.input :description
      f.input :code
      f.input :user_type
      f.input :enabled, as: :check_boxes
      f.actions
    end
  end

  controller do
    def create
      error_message = nil
      promo = SignupPromo.new(permitted_params[:signup_promo])

      ApplicationRecord.transaction do
        signup_promo.save!
        update_sectors_skills_and_software(promo)
      rescue StandardError => e
        error_message = e.message
      end
      message = { alert: error_message } if error_message
      message ||= { notice: 'Successfully created!' }

      redirect_to admin_signup_promo_path(signup_promo.id), flash: message
    end

    def update
      error_message = nil

      promo = SignupPromo.find(params[:id])
      update_sectors_skills_and_software(promo)

      ApplicationRecord.transaction do
        promo.update!(permitted_params[:signup_promo])
      rescue StandardError => e
        error_message = e.message
      end

      message = { alert: error_message } if error_message
      message ||= { notice: 'Successfully updated!' }

      redirect_to admin_job_path(promo.id), flash: message
    end

    def update_sectors_skills_and_software(promo)
      promo.reload
    end
  end
end unless Rails.env.test?
