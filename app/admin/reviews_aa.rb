if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('reviews')
  ActiveAdmin.register Review do
    menu label: 'Reviews'
    includes :employer_profile, :freelancer_profile

    permit_params :freelancer_profile_id, :employer_profile_id, :rating, :comments
    actions :all

    index do
      id_column
      column :employer_profile
      column :freelancer_profile
      column :rating
      column :comments
      column :created_at

      actions defaults: true
    end

    filter :employer_profile_user_email, as: :string, label: 'Employer Email'
    filter :freelancer_profile_user_email, as: :string, label: 'Freelancer Email'
    filter :rating, as: :select, collection: Review::RATING_OPTIONS

    show title: 'Review' do |contract|
      attributes_table do
        row :employer_profile
        row :freelancer_profile
        row :rating
        row :comments
        row :created_at
        row :updated_at
      end
      active_admin_comments
    end


    form do |f|
      f.inputs 'Review' do
        f.input :employer_profile_id,
                as: :select, input_html: { class: 'select2' },
                collection: EmployerProfile.find_each.map{ |employer_profile| [employer_profile.email, employer_profile.id] },
                label: 'Employer'
        f.input :freelancer_profile_id,
                as: :select, input_html: { class: 'select2' },
                collection: FreelancerProfile.find_each.map{ |freelancer_profile| [freelancer_profile.email, freelancer_profile.id] },
                label: 'Freelancer'
        f.input :rating, as: :select, collection: Review::RATING_OPTIONS
        f.input :comments
        f.actions
      end
    end
  end
end
