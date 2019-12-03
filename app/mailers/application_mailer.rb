# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'ypaulsussman@gmail.com'
  layout 'mailer'
end
