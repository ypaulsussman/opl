# frozen_string_literal: true

class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'OPL Up, Friend!'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'OPL Password Reset'
  end

  def quote_of_the_day(user, quote)
    @quote = quote
    mail to: user.email, subject: "OPL for #{Date.today.to_formatted_s(:long_ordinal)}"
  end
end
