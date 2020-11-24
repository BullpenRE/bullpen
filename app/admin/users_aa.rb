if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('users')
  ActiveAdmin.register User do
    permit_params :email, :first_name, :last_name, :confirmed_at

    index do
      column :email
      column :first_name
      column :last_name
      column :created_at
      column :last_sign_in_at
      column :confirmed_at
      column :role
      column :signup_promo

      actions defaults: true
    end

    filter :email
    filter :confirmed, as: :boolean

    form do |f|
      f.inputs 'User Info' do
        f.input :email
        f.input :password, label: "Password#{' (if unchanged leave blank)' unless f.object.new_record?}"
        f.input :first_name
        f.input :last_name
        f.input :role, as: :select
        f.input :confirmed_at, label: 'Confirmed (UTC)'
        f.actions
      end
    end

    controller do
      def update
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
  end
end
