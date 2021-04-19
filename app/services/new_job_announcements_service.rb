# frozen_string_literal: true

class NewJobAnnouncementsService
  def initialize(number_of_jobs: 1)
    @jobs = Job.ready_for_announcement.limit(number_of_jobs)
  end

  def process
    @jobs.each do |job|
      freelancers_ready_for_announcement.each do |freelancers_profile|
        FreelancerMailer.posted_job(job, freelancers_profile).deliver_later
        job.update(job_announced: true)
      end
    end
  end

  def freelancers_ready_for_announcement
    return FreelancerProfile.ready_for_announcement.limit(1) if ENV['NEW_JOB_ANNOUNCEMENT_SINGLE_EMAIL'] == 'true'

    FreelancerProfile.ready_for_announcement
  end
end
