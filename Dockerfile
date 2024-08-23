FROM ruby:3.3.3

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    nodejs yarn build-essential libpq-dev imagemagick git-all nano

COPY Gemfile Gemfile.lock ./

ENV INSTALL_PATH /one_bit_exchange

ENV BUNDLE_PATH /gems

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

RUN gem install bundler

RUN gem install rails -v 7.1.3.4

COPY . .