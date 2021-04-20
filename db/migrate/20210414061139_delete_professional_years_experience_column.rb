class DeleteProfessionalYearsExperienceColumn < ActiveRecord::Migration[6.1]
  def up
    remove_column :freelancer_profiles, :professional_years_experience
  end

  def down
    add_column :freelancer_profiles, :professional_years_experience, :integer
  end
end
