class AddStripeIdAccountToFreelancerProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :freelancer_profiles, :stripe_id_account, :string
  end
end
