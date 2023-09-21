FROM ruby:3.2.2

RUN mkdir -p /app

COPY ./Gemfile /app
COPY ./Gemfile.lock /app

WORKDIR /app

RUN bundle install

RUN rm /app/Gemfile
RUN rm /app/Gemfile.lock
