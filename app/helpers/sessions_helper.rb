# frozen_string_literal: true

module SessionsHelper
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_me_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  def forget(user)
    user.forget_me
    cookies.delete(:user_id)
    cookies.delete(:remember_me_token)
  end

  def log_in(user, remember_me = '0')
    session[:user_id] = user.id
    remember_me == '1' ? remember(user) : forget(user)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    current_user.present?
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def remember(user)
    user.remember_me
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_me_token] = user.remember_me_token
  end

  def store_forwarding_url
    session[:forwarding_url] = request.original_url if request.get?
  end
end
