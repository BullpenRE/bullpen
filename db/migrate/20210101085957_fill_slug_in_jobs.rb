class FillSlugInJobs < ActiveRecord::Migration[6.0]
  def up
    Job.where(slug: nil).find_each(&:generate_unique_slug!)
  end
end
