if SharedMethods.aa_and_table_exists?('real_estate_skills')
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

    show title: 'Real Estate Skill' do
      attributes_table do
        row :description
        row :disable
        row 'Freelancers with this Real Estate Skill' do |r_e_s|
          r_e_s.freelancer_profiles.uniq.count
        end
        row :created_at
        row :updated_at
        row ' ' do |r_e_s|
          button_to 'Delete', destroy_real_estate_skill_admin_real_estate_skill_path(r_e_s.id), action: :post, data: { confirm: 'Are you sure?' } if r_e_s.freelancer_real_estate_skills.empty?
        end
      end
    end

    member_action :destroy_real_estate_skill, method: :post do
      real_estate_skill = RealEstateSkill.find(params[:id])
      real_estate_skill.destroy if real_estate_skill.freelancer_real_estate_skills.empty?

      redirect_to admin_real_estate_skills_path, notice: 'Real Estate Skill Deleted'
    end
  end
end
