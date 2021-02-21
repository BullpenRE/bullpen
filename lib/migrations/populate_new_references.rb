# frozen_string_literal: true

class PopulateNewReferences
  def up
    Job.where(employer_profile_id: nil).where.not(user_id: nil).each do |job|
      employer_profile_id = job.user.employer_profile&.id
      job.update(employer_profile_id: employer_profile_id) if employer_profile_id
    end

    JobApplication.where(freelancer_profile_id: nil).where.not(user_id: nil).each do |job_application|
      freelancer_profile_id = job_application.user.freelancer_profile&.id
      job_application.update(freelancer_profile_id: freelancer_profile_id) if freelancer_profile_id
    end
  end
end
