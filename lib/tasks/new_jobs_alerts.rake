# frozen_string_literal: true

namespace :messages do
  desc 'Send emails out to all freelancers who have the freelancer_profile.new_jobs_alert set as true'
  task new_jobs_alerts: :environment do
    NewJobAnnouncementsService.new(number_of_jobs: 1).process
  end
end
