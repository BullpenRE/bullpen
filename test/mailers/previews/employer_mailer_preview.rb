# Preview all emails at http://localhost:3000/rails/mailers/employer_mailer
class EmployerMailerPreview < ActionMailer::Preview
  def new_job_application
    EmployerMailer.new_job_application(User.first)
  end
end
