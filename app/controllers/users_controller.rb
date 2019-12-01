# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :confirm_logged_in, only: [:index, :edit, :update]
  before_action :confirm_correct_user, only: [:edit, :update]
  before_action :confirm_admin, only: [:index, :destroy]

  NO_SIGNUP_MESSAGE =
    'Sorry! I\'m trying to keep my SendGrid subscription at ' \
    'the free tier, so account signup is currently disabled.'

  # GET /users
  def index
    @users = User.where(activated: true).page(params[:page])
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    redirect_to root_url unless @user.activated?
  end

  # GET /users/new
  def new
    disallow_signup && return unless Rails.configuration.allow_signups
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  def create
    disallow_signup && return unless Rails.configuration.allow_signups

    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Excellent! Please check your email to activate your account.'
      redirect_to root_url
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit 
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def confirm_correct_user
    return if current_user?(User.find(params[:id]))

    confirm_admin
  end

  def confirm_logged_in
    return if logged_in?

    store_forwarding_url
    flash[:danger] = 'Please log in.'
    redirect_to login_path
  end

  def disallow_signup
    flash[:info] = NO_SIGNUP_MESSAGE
    redirect_to root_url
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :receive_qotd)
  end
end
