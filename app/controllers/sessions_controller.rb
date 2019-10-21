# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authenticate_user, only: [:create]

  def new; end

  def create
    log_in(submitted_user, params[:session][:remember_me])
    redirect_back_or submitted_user
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
