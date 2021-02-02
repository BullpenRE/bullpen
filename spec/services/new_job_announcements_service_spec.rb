require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe NewJobAnnouncementsService do
  let!(:job) { FactoryBot.create(:job, state: 'posted', job_announced: false) }
  let!(:freelancer_profile_complete) { FactoryBot.create(:freelancer_profile, :complete, new_jobs_alert: true) }
  let!(:freelancer_profile_1) { FactoryBot.create(:freelancer_profile, :complete, new_jobs_alert: true) }
  let!(:service) { NewJobAnnouncementsService.new }

  it 'should send mails to freelancers with new_jobs_alert set to true' do
    expect { service.process }.
      to have_enqueued_job(ActionMailer::MailDeliveryJob).
        with('FreelancerMailer', 'posted_job', 'deliver_now', { args: [job, [freelancer_profile_complete.email, freelancer_profile_1.email]] })
    job.reload
    expect(job.job_announced).to eq true
  end

  it 'should not send mails to freelancers with new_jobs_alert set to false' do
    freelancer_profile_complete.update(new_jobs_alert: false)
    expect { service.process }.
      to have_enqueued_job(ActionMailer::MailDeliveryJob).
        with('FreelancerMailer', 'posted_job', 'deliver_now', { args: [job, [freelancer_profile_1.email]] })
  end
end