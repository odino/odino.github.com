---
layout: post
title: "Cannot connect to the internet from your Docker containers?"
date: 2015-02-06 00:54
comments: true
categories: [docker, containers, network]
published: true
description: Ever experienced problem connecting to the internet from a docker container? Let's fix it!
---

Stuck trying to figure out what's up with
your containers, as they cannot seem to be
able to access the network?

<!-- more -->

Well, that happened to a few of us at
[Namshi](http://tech.namshi.com) in the
past couple of days.

The good news is that you can clearly verify
that something is just wrong with Docker by
simply pinging `google.com` from your host
and a simple container:

```
$ ping google.com
PING google.com (173.194.124.7) 56(84) bytes of data.
64 bytes from 173.194.124.7: icmp_req=1 ttl=56 time=11.1 ms
64 bytes from 173.194.124.7: icmp_req=2 ttl=56 time=13.2 ms
...

$ docker run -ti ubuntu ping google.com
# BLACK HOLE
```

If you happen to get stuck in this kind of
situation, you might want to look into what
DNS server Docker is actually using to let
your containers resolve onto the internet.

In our case, we realized our firewall was
acting pretty weirdly with Google's public
DNSes (`8.8.8.8` and `8.8.4.4`), which happen
to be the default ones Docker is gonna use in
case you don't have anything custom specified
in your `resolv.conf` and so on.

The issue, overall, was quite easy to circumvent,
as we just told docker to use OpenDNS in our
`/etc/default/docker`:

```
# Docker Upstart and SysVinit configuration file

# Use DOCKER_OPTS to modify the daemon startup options.
DOCKER_OPTS="--dns 208.67.222.222 --dns 208.67.220.220"
```

Then, you will only need to restart the Docker
demon and everything should be fine:

```
$ sudo service docker restart  
docker stop/waiting
docker start/running, process 26999

$ docker run ubuntu ping google.com   
PING google.com (173.194.124.2) 56(84) bytes of data.
64 bytes from 173.194.124.2: icmp_seq=1 ttl=55 time=11.4 ms
64 bytes from 173.194.124.2: icmp_seq=2 ttl=55 time=11.2 ms
...
```

Hope this helps! To be honest we've googled
around and found out that there might be [some](https://github.com/docker/docker/issues/490)
[other](http://stackoverflow.com/questions/23810845/i-cant-get-docker-containers-to-access-the-internet),
[creepier](https://github.com/docker/docker/issues/866#issuecomment-19218300),
issues that might cause the problem, so I'd
really hope yours is just as silly as the one
I've faced.
