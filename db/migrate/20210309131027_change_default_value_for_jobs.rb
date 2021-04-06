class ChangeDefaultValueForJobs < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:jobs, :state, from: 0, to: 3)
  end
end
