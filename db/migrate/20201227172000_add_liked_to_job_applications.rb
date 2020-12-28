class AddLikedToJobAplication < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :liked, :boolean, default: false
  end
end
