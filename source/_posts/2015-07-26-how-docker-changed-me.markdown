---
layout: post
title: "How Docker changed me"
date: 2015-08-07 17:11
comments: true
categories: [docker, linux]
description: I decided to move as much as possible to containers, even for everyday tasks like browsing the internet
---

A lot of people blog about their experiences with
[Docker](https://www.docker.com/) and how it helps
them either running apps in production or easily
replicating development environments, so I won't
spend much time on that.

This post is about how docker changed the way
I think of my personal laptop which is, yes, used
to deploy containers to production and develop
apps through [docker-compose](https://docs.docker.com/compose/),
but also to blog and do a lot of personal stuff
with it.

<!-- more -->

## Dockerizing myself

A few weeks back I decided to format my [XPS](http://www.cnet.com/products/dell-xps-13-january-2013/)
in order to clean it up: I never had problems related
to its performances but, since the disk space on my
machine isn't much (128gb), I constantly had troubles
between Docker containers and my stuff on Dropbox{% fn_ref 1 %}.

Formatting and upgrading has never been easy: you
need to re-install a hella lot of packages from scratch
and configure your machine as it was: since I wanted
to find a simple way to automate this and I already had
some experience with Docker, I decided that the best
approach would be to simply get a list of all the packages
I had installed, trim it down to what I really needed
and manage everything else through containers.

## First off: get a list of packages you'll need

This one's pretty easy, you just need some bash voodoo:

```
comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u) | awk {'print  $0'}
```

This command will simply print a very handy list of packages
installed on your system:

```
~ (master ✔) ᐅ comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u) | awk {'print  $0'}
atom
build-essential
dropbox
flashplugin-installer
gimp
git
google-chrome-stable
guake
htop
lxc-docker
mysql-workbench
skype:i386
teamviewer:i386
vim
whois
zsh
```

This way I'll be able to understand what all I have put
on my machine and remove packages I don't need anymore:
I'm trying to keep this list as slim as possible and
move everything else through containers.

## Secondly, create containers for whatever you need

Here comes the nice part: need [ngrok](/how-to-test-3rd-party-hooks-and-webservices-locally/)
running locally? There's a [container](https://github.com/CenturyLinkLabs/docker-ngrok) for that!

But a container isn't the only thing that will make the trick,
as you still need to type something like
`docker run --rm --name ngrok -e "HTTP_PORT=8080" centurylink/ngrok`,
which is quite annoying: my approach is to then have basic bash functions
for all my containers, so that I don't "see" docker and simply run stuff
like it was natively running on my laptop:

``` bash .zshrc
ngrok () {
  docker run --rm -ti --name ngrok -e HTTP_PORT=$@ ngrok
}
```

At this point I can simply type `ngrok 8080` and forget
about how `ngrok` is running:

```
~ (master ✔) ᐅ ngrok 8080
[08/07/15 12:43:45] [INFO] Reading configuration file /.ngrok
[08/07/15 12:43:45] [INFO] [client] Trusting root CAs: [assets/client/tls/ngrokroot.crt]
[08/07/15 12:43:45] [INFO] [view] [web] Serving web interface on 127.0.0.1:4040
[08/07/15 12:43:45] [INFO] Checking for update
```

## Last but not least: some manual stuff

I didn't want to think of a decent way to dockerize
NodeJS / NPM / bower for when I need them for my
experiments, outside of a container, running on my
machine: you can still do that with an alias like
`docker run -ti -v $(pwd):/src node`, but I didnt
want to spend too much time thinking how to save
global modules in the same image without putting it
in the base Dockerfile etc etc (so that when I do
`npm install -g clusterjs` it will save it in the
image for future reuse).

So, for the moment, I still have node and all its
related tools running locally as well.

## At the end of it...

I have now created few "personal" containers,
though I'm planning to add them as I need them:

* [deployments through capistrano](https://github.com/odino/dev/tree/master/cap):
this [mounts my SSH keys inside the container](https://github.com/odino/dev/blob/2dc2b07c0fd88d2203faf4e75b3f014cf7c2f145/aliases#L5) and lets me deploy the [Namshi](https://www.namshi.com) apps
that we still deploy through capistrano (best is: I don't
need ruby, gems, bundler or whatever installed on my machine)
* [ngrok](https://github.com/odino/dev/tree/master/ngrok), to
expose local ports to the internet
* [a dev environment to play with (includes python and node)](https://github.com/odino/dev/tree/master/play)

This blog also runs on a [container](https://github.com/odino/odino.github.com/blob/source/Dockerfile), and the alias I
use is [here](https://github.com/odino/dev/blob/2dc2b07c0fd88d2203faf4e75b3f014cf7c2f145/aliases#L60).

As you might have noticed, I created a repo to facilitate all
of this stuff ([odino/dev](https://github.com/odino/dev)), so
that when I want to get my environment ready on my next machine
I will only{% fn_ref 2 %} need to clone this repo and run
`./build.sh`:

```
~/projects/dev (master ✔) ᐅ ./build.sh
Prerequisites:
* clone and compile node (with npm)
* install docker (https://blog.docker.com/2015/07/new-apt-and-yum-repos/) and have it running for yur user (https://docs.docker.com/installation/ubuntulinux/#optional-configurations-for-docker-on-ubuntu)
Please abort (you have 5 seconds) if this stuff ain't done!
Installing NPM modules:
You have 5 seconds to stop this operation...
/home/odino/local/node/bin/gulp -> /home/odino/local/node/lib/node_modules/gulp/bin/gulp.js
/home/odino/local/node/bin/bower -> /home/odino/local/node/lib/node_modules/bower/bin/bower
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/npm-package-arg requires semver@'4' but will load
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/semver,
npm WARN unmet dependency which is version 2.3.0
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/rimraf/node_modules/glob requires inflight@'^1.0.4' but will load
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/inflight,
npm WARN unmet dependency which is version 1.0.1
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/rimraf/node_modules/glob requires minimatch@'^2.0.1' but will load
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/minimatch,
npm WARN unmet dependency which is version 1.0.0
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/node-gyp/node_modules/glob requires inflight@'^1.0.4' but will load
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/inflight,
npm WARN unmet dependency which is version 1.0.1
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/read-installed/node_modules/readdir-scoped-modules requires graceful-fs@'^3.0.4' but will load
npm WARN unmet dependency /home/odino/local/node/lib/node_modules/npm/node_modules/graceful-fs,
npm WARN unmet dependency which is version 3.0.2
gulp@3.9.0 /home/odino/local/node/lib/node_modules/gulp
├── pretty-hrtime@1.0.0
├── interpret@0.6.5
├── deprecated@0.0.1
├── archy@1.0.0
├── minimist@1.1.3
├── tildify@1.1.0 (os-homedir@1.0.1)
├── v8flags@2.0.10 (user-home@1.1.1)
├── semver@4.3.6
├── chalk@1.1.0 (escape-string-regexp@1.0.3, supports-color@2.0.0, ansi-styles@2.1.0, strip-ansi@3.0.0, has-ansi@2.0.0)
├── orchestrator@0.3.7 (stream-consume@0.1.0, sequencify@0.0.7, end-of-stream@0.1.5)
├── gulp-util@3.0.6 (array-differ@1.0.0, array-uniq@1.0.2, lodash._reescape@3.0.0, beeper@1.1.0, lodash._reevaluate@3.0.0, lodash._reinterpolate@3.0.0, object-assign@3.0.0, replace-ext@0.0.1, vinyl@0.5.1, lodash.template@3.6.2, through2@2.0.0, multipipe@0.1.2, dateformat@1.0.11)
├── liftoff@2.1.0 (extend@2.0.1, rechoir@0.6.2, flagged-respawn@0.3.1, resolve@1.1.6, findup-sync@0.2.1)
└── vinyl-fs@0.3.13 (graceful-fs@3.0.8, strip-bom@1.0.0, defaults@1.0.2, vinyl@0.4.6, mkdirp@0.5.1, through2@0.6.5, glob-stream@3.1.18, glob-watcher@0.0.6)

bower@1.4.1 /home/odino/local/node/lib/node_modules/bower
├── is-root@1.0.0
├── junk@1.0.2
├── stringify-object@1.0.1
├── user-home@1.1.1
├── chmodr@0.1.0
├── abbrev@1.0.7
├── archy@1.0.0
├── opn@1.0.2
├── bower-logger@0.2.2
├── bower-endpoint-parser@0.2.2
├── graceful-fs@3.0.8
├── lockfile@1.0.1
├── lru-cache@2.6.5
├── nopt@3.0.3
├── retry@0.6.1
├── tmp@0.0.24
├── request-progress@0.3.1 (throttleit@0.0.2)
├── q@1.4.1
├── chalk@1.1.0 (escape-string-regexp@1.0.3, supports-color@2.0.0, ansi-styles@2.1.0, has-ansi@2.0.0, strip-ansi@3.0.0)
├── shell-quote@1.4.3 (array-filter@0.0.1, array-map@0.0.0, array-reduce@0.0.0, jsonify@0.0.0)
├── which@1.1.1 (is-absolute@0.1.7)
├── semver@2.3.2
├── p-throttler@0.1.1 (q@0.9.7)
├── fstream@1.0.7 (inherits@2.0.1)
├── bower-json@0.4.0 (intersect@0.0.3, deep-extend@0.2.11, graceful-fs@2.0.3)
├── promptly@0.2.0 (read@1.0.6)
├── mkdirp@0.5.0 (minimist@0.0.8)
├── fstream-ignore@1.0.2 (inherits@2.0.1, minimatch@2.0.10)
├── insight@0.5.3 (object-assign@2.1.1, lodash.debounce@3.1.1, async@0.9.2, os-name@1.0.3, tough-cookie@0.12.1)
├── tar-fs@1.8.1 (pump@1.0.0, tar-stream@1.2.1)
├── decompress-zip@0.1.0 (mkpath@0.1.0, touch@0.0.3, readable-stream@1.1.13, binary@0.3.0)
├── glob@4.5.3 (inherits@2.0.1, once@1.3.2, inflight@1.0.4, minimatch@2.0.10)
├── rimraf@2.4.2 (glob@5.0.14)
├── cardinal@0.4.4 (ansicolors@0.2.1, redeyed@0.4.4)
├── mout@0.11.0
├── bower-config@0.6.1 (osenv@0.0.3, graceful-fs@2.0.3, optimist@0.6.1, mout@0.9.1)
├── request@2.53.0 (caseless@0.9.0, aws-sign2@0.5.0, forever-agent@0.5.2, stringstream@0.0.4, oauth-sign@0.6.0, tunnel-agent@0.4.1, isstream@0.1.2, json-stringify-safe@5.0.1, node-uuid@1.4.3, qs@2.3.3, combined-stream@0.0.7, form-data@0.2.0, mime-types@2.0.14, http-signature@0.10.1, bl@0.9.4, tough-cookie@2.0.0, hawk@2.3.1)
├── github@0.2.4 (mime@1.3.4)
├── bower-registry-client@0.3.0 (graceful-fs@2.0.3, request-replay@0.2.0, rimraf@2.2.8, lru-cache@2.3.1, async@0.2.10, mkdirp@0.3.5, request@2.51.0)
├── update-notifier@0.3.2 (is-npm@1.0.0, string-length@1.0.1, semver-diff@2.0.0, latest-version@1.0.1)
├── inquirer@0.8.0 (figures@1.3.5, ansi-regex@1.1.1, mute-stream@0.0.4, through@2.3.8, readline2@0.1.1, chalk@0.5.1, lodash@2.4.2, rx@2.5.3, cli-color@0.3.3)
├── configstore@0.3.2 (object-assign@2.1.1, xdg-basedir@1.0.1, uuid@2.0.1, osenv@0.1.3, js-yaml@3.3.1)
└── handlebars@2.0.0 (optimist@0.3.7, uglify-js@2.3.6)
Manually installing some packages:
You have 5 seconds to stop this operation...
[sudo] password for odino:
Reading package lists... Done
Building dependency tree
Reading state information... Done
build-essential is already the newest version.
gimp is already the newest version.
vim is already the newest version.
whois is already the newest version.
zsh is already the newest version.
guake is already the newest version.
htop is already the newest version.
keepassx is already the newest version.
mysql-workbench is already the newest version.
git is already the newest version.
flashplugin-installer is already the newest version.
dropbox is already the newest version.
google-chrome-stable is already the newest version.
skype:i386 is already the newest version.
atom is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 3 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
Package 'thunderbird' is not installed, so not removed
0 upgraded, 0 newly installed, 0 to remove and 3 not upgraded.
Creating docker images:
You have 5 seconds to stop this operation...
BUILDING DOCKER IMAGE play
Sending build context to Docker daemon 2.048 kB
Sending build context to Docker daemon
Step 0 : FROM alpine
 ---> 31f630c65071
Step 1 : RUN apk add --update wget curl net-tools python nodejs
 ---> Using cache
 ---> 2eeb0a0ef349
Step 2 : RUN wget https://bootstrap.pypa.io/get-pip.py
 ---> Using cache
 ---> 78725d89fba9
Step 3 : RUN python get-pip.py
 ---> Using cache
 ---> fd735c51db07
Step 4 : RUN npm install -g lodash nodemon
 ---> Using cache
 ---> e21b10071701
Step 5 : COPY . /root
 ---> Using cache
 ---> 65bd0eb15552
Step 6 : CMD sh
 ---> Using cache
 ---> 5f2b1c8d4c49
Successfully built 5f2b1c8d4c49
BUILDING DOCKER IMAGE ngrok
Sending build context to Docker daemon 2.048 kB
Sending build context to Docker daemon
Step 0 : FROM centurylink/ngrok
 ---> cc659eb07d3f
Successfully built cc659eb07d3f
BUILDING DOCKER IMAGE cap
Sending build context to Docker daemon 4.096 kB
Sending build context to Docker daemon
Step 0 : FROM ruby:2.0
 ---> 90986d8f1fb8
Step 1 : RUN gem install capistrano -v 2.15.5
 ---> Using cache
 ---> 018127882b81
Step 2 : RUN gem install hipchat capistrano-slack-notify capifony -V
 ---> Using cache
 ---> b206b90efbdb
Step 3 : RUN mkdir /root/.ssh
 ---> Using cache
 ---> 130eb02d5e29
Step 4 : WORKDIR /src
 ---> Using cache
 ---> b73756babee9
Step 5 : COPY . /root
 ---> Using cache
 ---> fa71b45ad026
Step 6 : RUN chmod +x /root/init.sh
 ---> Using cache
 ---> d7bc97503855
Step 7 : CMD /root/init.sh && bash
 ---> Using cache
 ---> f5d9a3ee15da
Successfully built f5d9a3ee15da
Manually installing atom's extensions:
You have 5 seconds to stop this operation...
Installing docblockr to /home/odino/.atom/packages ✓
Configuring git:
You have 5 seconds to stop this operation...
All done!
```

Start moving stuff to "personal" containers, avoid polluting
your machine and live a happier life: we finally have a way
to keep our hardware very much separated from our tools, something
very hard to do without docker{% fn_ref 3 %}.

{% footnotes %}
  {% fn I used to run sudo baobab every other day... :) %}
  {% fn Almost "only" :) %}
  {% fn You can do the same exact stuff with Vagrant or any other VM manager but, at the end of the day, how heavier and less straightforward would that be? %}
{% endfootnotes %}