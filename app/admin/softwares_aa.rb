if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('softwares')
  ActiveAdmin.register Software do
    permit_params :description, :disable
    actions :all, except: [:destroy]

    index do
      column :description
      column :disable
      column :created_at

      actions defaults: true
    end

    filter :description
    filter :disable

    show title: 'Software' do
      attributes_table do
        row :description
        row :disable
        row 'Freelancers with software' do |software|
          software.freelancer_profiles.uniq.count
        end
        row 'Jobs requiring software' do |software|
          software.jobs.uniq.count
        end
        row ' ' do |software|
          button_to 'Delete', destroy_software_admin_software_path(software.id), action: :post, data: { confirm: 'Are you sure?' } if software.job_softwares.empty? && software.freelancer_softwares.empty?
        end
      end
    end

    member_action :destroy_software, method: :post do
      software = Software.find(params[:id])
      software.destroy if software.job_softwares.empty? && software.freelancer_softwares.empty?

      redirect_to admin_softwares_path, notice: 'Software Deleted'
    end
  end
end

