# frozen_string_literal: true

class MixpanelTracker
  def initialize
    @tracker = Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
  end

  def track(user_id, event_key, properties)
    @tracker.track(user_id, event_key, properties) if ENV['MIXPANEL'] == 'true'
  end

end
