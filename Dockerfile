# See https://github.com/ledermann/docker-rails/blob/develop/Dockerfile
FROM ruby:2.6.5-alpine

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    imagemagick \
    nodejs \
    yarn \
    tzdata \
    git 

COPY Gemfile* /usr/src/app/
COPY package.json /usr/src/app/
COPY yarn.lock /usr/src/app/
WORKDIR /usr/src/app

ENV BUNDLE_PATH /gems

RUN bundle install
RUN yarn install --check-files

COPY . /usr/src/app/

CMD ["bundle", "exec", "guard", "-i"]
