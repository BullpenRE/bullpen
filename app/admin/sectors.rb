ActiveAdmin.register Sector do
  permit_params :description, :disable
  actions :all, except: [:destroy]

  index do
    column :description
    column :disable
    column :created_at

    actions defaults: true
  end

  show title: 'Sector' do
    attributes_table do
      row :description
      row :disable
      row 'Freelancers with this sector' do |sector|
        sector.freelancer_profiles.uniq.count
      end
      row 'Jobs with this sector' do |sector|
        sector.jobs.uniq.count
      end
      row 'Employers with this sector' do |sector|
        sector.employer_profiles.uniq.count
      end
      row :created_at
      row :updated_at
      row ' ' do |sector|
        if sector.freelancer_sectors.empty? && sector.job_sectors.empty? && sector.employer_sectors.empty?
          button_to 'Delete', destroy_sector_admin_sector_path(sector.id), action: :post, data: { confirm: 'Are you sure?' }
        end
      end
    end
  end

  member_action :destroy_sector, method: :post do
    sector = Sector.find(params[:id])
    sector.destroy if sector.freelancer_sectors.empty? && sector.job_sectors.empty? && sector.employer_sectors.empty?

    redirect_to admin_sectors_path, notice: 'Sector Deleted'
  end

  filter :description
  filter :disable
end unless Rails.env.test?
