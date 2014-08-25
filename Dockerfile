FROM odino/docker-octopress

COPY . /src
WORKDIR /src
RUN bundle install
