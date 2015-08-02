---
layout: post
title: "How Docker changed me"
date: 2015-08-01 19:08
comments: true
categories: [docker, linux]
published: false
---

A lot of people blog about their experiences with
[Docker](https://www.docker.com/) and how it helps
them either running apps in production or easily
replicating development environments, so I won't
spend much time on that.

This is post is about how docker changed the way
I think of my personal laptop which is, yes, used
to deploy containers to production and develop
apps through [docker-compose](https://docs.docker.com/compose/),
but also to blog and do a lot of personal stuff
with it.

So yes, this is my review of **dockerizing myself**.

<!-- more -->

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
keepassx
lxc-docker
mysql-workbench
skype:i386
teamviewer:i386
vim
whois
zsh
```

## Secondly, create containers for whatever you need

Here comes the magical part: need [ngrok](/how-to-test-3rd-party-hooks-and-webservices-locally/)
running locally? There's a [container](https://github.com/CenturyLinkLabs/docker-ngrok) for that!

But a container isn't the only thing that will make the trick,
as you still need to type something like `docker run --rm --name ngrok -e "HTTP_PORT=8080" centurylink/ngrok`,
which is quite annoying: my approach is to then have bash functions
for all my containers, so that I don't "see" docker and run stuff
like it was natively running on my laptop:

```
ngrok () {
  docker run --rm -ti --name ngrok -e HTTP_PORT=$@ ngrok
}
```

so then I can simply run `ngrok 8080`.

## Last but not least: some manual stuff

I didn't want to think of a decent way to dockerize
NodeJS / NPM / bower for when I need them for my
experiments, outside of a container, running on my
machine: you can still do that with something like:

## At the end of it...

dev repo

{% footnotes %}
{% fn I used to run sudo baobab every other day... :) %}
{% endfootnotes %}
