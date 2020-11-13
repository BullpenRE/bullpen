if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('signup_promos')
ActiveAdmin.register SignupPromo do
  menu label: 'Promo'

  permit_params :description,
                :code,
                :user_type,
                :expires

  index do
    column :description
    column :code
    column :user_type
    column :expires
    actions
  end

  show title: 'Promo' do |promo|
    attributes_table do
      row :description
      row :created_at
      row :updated_at
      row :code
      row :user_type
      row :expires

      row 'Count of users'  do
        User.select(:signup_promo_id).where(signup_promo_id: signup_promo.id).count
      end

      row 'Users' do
        User.where(signup_promo_id: signup_promo.id)
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs "#{f.object&.users || 'New'} Promo" do

      f.input :description
      f.input :code
      f.input :user_type
      f.input :expires
      f.actions
    end
  end

end unless Rails.env.test?
end
