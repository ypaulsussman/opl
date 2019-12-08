# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: %("Other People's Lines" <noreply@example.com>)
  layout 'mailer'
end
