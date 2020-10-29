ActiveAdmin.register SignupPromos do
  menu label: 'Promo'

  includes :users

  permit_params :user_ids,
                :description,
                :code,
                :user_type,
                :enabled

  index do
    column :users
    column :description
    column :code
    column :user_type
    column :enabled
    actions
  end

  show title: 'Promo' do |promo|
    attributes_table do
      row :users
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
                as: :select,
                collection: User.employers.order(:email).pluck(:email, :id),
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
      promo = SignupPromos.new(permitted_params[:signup_promos])

      ApplicationRecord.transaction do
        promo.save!
      rescue StandardError => e
        error_message = e.message
      end
      message = { alert: error_message } if error_message
      message ||= { notice: 'Successfully created!' }

      redirect_to admin_signup_promo_path(promo.id), flash: message
    end

    def update
      error_message = nil

      promo = SignupPromos.find(permitted_params[:id])

      ApplicationRecord.transaction do
        promo.update!(permitted_params[:signup_promos])
      rescue StandardError => e
        error_message = e.message
      end

      message = { alert: error_message } if error_message
      message ||= { notice: 'Successfully updated!' }

      redirect_to admin_signup_promo_path(promo.id), flash: message
    end
  end
end unless Rails.env.test?
