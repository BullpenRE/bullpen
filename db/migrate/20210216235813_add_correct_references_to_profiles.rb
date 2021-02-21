class AddCorrectReferencesToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_reference :jobs, :employer_profile, foreign_key: true
    add_reference :job_applications, :freelancer_profile, foreign_key: true
  end
end
