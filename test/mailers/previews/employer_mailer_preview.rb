# Preview all emails at http://localhost:3000/rails/mailers/employer_mailer
class EmployerMailerPreview < ActionMailer::Preview
  def new_job_application
    EmployerMailer.new_job_application(User.where(:role => 0).first, JobApplication.first)
  end

  def job_application_was_withdrawn
    EmployerMailer.job_application_was_withdrawn(JobApplication.first)
  end

end
