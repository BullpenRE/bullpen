class AddPayoutPercentageToFreelancerProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :freelancer_profiles, :payout_percentage, :integer, default: 70
  end
end
