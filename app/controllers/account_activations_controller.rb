# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user.present? && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate_account
      log_in user
      flash[:success] = 'Account activated -- welcome!'
    else
      flash[:warning] = 'Invalid activation link'
    end
    redirect_to root_url
  end
end
