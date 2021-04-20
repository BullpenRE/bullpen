class AddCreditBalanceToFreelancerProfileAndEmployerProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :freelancer_profiles, :credit_balance, :integer, default: 0
    add_column :employer_profiles, :credit_balance, :integer, default: 0
  end
end
