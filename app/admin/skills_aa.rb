if defined?(ActiveAdmin) && ApplicationRecord.connection.data_source_exists?('skills')
  ActiveAdmin.register Skill do
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

    show title: 'Skill' do
      attributes_table do
        row :description
        row :disable
        row 'Jobs with this skill' do |skill|
          skill.jobs.uniq.count
        end
        row :created_at
        row :updated_at
        row ' ' do |skill|
          button_to 'Delete', destroy_skill_admin_skill_path(skill.id), action: :post, data: { confirm: 'Are you sure?' } if skill.job_skills.empty?
        end
      end
    end

    member_action :destroy_skill, method: :post do
      skill = Skill.find(params[:id])
      skill.destroy if skill.job_skills.empty?

      redirect_to admin_skills_path, notice: 'Skill Deleted'
    end

  end
end


