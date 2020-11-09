ActiveAdmin.register RealEstateSkill do
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
end unless Rails.env.test?
