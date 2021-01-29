class SendEmailsAboutPostedJobWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(job_id)
    @posted_job = Job.find_by(id: job_id)
    FreelancerProfile.new_jobs_alert.each do |freelancer_profile|
      FreelancerMailer.posted_job(@posted_job, freelancer_profile.email).deliver_later
    end
  end
end
