---
layout: post
title: "The Pomodoro Tecnique on your Linux distro"
date: 2010-11-01 13:33
comments: true
categories: [Linux]
alias: "/243/the-pomodoro-tecnique-on-your-linux-distro"
---

Shortening the post - it's late and I'm tired - I've played with [Gambas2](http://gambas.sourceforge.net/en/main.html) and its wonderful IDE in order to get in touch with Desktop development, one of those things I've always missed as a programmer.
<!-- more -->

{% img right /images/pomodoro.jpg %}

So, in order to solve a dilemma I've always had with my ubuntu, I started - and finished - to develop a small applet based on the Pomodoro Tecnique.

The whole code is on GitHub.

## How does it work?

You can start a 25 minutes pomodoro, which will play a click/clock ring for its entire duration.

{% img center /images/pomodoro_start.png %}

In addition, in the last minute, a bell every 15 seconds will notice the upcoming end of the pomodoro.

After the 25 minutes the applet will "launch" a five minutes pause:

{% img center /images/pomodoro_pause.png %}

which will terminate asking you wheter to start another pomodoro or not.

## Available packages

Packages are available for:

* [Debian](/downloads/pomodoro/pomodorome_1.0.2-1_all.deb)
* [openSUSE](/downloads/pomodoro/pomodorome-1.0.2-1suse.noarch.rpm)
* [Mandriva](/downloads/pomodoro/pomodorome-1.0.2-1mdv.noarch.rpm)
* [Fedora/CentOS/RedHat](/downloads/pomodoro/pomodorome-1.0.2-1.noarch.rpm)
* [Ubuntu](/downloads/pomodoro/pomodorome-1.0.2-1.deb)

and I also provide an [executable](/downloads/pomodoro/pomodoro_me.gambas.zip), for those who already have the Gambas interpreter and don't want to install the whole package.

For Ubuntuers: the applet will be accessible from `Applications > Office`.
