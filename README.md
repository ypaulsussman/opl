# OPL (Other People's Lines)

In the autumn of 2019, I decided to earn a broader understanding of the main features Ruby on Rails provides.

I'm inherently wary of building [inert knowledge](https://en.wikipedia.org/wiki/Inert_knowledge), and all-too-familiar with [transfer of learning's](https://en.wikipedia.org/wiki/Transfer_of_learning) thorniness.

As such, I set out an experiment: I'd (_build a slightly-more-complex-than-CRUD app_) in parallel to (_reading through and, as appropriate, Ankifying the official [Rails Guides](https://guides.rubyonrails.org/)_).

I eventually settled on writing an app through which I could (_manage and routinely email myself_) quotes from a thousand-record plaintext file I'd been lackadaisically populating since my late... teens...

Shortly into the project, I realized two things:

1. \[_auth, full-text search, and frontend asset-management_\] would just never come easy to me w/o deliberate engagement; and

2. those RailsGuides are _hefty:_ lot of content in there!

As such, I expanded my initial "MVC and a bit more" app-blueprint to include each of those fields, too (_and, I'd hoped, better balance the coding-to-notetaking ratio._)

I'm writing this in ~~early~~ _late_ January 2020, and ~~by my private roadmap I'm maybe 2/3 of the way done.~~ 😅 [Hey, that went better than expected! Feature-complete(ish) is running on Heroku here.](https://itsopl.herokuapp.com/quotes) Just ping me if you want to access it as a user/manage daily emails: signup is [currently disabled](https://github.com/ypaulsussman/opl/blob/master/app/controllers/users_controller.rb#L18) because, hey, [toy-app budget](https://github.com/ypaulsussman/opl/blob/master/config/environments/production.rb#L42).

I've got a couple posts, mostly detailing my cost-benefit decisions on handrolling certain aspects vs incorporating specific gems, up at [ye olde miniblog.](https://www.suss.world/) Otherwise, should you want to play around on a copy of your own, read on...

## Setup for Local Development

- Install Ruby 2.6.7 and PostgreSQL 12
  - There's _probably_ some leeway with the PostgreSQL version, but Heroku and Bundler, at least, certainly won't like other versions of Ruby unless tell them to.
  - I recommend grabbing [Homebrew,](https://docs.brew.sh/Installation) then running
  - `brew install rbenv`
  - `rbenv init`
  - `rbenv install 2.6.5`
  - `brew install postgresql`
  - `brew services start postgresql`
- We deliberately want to [install foreman outside the app's bundle](https://github.com/ddollar/foreman/wiki/Don't-Bundle-Foreman) -- run `gem install foreman`
- Pull from GitHub with that beautiful green `Clone or download` button above
- `cd` into the directory; `bundle install` and `yarn install`
- `rails db:prepare` -- this is Rails 6, baby; we can get idempotent!
- _Possibly_ both `bundle exec rails webpacker:install` then `yarn install`, but likely just the latter: try it first
- Set up db extensions:
  - `psql opl_development`, then (from within the db client) run:
  - `opl_development=# select * from pg_available_extensions;`
  - `opl_development=# CREATE EXTENSION pgcrypto;`
- Create at least one admin account, via e.g.
  - `rails c`
  - `irb(main):001:0> User.create!(name: 'Whatever', email: 'acct_you_own@example.com', password: 'my_arbitrary_password', password_confirmation: 'my_arbitrary_password', admin: true, activated: true)` in console to create admin
- Finally, run `foreman start` to spin up your local version, and navigate to `http://localhost:5000/`!
- NB if you encounter a `No such file or directory @ rb_sysopen - tmp/pids/server.pid (Errno::ENOENT)`, then either
  - Run `rails s` once (and, upon hitting `localhost:3000`, exit) or
  - Manually `mkdir tmp/pids`.

## Setup for Remote Deployment

- `heroku create`
- `git push heroku master`
- `heroku run rake db:migrate`
- heroku addons:
  - `heroku addons:create sendgrid:starter`
  - `heroku addons:create scheduler:standard`
- Set `host` in `production.rb` to your own Heroku site
- If you want others to sign up to your site, set `allow_signups` in `production.rb` to `true` (_note this \*could\* make it possible for you to exceed your free-tier limits, especially given the SendGrid add-on's ceiling of 400 emails/month._)
- Finally, in the Heroku Scheduler dashboard...
  - If you want to actually receive a daily quote by email, set `rake send_qotd_email` to run sometime in the wee hours of the AM (_careful with UTC offset; this may end up being like 9AM by scheduler-time if you're in e.g. CST/CDT_)
  - If you plan to add new quotes and would like them to be added in semi-randomized sequence to that email queue, set `rake populate_send_at_date_for_quotes` (_also likely best early in the AM, with the same UTC-offset caveat as above._)
  - If you set either of the above daily jobs, also set `curl #{my_heroku_app_url}` to run ~30 min after `rake send_qotd_email`, to wake up the web dyno (_and, by extension, its follower worker dyno... which will then pick up any newly-queued jobs._)

## Setup for Super-Fancy (Local) Docker Usage

- Checkout the `docker-demo` branch
- Add the following keys to `config/database.yml`:

  ```yml
  default: &default  
    # ...
    host: <%= ENV['POSTGRES_HOST'] %>
    database: <%= ENV['POSTGRES_NAME'] %>
    port: <%= ENV['POSTGRES_PORT'] || 5432 %>
    username: <%= ENV['POSTGRES_USER'] %>
    password: <%= ENV['POSTGRES_PASSWORD'] %>
  ```

- Create a top-level `.env` file, and add:

  ```text
  POSTGRES_HOST=database
  POSTGRES_NAME=opl_development
  POSTGRES_USER=#{whatever_you_want}
  POSTGRES_PASSWORD=#{whatever_you_want}
  RAILS_ENV=development
  ```

- `docker-compose build`
- `docker-compose up`
- `docker-compose run web rails db:prepare`
- Navigate over to `localhost:3000`!

Note that, if you (_like me_) are developing on a mid-2010's MacBook Air, this version will run _significantly_ slower than the above native build. But hey, I had to know that I _could_ convert it over...
