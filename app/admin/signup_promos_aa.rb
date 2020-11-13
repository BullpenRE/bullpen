if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('signup_promos')
ActiveAdmin.register SignupPromo do
  menu label: 'Promo'

  includes :users

  permit_params :user_ids,
                :description,
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
        User.select(:signup_promos_id).where(signup_promos_id: signup_promos.id).count
      end
      
      row 'Users' do
        User.where(signup_promos_id: signup_promos.id)
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
