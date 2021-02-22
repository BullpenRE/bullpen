class AddStripeCountryToFreelancerProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :freelancer_profiles, :stripe_country, :string
  end
end
