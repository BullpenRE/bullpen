ActiveAdmin.register Certification do
  permit_params :description, :disable
  actions :index, :show, :create, :edit, :update

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
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs 'Certification' do
      f.input :description
      f.input :disable
      f.actions
    end
  end

  controller do
    def scoped_collection
      super.searchable
    end
  end
end unless Rails.env.test?
