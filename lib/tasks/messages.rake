# frozen_string_literal: true

namespace :messages do
  desc 'Send emails out to all freelancers who have the freelancer_profile.new_jobs_alert set as true'
  task new_jobs_alerts: :environment do
    NewJobAnnouncementsService.new(number_of_jobs: 1).process
  end

  desc 'Send emails to all employers if time entries are edited or removed by the freelancer for a pending pay period'
  task employer_review_billing_entries: :environment do
    EmployerReviewBillingEntriesService.new.process
  end

  desc 'Send an email to employer within 24 hours before the end pay period deadline'
  task employer_review_pending_payment: :environment do
    EmployerReviewPendingPaymentService.new.process
  end
end
