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
  config.consider_all_requests_local = true

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

  ENV['GOOGLE_SIGN_IN_CLIENT_ID'] = '643730797896-imke97p03uhd2486gqkdhm35ucmh7qcb.apps.googleusercontent.com'
  ENV['GOOGLE_SIGN_IN_CLIENT_SECRET'] = 'ZaS0BLghoHk3tlsw1J6sHVhH'

  ENV['MIXPANEL_TOKEN'] = '718e55b4216b4f5b266dfd83b6903ae3'
  ENV['MIXPANEL'] = 'true'
end
