# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def currently_logged_in?
      session[:user_id].present?
    end

    def log_in_as(user)
      session[:user_id] = user.id
    end

    def add_users
      @user_uno = users(:one)
      @user_dos = users(:two)
      [@user_uno, @user_dos].each do |u|
        u.update!(password: 'foobar', password_confirmation: 'foobar')
      end
    end
  end
end

module ActionDispatch
  class IntegrationTest
    def log_in_as(user, password: 'foobar', remember_me: '1')
      post(
        login_path,
        params: {
          session: {
            email: user.email,
            password: password,
            remember_me: remember_me
          }
        }
      )
    end
  end
end
