Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  host = 'localhost:3000'

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = false

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Added because letter_opener gem said so
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true

  # Needed for devise and mailers
  config.action_mailer.preview_path = "#{Rails.root}/test/mailers/previews"
  config.action_mailer.asset_host = "http://#{host}"
  config.action_mailer.default_url_options = { host: host }
  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  config.active_job.queue_adapter = :sidekiq

  ENV['DOMAIN_URL'] = host

  # Please set these variables in your local .env file
  # ENV['GOOGLE_SIGN_IN_CLIENT_ID'] = 'xxxxx.apps.googleusercontent.com'
  # ENV['GOOGLE_SIGN_IN_CLIENT_SECRET'] = 'xxxxx'
  ENV['STRIPE_PUBLISHABLE_KEY'] = 'pk_test_xxxxxxx'
  ENV['STRIPE_SECRET_KEY'] = 'sk_test_xxxxxxx'
  ENV['STRIPE_CLIENT_ID'] = 'ca_xxxxxx'
  ENV['STRIPE_SIGNING_SECRET'] = 'xxxxxx'
  ENV['MIXPANEL_TOKEN'] = 'xxxxxx'
  ENV['MIXPANEL'] = 'true'
  ENV['STRIPE_PUBLISHABLE_KEY'] = 'pk_test_wvFaryXD9bfRc4NsJApj7h96'
  ENV['STRIPE_SECRET_KEY'] = 'sk_test_k7lMkrLmOH4PnQwggdMl6rqD'
  ENV['STRIPE_CLIENT_ID'] = 'ca_F92ZNOQd5VYyop7dz5TP5qB7uf3ljnuk'
  ENV['NEW_JOB_ANNOUNCEMENT_SINGLE_EMAIL'] = 'false'
end
