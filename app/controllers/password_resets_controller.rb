# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :look_up_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user.present?
      @user.create_password_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password-reset instructions!'
      redirect_to root_path
    else
      flash.now[:danger] = 'Email address not found'
      render :new
    end
  end

  def edit; end

  private

  def look_up_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(
      :password_reset, params[:id]
    )
  end
end
