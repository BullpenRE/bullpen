class RemoveCoverLetterFromJobApplicatios < ActiveRecord::Migration[6.0]
  def change
    remove_column :job_applications, :cover_letter, :text
  end
end
