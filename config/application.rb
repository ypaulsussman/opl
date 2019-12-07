# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Opl
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_record.primary_key = :uuid

    # Allow signup view/controller actions in dev/test
    config.allow_signups = true

    # Use a real queuing backend for Active Job (and separate queues per environment).
    config.active_job.queue_adapter = :delayed_job

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.orm :active_record, foreign_key_type: :uuid
    end
  end
end
