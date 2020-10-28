if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('real_estate_skills')
  ActiveAdmin.register RealEstateSkill do
    permit_params :description, :disable
    actions :index, :show, :create, :edit, :update

    index do
      column :description
      column :disable
      column :created_at

      actions defaults: true
    end

    filter :description
    filter :disable
  end
end
