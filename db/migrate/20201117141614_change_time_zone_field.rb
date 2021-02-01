class ChangeTimeZoneField < ActiveRecord::Migration[6.0]
  def up
    change_column :jobs, :time_zone, :integer, using: 'time_zone::integer'
  end

  def down
    change_column :jobs, :time_zone, :string
  end
end
