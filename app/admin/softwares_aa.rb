if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('softwares')
  ActiveAdmin.register Software do
    menu label: 'Software'

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

