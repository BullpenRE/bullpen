require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bullpen
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Suppress automatic generation of certain types of specs
    # Per https://www.codewithjason.com/get-rspec-skip-view-specs-generate-scaffolds/
    config.generators do |generate|
      generate.test_framework :rspec,
                              fixtures: false,
                              view_specs: false,
                              helper_specs: false,
                              routing_specs: false,
                              request_specs: false,
                              controller_specs: false
    end

    # Suppress automatic generation of stylesheets per
    # https://stackoverflow.com/questions/14045858/syntax-to-skip-creating-tests-assets-helpers-for-rails-generate-controller
    config.generators.stylesheets = false
    config.generators.helper = false
  end
end
