FROM ruby:2.6.5
ENV APP_HOME /opl

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Installation of dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    # Needed for gems w native extensions
    build-essential \
    # Needed for postgres gem
    libpq-dev \
    postgresql-client \
    # needed for javascript
    nodejs \
    yarn=1.21.1-1 \
    # vim
    vim \
  # Remove unneeded data to minimize image size
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /tmp/ \
    /var/cache/apt/archives \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log \
    /var/tmp/

# Create a directory for our application
# and set it as the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install gems, if not present
ADD Gemfile Gemfile.lock $APP_HOME/
RUN gem install bundler -v 2.1.4
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install

# Install node packages, if not present
COPY package.json yarn.lock $APP_HOME/
RUN yarn install --check-files

# Copy over application code
ADD . $APP_HOME

# Default command: run the app
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
