# frozen_string_literal: true

Rails.application.configure do
  # Reload code on every request (slower response, but no web-server restart on code-change.)
  config.cache_classes = false

  # Do not eager-load entire app, for the times you're running just a single test.
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

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # send emails to localhost
  host = 'localhost:3000'
  config.action_mailer.default_url_options = { host: host, protocol: 'http' }

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr
end
