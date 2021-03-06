# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.7'

gem 'rails', '~> 6.1.3.2'
# Use postgres as the database for Active Record
gem 'pg', '~> 1.2'
# Use Puma as the app server
gem 'puma', '~> 5.3'
# Transpile app-like JavaScript
gem 'webpacker', '~> 5.2'
# Navigate your web application faster
gem 'turbolinks', '~> 5.2'
# Provide pagination
gem 'kaminari', '~> 1.2'
# Provide queueing for async jobs
gem 'delayed_job_active_record', '~> 4.1'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.16'
# Role models are important
gem 'rubocop'

# Maddeningly, sprockets 4+ requires a manifest.js file, even if
# you're not _actually_ using it to compile your assets:
# https://github.com/rails/sprockets/issues/643
# https://github.com/rails/sprockets/issues/654
gem 'sprockets', '~>3.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.7.3', require: false

# Abort and log requests of >15 sec (recommended by Heroku)
gem 'rack-timeout'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. 
  # Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.35'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end
