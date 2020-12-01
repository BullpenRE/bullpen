class FillSlugInFreelancerProfile < ActiveRecord::Migration[6.0]
  def up
    FreelancerProfile.where(slug: nil).find_each(&:generate_unique_slug!)
  end
end
