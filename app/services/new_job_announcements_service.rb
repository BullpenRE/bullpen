# frozen_string_literal: true

class NewJobAnnouncementsService
  def initialize(number_of_jobs: 1)
    @jobs = Job.ready_for_announcement.limit(number_of_jobs)
  end

  def process
    @jobs.each do |job|
      FreelancerMailer.posted_job(job, freelancers_emails).deliver_later if freelancers_emails.present?
      job.update(job_announced: true)
    end
  end

  private

  def freelancers_emails
    @freelancers_emails ||= FreelancerProfile.ready_for_announcement.map(&:email)
  end
end
