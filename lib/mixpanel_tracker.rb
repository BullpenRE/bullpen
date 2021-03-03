# frozen_string_literal: true

class MixpanelTracker
  include Singleton

  def track(user_id, event_key, properties)
    return unless tracker.present?

    tracker.track(user_id, event_key, properties)
  end

  private

  def tracker
    return nil if ENV['MIXPANEL_TOKEN'].blank? || ENV['MIXPANEL'] != 'true'

    @tracker ||= Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
  end
end
