FROM odino/docker-octopress

RUN apt-get update
RUN apt-get install -y python-pip ssh git
RUN pip install Pygments
RUN git config --global user.email "alessandro.nadalin@gmail.com"
RUN git config --global user.name "odino"

COPY . /src
WORKDIR /src
ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
RUN bundle install
CMD /bin/bash
