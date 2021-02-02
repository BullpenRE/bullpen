# frozen_string_literal: true

class NewJobAnnouncementsService
  def initialize(number_of_jobs: 1)
    @jobs = Job.ready_for_announcement.limit(number_of_jobs)
  end

  def process
    @jobs.each do |job|
      FreelancerProfile.ready_for_announcement.each do |freelancers_profile|
        FreelancerMailer.posted_job(job, freelancers_profile.email).deliver_later
        job.update(job_announced: true)
      end
    end
  end
end
