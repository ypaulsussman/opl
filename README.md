# OPL (Other People's Lines)

In the autumn of 2019, I set out to construct a broader understanding of the basic affordances that Ruby on Rails provides. 

Wary of building [inert knowledge](https://en.wikipedia.org/wiki/Inert_knowledge) and all-too-familiar with the thorniness of [transfer of practice](https://en.wikipedia.org/wiki/Transfer_of_learning), I decided to build a slightly-more-complex-than-CRUD app in parallel to reading through the (_excellent!_) [RailsGuides](https://guides.rubyonrails.org/). In particular, I settled on an app to email me daily quotes from a (_~980-record_) plaintext file I'd been lackadaisically populating since my late teens.

Shortly into the project, I realized two things: [1] auth, full-text search, and frontend asset-management would never come easy w/o deliberate engagement; and [2] those RailsGuides are _hefty:_ lots of content there. As such, I expanded my initial "MVC and a bit more" app-blueprint to include each of those fields, too (_and, I'd hoped, better balance the coding-to-notetaking activity ratio._)

I'm writing this in January 2020, and by my private roadmap I'm - maybe - 2/3 of the way done. 😅

A couple more-detailed posts on the project will be trickling out at [ye olde miniblog](https://www.suss.world/) over the coming spring; in the interim, should you want to play around on a copy of your own, read on...

## Setup for Local Development
  - Install Ruby 2.7.0 and PostgreSQL 11.5
    - There's _probably_ some leeway with the PostgreSQL version, but Heroku and Bundler, at least, certainly won't like other versions of Ruby unless tell them to.
    - I recommend grabbing [Homebrew,](https://docs.brew.sh/Installation) then running
    - `brew install rbenv`
    - `rbenv init`
    - `rbenv install 2.7.0`
    - `brew install postgresql`
    - `brew services start postgresql`
  - We deliberately want to [install foreman outside the app's bundle](https://github.com/ddollar/foreman/wiki/Don't-Bundle-Foreman) -- run `gem install foreman`
  - Pull from GitHub with that beautiful green `Clone or download` button above
  - `cd` into the directory and `bundle install`
  - `rails db:prepare` -- this is Rails 6, baby; we can get idempotent!
  - `rake populate_send_at_date_for_quotes` will ensure all initially-seeded quotes have a send-at date
  - _Possibly_ both `bundle exec rails webpacker:install` then `yarn install`, but likely just the latter: try it first
  - Set up db extensions:
    - `psql opl_development`, then (from within the db client) run:
    - `opl_development=# select - from pg_available_extensions;`
    - `opl_development=# CREATE EXTENSION pgcrypto;`
  - Create at least one admin account, via e.g. 
    - `rails c`
    - `irb(main):001:0> User.create!(name: 'Whatever', email: 'acct_you_own@example.com', password: 'my_arbitrary_password', password_confirmation: 'my_arbitrary_password', admin: true, activated: true)` in console to create admin
  - Finally, run `foreman start` to spin up your local version, and navigate to `http://localhost:5000/`!

### Setup for Remote Deployment
  - `heroku create`
  - `git push heroku master`
  - `heroku run rake db:migrate`
  - heroku addons:
    - `heroku addons:create sendgrid:starter`
    - `heroku addons:create scheduler:standard`
  - Set `host` in `production.rb` to your own Heroku site
  - If you want others to sign up to your site, set `allow_signups` in `production.rb` to `true` (_note this \*could\* make it possible for you to exceed your free-tier limits, especially given the SendGrid add-on's ceiling of 400 emails/month._)
  - Finally, in the dashboard... 
    - If you want to actually receive a daily quote by email, set `rake send_qotd_email` to run sometime in the wee hours of the AM (_careful with UTC offset; this may end up being like 9AM by scheduler-time if you're in e.g. CST/CDT_)
    - If you plan to add new quotes and would like them to be added in semi-randomized sequence to that email queue, set `rake populate_send_at_date_for_quotes` (_also likely best early in the AM, with the same UTC-offset caveat as above._)
    - If you set either of the above daily jobs, also set `curl #{my_heroku_app_url}` to run ~30 min after `rake send_qotd_email`, to wake up the web dyno (_and, by extension, its follower worker dyno... which will then pick up any newly-queued jobs._)