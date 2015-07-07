FROM odino/docker-octopress

RUN apt-get update
RUN apt-get install -y python-pip ssh git
RUN pip install Pygments

COPY . /src
WORKDIR /src
ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
RUN bundle install
CMD /bin/bash
