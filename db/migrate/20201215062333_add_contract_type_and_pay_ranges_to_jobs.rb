class AddContractTypeAndPayRangesToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :contract_type, :integer
    add_column :jobs, :pay_range_low, :integer
    add_column :jobs, :pay_range_high, :integer
  end
end
