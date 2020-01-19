# frozen_string_literal: true

require_relative 'boot'

require 'rails'

require 'active_record/railtie'
require 'active_model/railtie'

require 'action_controller/railtie'
require 'action_view/railtie'

require 'active_job/railtie'
require 'action_mailer/railtie'

require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Opl
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Allow signup view/controller actions in dev/test
    config.allow_signups = true

    # Connect Active Job's queuing backend
    config.active_job.queue_adapter = :delayed_job

    # Use uuid's for pk's
    config.active_record.primary_key = :uuid

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.orm :active_record, foreign_key_type: :uuid
    end
  end
end
