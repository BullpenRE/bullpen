class RenameColumnPerHourBidToBidAmountInJobApplications < ActiveRecord::Migration[6.0]
  def up
    rename_column :job_applications, :per_hour_bid, :bid_amount
  end

  def down
    rename_column :job_applications, :bid_amount, :per_hour_bid
  end
end
