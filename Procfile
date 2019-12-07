web: bundle exec puma -C config/puma.rb
worker: env QUEUES=default,mailers bundle exec rake jobs:work