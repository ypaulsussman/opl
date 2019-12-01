# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.password_reset_token = User.new_token
    UserMailer.password_reset(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/quote_of_the_day
  def quote_of_the_day
    user = User.first
    UserMailer.quote_of_the_day(user)
  end
end
