ActiveAdmin.register User do

  permit_params :email, :first_name, :last_name, :confirmed_at

  index do
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :last_sign_in_at
    column :confirmed_at

    actions defaults: true
  end

  filter :email
  filter :confirmed, as: :boolean

  form do |f|
    f.inputs 'User Info' do
      f.input :email
      f.input :password, label: 'Password (if unchanged, leave blank)'
      f.input :first_name
      f.input :last_name
      f.input :confirmed_at, label: 'Confirmed (UTC)'
      f.actions
    end
  end

  controller do
    def update
      Rails.logger.info "!!!!!!! running update now !!!!!!!!"
      user = User.find(params[:id])
      error_message = nil
      params[:user].delete('password') if params[:user][:password].blank?

      begin
        user.update!(params.permit![:user])
      rescue StandardError => e
        error_message = e.message
      end

      redirect_to admin_user_path(user), notice: ('Successfully updated!' unless error_message), alert: error_message
    end

    def create
      @user = User.new(params.permit![:user])
      super
    end

  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :first_name, :last_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :first_name, :last_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
