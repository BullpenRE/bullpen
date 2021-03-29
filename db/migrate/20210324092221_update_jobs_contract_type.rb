class UpdateJobsContractType < ActiveRecord::Migration[6.1]
  def up
    Job.where.not(contract_type: 0).update_all(contract_type: 0, pay_range_low: 75, pay_range_high: 150)
  end
end
