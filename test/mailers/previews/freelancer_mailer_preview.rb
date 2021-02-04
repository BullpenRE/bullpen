# Preview all emails at http://localhost:3000/rails/mailers/freelancer_mailer
class FreelancerMailerPreview < ActionMailer::Preview
  def freelancer_approved
    FreelancerMailer.freelancer_approved(User.last)
  end

  def freelancer_rejected
    FreelancerMailer.freelancer_rejected(User.last)
  end

  def interview_request
    FreelancerMailer.interview_request(InterviewRequest.last)
  end

  def send_message
    FreelancerMailer.send_message(Message.find_by(from_user: User.employers), Job.last.title)
  end

  def send_message_from_interview_page
    FreelancerMailer.send_message(Message.find_by(from_user: User.employers), '')
  end

  def job_application_declined
    FreelancerMailer.job_application_declined(JobApplication.last)
  end

  def interview_request_was_withdrawn
    FreelancerMailer.interview_request_was_withdrawn(InterviewRequest.last)
  end

  def offer_made
    FreelancerMailer.offer_made(Contract.last)
  end

  def offer_update
    FreelancerMailer.offer_update(Contract.last)
  end
end
