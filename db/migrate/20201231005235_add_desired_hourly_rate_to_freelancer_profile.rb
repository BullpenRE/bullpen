class AddDesiredHourlyRateToFreelancerProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :freelancer_profiles, :desired_hourly_rate, :integer
  end
end
