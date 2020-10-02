class CreateFreelancerRealEstateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :freelancer_real_estate_skills do |t|
      t.references :freelancers, foreign_key: true
      t.references :real_estate_skills, foreign_key: true
      t.timestamps
    end
  end
end
