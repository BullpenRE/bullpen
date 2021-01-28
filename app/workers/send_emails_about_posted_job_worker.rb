class SendEmailsAboutPostedJobWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(job_id)
    @posted_job = Job.find_by(id: job_id)
    FreelancerMailer.posted_job(@posted_job, freelancer_email).deliver_now
  end
end
