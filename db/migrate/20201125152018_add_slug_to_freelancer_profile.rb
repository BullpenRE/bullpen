class AddSlugToFreelancerProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :freelancer_profiles, :slug, :string
  end
end
