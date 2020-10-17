# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # config.cache_classes = false
  config.cache_classes = !ENV['CYPRESS_DEV']  ## can be used within TDD in development with Cypress usage
  config.action_view.cache_template_loading = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  if Rails.env.test?
    # Rails.application.config.hosts << "/test/*"
    Rails.application.config.hosts.clear
  end

  # Adding this because tests bomb out if I don't have it
  current_node = ENV['CIRCLE_NODE_INDEX'] || ENV['CI_NODE_INDEX'] || ENV['TEST_ENV_NUMBER']
  ENV['TEST_DOMAIN'] = '127.0.0.1'
  ENV['TEST_PORT'] = (3001 + current_node.to_i).to_s
  ENV['WEBSITE_URL'] = "#{ENV['TEST_DOMAIN']}:#{ENV['TEST_PORT']}"
  config.action_mailer.default_url_options = { host: ENV['WEBSITE_URL'] }

  config.factory_bot.definition_file_paths = ['**/factories/**.rb']

  config.after_initialize do
    Rails.application.routes.default_url_options[:host] = ENV['WEBSITE_URL']
  end
end
