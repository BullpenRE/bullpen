# frozen_string_literal: true

class MixpanelWorker
  include Sidekiq::Worker

  def perform(user_id, event_key, properties)
    tracker = MixpanelTracker.instance
    tracker.track(user_id, event_key, properties)
  end
end
