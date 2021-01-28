if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('messages')
  ActiveAdmin.register Message do
    menu label: 'Messages'
    includes :from_user, :to_user

    permit_params :from_user_id, :to_user_id, :description
    actions :all

    index do
      id_column
      column 'From User' do |message|
        link_to message.from_user.email, admin_user_path(message.from_user_id)
      end
      column 'To User' do |message|
        link_to message.to_user.email, admin_user_path(message.to_user_id)
      end
      column :created_at
      column :updated_at

      actions defaults: true
    end

    filter :from_user_email, as: :string, label: 'From User Email'
    filter :to_user_email, as: :string, label: 'To User Email'

    show title: 'Message' do |message|
      attributes_table do
        row 'From User' do
          link_to message.from_user.email, admin_user_path(message.from_user_id)
        end
        row 'To User' do
          link_to message.to_user.email, admin_user_path(message.to_user_id)
        end
        row :created_at
        row :updated_at
        row 'Description' do
          message.description.body.to_s
        end
      end
      active_admin_comments
    end


    form do |f|
      f.inputs "Message" do
        if f.object.new_record?
          f.input :from_user_id,
                  as: :select, input_html: { class: "select2" },
                  collection: User.pluck(:email, :id),
                  label: "From User (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
          f.input :to_user_id,
                  as: :select, input_html: { class: "select2" },
                  collection: User.pluck(:email, :id),
                  label: "To User (#{link_to('Create new', new_admin_user_path, target: '_blank')})".html_safe
        end

        f.input :description, as: :text
        f.actions
      end
    end
  end
end
