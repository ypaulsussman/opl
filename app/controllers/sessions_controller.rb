# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authenticate_user, only: [:create]

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or quotes_path
      else
        message = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def submitted_user
    @submitted_user ||= User.find_by(email: params[:session][:email].downcase)
  end

  private

  def authenticate_user
    return if submitted_user&.authenticate(params[:session][:password])

    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end
