if SharedMethods.aa_and_table_exists?('certifications')
  ActiveAdmin.register Certification do
    permit_params :description, :disable
    actions :all, except: [:destroy]

    filter :description
    filter :disable

    index do
      column :description
      column :disable
      column :created_at

      actions defaults: true
    end

    show title: 'Certification' do
      attributes_table do
        row :description
        row :disable
        row 'Freelancers with certification' do |cert|
          cert.freelancer_profiles.uniq.count
        end
        row :created_at
        row :updated_at
        row ' ' do |cert|
          button_to 'Delete', destroy_certification_admin_certification_path(cert.id), action: :post, data: { confirm: 'Are you sure?' } if cert.freelancer_profiles.empty?
        end
      end
    end

    form do |f|
      f.inputs 'Certification' do
        f.input :description
        f.input :disable
        f.actions
      end
    end

    member_action :destroy_certification, method: :post do
      certification = Certification.find(params[:id])
      certification.destroy if certification.freelancer_profiles.none?

      redirect_to admin_certifications_path, notice: 'Certification Deleted'
    end

    controller do
      def scoped_collection
        super.searchable
      end
    end
  end
end
