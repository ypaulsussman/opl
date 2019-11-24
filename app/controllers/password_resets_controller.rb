# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :look_up_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_token_expiration, only: [:edit, :update]

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

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:password_reset_digest, nil)
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def check_token_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_path
  end

  def look_up_user
    @user = User.find_by(email: params[:email])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(
      :password_reset, params[:id]
    )
  end
end
