FROM ubuntu:14.04

MAINTAINER alessandro nadalin <alessandro.nadalin@gmail.com>

# update OS
RUN apt-get update
RUN apt-get upgrade -y

# Install depndencies
RUN apt-get install -y build-essential ruby1.9.1-dev

COPY . /src

# Install Octopress dependencies
WORKDIR /src
RUN gem install bundler
RUN gem install RedCloth -v '4.2.9'
RUN bundle install

# Expose default Octopress port
EXPOSE 4000

CMD export LC_ALL=en_US.UTF-8 && rake preview
