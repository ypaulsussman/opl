# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Reload code on every request (slower response, but no web-server restart on code-change.)
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Send emails to localhost.
  host = 'localhost:3000'
  config.action_mailer.default_url_options = { host: host, protocol: 'http' }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Don't cache emails
  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
