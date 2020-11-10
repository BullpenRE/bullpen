if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('freelancer_certifications')
  ActiveAdmin.register FreelancerCertification do
    menu false

    permit_params :freelancer_profile_id, :certification_id, :description, :earned

    filter :freelancer_profile,
           as: :select,
           label: 'User Email',
           collection: FreelancerProfile.find_each.map {|fp| [fp.user.email, fp.id] }


    index do
      column 'Freelancer Profile' do |freelancer_certification|
        link_to freelancer_certification.user.email, admin_freelancer_profile_path(freelancer_certification.freelancer_profile_id)
      end
      column 'Searchable by' do |freelancer_certification|
        freelancer_certification.certification.description
      end
      column :description
      column :earned
      actions
    end

    show do
      attributes_table do
        row "Freelancer Profile" do |freelancer_certification|
          link_to freelancer_certification.user.email, admin_freelancer_profile_path(freelancer_certification.freelancer_profile_id)
        end
        row "Searchable Certification" do |freelancer_certification|
          unless freelancer_certification.certification.custom
            link_to freelancer_certification.certification.description, admin_certification_path(freelancer_certification.certification_id)
          end
        end
        row :description
        row 'Earned' do |freelancer_certification|
          freelancer_certification.earned.year
        end
        row :created_at
        row :updated_at
      end
    end

    form do |f|
      f.inputs "Certifications for" do
        f.input :freelancer_profile,
                as: :select,
                collection: FreelancerProfile.find_each.map{|fp| [fp.user.email, fp.id] }
        f.input :certification_id,
                as: :select,
                collection: Certification.order(custom: :desc, description: :asc).each.map{|c| [(c.custom ? 'CUSTOM' : c.description), c.id] }
        f.input :description, label: 'Custom Description'
        f.input :earned, discard_day: true, discard_month: true, start_year: FreelancerCertification::AVAILABLE_YEARS.min, end_yaer: FreelancerCertification::AVAILABLE_YEARS.max
        f.actions
      end
    end

    controller do
      def create
        certification = Certification.find(params[:freelancer_certification][:certification_id])
        params[:freelancer_certification][:description] = certification.description unless params[:freelancer_certification][:description].present?
        super
      end
    end
  end
end
