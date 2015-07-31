---
layout: post
title: "Minimal docker : run your NodeJS app in <25mb of an image"
date: 2015-07-31 09:27
comments: true
categories: [docker, nodejs, javascript, linux, busybox, alpine]
---

{% img right /images/docker.png %}

Managing Docker images might become a bit of a painful
experience, especially when looking at your storages: very "simple"
images like [node](https://imagelayers.io/?images=node:latest)
end up quite fat and contribute to sucking up a good
chunck of your HDD.

At the same time, the most painful moment with Docker
images is, at least for me, when you want to pull
and run a brand new image, not available on your
machine (or production servers, not *much* difference):
you will need to wait until the whole image gets
downloaded before being able to play around with it{% fn_ref 1 %}.

At the end of the day, one thing is clear: we'd like
to [shrink](http://matthewkwilliams.com/index.php/2015/03/23/shrinking-docker-images/) [images](http://stackoverflow.com/questions/24394243/why-are-docker-container-images-so-large) [as much as possible](http://tuhrig.de/flatten-a-docker-container-or-image/).
Turns out, the easiest solution is, as often, the simplest one:
**start small, end small**.

There are plenty of resources on [limiting the size of your images / containers](https://www.google.ae/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=shrinking%20docker%20images),
but today I am going to start with this very simple approach.

<!-- more -->

## Busybox

{% img right /images/busybox.png %}

If you are not familiar with it, let me introduce [busybox](http://busybox.net/)
to you: a very tiny linux distribution (~2.5mb) which can be
summarized in "an OS with a bunch of bare-minimum binaries":
busybox is so well done that has been [dockerized](https://registry.hub.docker.com/_/busybox/)
and used quite extensively within the [docker ecosystem](https://registry.hub.docker.com/search?q=busybox).

The nice thing is that, being so small, busybox takes nothing to run:

```
~ (master ✔) ᐅ time docker run busybox whoami
Unable to find image 'busybox:latest' locally
latest: Pulling from busybox

6ce2e90b0bc7: Pull complete
8c2e06607696: Already exists
cf2616975b4a: Already exists
busybox:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.


Digest: sha256:38a203e1986cf79639cfb9b2e1d6e773de84002feea2d4eb006b52004ee8502d
Status: Downloaded newer image for busybox:latest
root
docker run busybox whoami  0.03s user 0.02s system 0% cpu 17.068 total
```

This is it, I downloaded and ran `whoami` on busybox in 17 seconds,
tethering from my phone{% fn_ref 2 %}.

The only problem with busybox is the following:

```
~ (master ✔) ᐅ docker run busybox apt-get update
exec: "apt-get": executable file not found in $PATH
Error response from daemon: Cannot start container 8030d68b740b0f48cb776500cdd1d4c6483ff2d04138e7d227c45d7cd514b75c: [8] System error: exec: "apt-get": executable file not found in $PATH
```

You got it, busybox is so bare that it only includes a
few binaries to let you play with{% fn_ref 3 %}:

```
~ (master ✔) ᐅ docker run busybox busybox
BusyBox v1.22.1 (2014-05-22 23:22:11 UTC) multi-call binary.
BusyBox is copyrighted by many authors between 1998-2012.
Licensed under GPLv2. See source distribution for detailed
copyright notices.

Usage: busybox [function [arguments]...]
   or: busybox --list[-full]
   or: busybox --install [-s] [DIR]
   or: function [arguments]...

	BusyBox is a multi-call binary that combines many common Unix
	utilities into a single executable.  Most people will create a
	link to busybox for each function they wish to use and BusyBox
	will act like whatever it was invoked as.

Currently defined functions:
	[, [[, addgroup, adduser, ar, arping, ash, awk, basename, blkid, brctl,
	bunzip2, bzcat, cat, catv, chattr, chgrp, chmod, chown, chroot, chrt,
	chvt, cksum, clear, cmp, cp, cpio, crond, crontab, cut, date, dc, dd,
	deallocvt, delgroup, deluser, devmem, df, diff, dirname, dmesg, dnsd,
	dnsdomainname, dos2unix, du, dumpkmap, echo, egrep, eject, env,
	ether-wake, expr, false, fdflush, fdformat, fgrep, find, fold, free,
	freeramdisk, fsck, fstrim, fuser, getopt, getty, grep, gunzip, gzip,
	halt, hdparm, head, hexdump, hostid, hostname, hwclock, id, ifconfig,
	ifdown, ifup, inetd, init, insmod, install, ip, ipaddr, ipcrm, ipcs,
	iplink, iproute, iprule, iptunnel, kill, killall, killall5, klogd,
	last, less, linux32, linux64, linuxrc, ln, loadfont, loadkmap, logger,
	login, logname, losetup, ls, lsattr, lsmod, lsof, lspci, lsusb, lzcat,
	lzma, makedevs, md5sum, mdev, mesg, microcom, mkdir, mkfifo, mknod,
	mkswap, mktemp, modprobe, more, mount, mountpoint, mt, mv, nameif, nc,
	netstat, nice, nohup, nslookup, od, openvt, passwd, patch, pidof, ping,
	pipe_progress, pivot_root, poweroff, printenv, printf, ps, pwd, rdate,
	readlink, readprofile, realpath, reboot, renice, reset, resize, rm,
	rmdir, rmmod, route, run-parts, runlevel, sed, seq, setarch,
	setconsole, setkeycodes, setlogcons, setserial, setsid, sh, sha1sum,
	sha256sum, sha3sum, sha512sum, sleep, sort, start-stop-daemon, strings,
	stty, su, sulogin, swapoff, swapon, switch_root, sync, sysctl, syslogd,
	tail, tar, tee, telnet, test, tftp, time, top, touch, tr, traceroute,
	true, tty, udhcpc, umount, uname, uniq, unix2dos, unlzma, unxz, unzip,
	uptime, usleep, uudecode, uuencode, vconfig, vi, vlock, watch,
	watchdog, wc, wget, which, who, whoami, xargs, xz, xzcat, yes, zcat
```

So, not having a package manager might be quite of a painful thing
if you need to run real world apps that need to rely on environments
such as python, nodejs and so on: we need to find another minimal
distribution that can give us a substantial help on that front.

## Alpine

{% img right /images/alpine.png %}

Alpine is a [busybox-based linux distribution on steroids](http://www.alpinelinux.org/):
it is gaining so much traction in the Docker ecosystem since it
has 2 features that, combined together, make it quite of a valuable
base image: it is [~5mb in size](https://registry.hub.docker.com/u/library/alpine/) and uses the [apk](http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management)
package manager.

So, of course, [people love it](https://registry.hub.docker.com/search?q=alpine):

```
~ (master ✔) ᐅ time docker run alpine apk --update add python
Unable to find image 'alpine:latest' locally
latest: Pulling from alpine

31f630c65071: Already exists
alpine:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.

Digest: sha256:c471fce1d08618adf4c6c0d72c047b9f3d5ef82cae0ca9a157ce1c800d42722f
Status: Downloaded newer image for alpine:latest
fetch http://dl-4.alpinelinux.org/alpine/v3.2/main/x86_64/APKINDEX.tar.gz
(1/9) Installing libbz2 (1.0.6-r3)
(2/9) Installing expat (2.1.0-r1)
(3/9) Installing libffi (3.2.1-r0)
(4/9) Installing gdbm (1.11-r0)
(5/9) Installing ncurses-terminfo-base (5.9-r3)
(6/9) Installing ncurses-libs (5.9-r3)
(7/9) Installing readline (6.3.008-r0)
(8/9) Installing sqlite-libs (3.8.10.2-r0)
(9/9) Installing python (2.7.9-r4)
Executing busybox-1.23.2-r0.trigger
OK: 45 MiB in 24 packages
docker run alpine apk --update add python  0.02s user 0.01s system 0% cpu 1:44.34 total
```

There you go: a super-shrunk python environment in less than 2 minutes, without
"dirtying" your own hardware.

## Your node app with Alpine

Once I discovered alpine I started wondering if I could run
some of my node apps on it -- which led me to this simple
[Dockerfile](https://github.com/odino/docker-node-alpine/blob/master/Dockerfile):

```
FROM alpine

RUN apk add --update nodejs
```

Nothing more, nothing less; at this point, let me create a [simple server](https://gist.github.com/odino/4f4dfdbd830e8ac3e2f0)
and run it through this image:

```
~/projects/gists/4f4dfdbd830e8ac3e2f0 (master ✔) ᐅ docker run -ti -v $(pwd):/src -p  8888:8888 odino/docker-node-alpine node /src/simple-server.js
Hello...
Hello...
Hello...
```

And what about the size of our image?

```
~/projects/gists/4f4dfdbd830e8ac3e2f0 (master ✔) ᐅ docker images | grep "node-alpine"
odino/docker-node-alpine   latest              e75f895e7cf6        6 days ago          22.51 MB
```

Quite sweet, less than 25mb!

(you can also use [imagelayers](https://imagelayers.io/) to compare
it to [other public Docker images](https://imagelayers.io/?images=node:latest,iojs:latest,odise%2Fbusybox-node:latest,smebberson%2Falpine-nodejs:latest,odino%2Fdocker-node-alpine:latest){% fn_ref 4 %})

## Conclusion

The easiest solution is always the simplest one: start from a very small
base image, add as you need:

* use Alpine when you can simply rely on a package manager
* use a full-blown image, for example, when you need to compile stuff or to use the uber-latest version of some library
* use busybox if you're the [emacs guy](https://xkcd.com/378/)

Personally, I think I will be experimenting a lot with Alpine in the
upcoming weeks: since we, at [Namshi](https://www.namshi.com), rely on
containers in all our apps{% fn_ref 5 %} it'd be quite intriguing to
test alpine in development and production environments.

{% footnotes %}
  {% fn Sure, Docker caches and re-uses layer, but the first time is always painful! %}
  {% fn A Samsung Galaxy S3, so quite lame of a phone as well... :) %}
  {% fn busybox is actually one binary that implements the usual unix commands like cat, etc etc %}
  {% fn I am quite sure someone has a smaller, more complete NodeJS image on the hub, just search for it %}
  {% fn Or, say, 90%  of them: there is still some legacy stuff... :) %}
{% endfootnotes %}
