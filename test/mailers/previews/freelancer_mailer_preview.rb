# Preview all emails at http://localhost:3000/rails/mailers/freelancer_mailer
class FreelancerMailerPreview < ActionMailer::Preview
  def freelancer_approved
    FreelancerMailer.freelancer_approved(User.first)
  end

  def freelancer_rejected
    FreelancerMailer.freelancer_rejected(User.first)
  end

  def interview_request
    FreelancerMailer.interview_request(InterviewRequest.first)
  end

  def send_message
    FreelancerMailer.send_message(Message.last, Job.last)
  end

  def job_application_declined
    FreelancerMailer.job_application_declined(JobApplication.first)
  end
end
