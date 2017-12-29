---
layout: post
title: "Unix goodies to the rescue - Vol.2"
date: 2017-12-08 19:20
comments: true
categories: [linux, unix, bash, shell]
description: "2nd edition of my personal unix faves: tools I couldn't live without."
published: true
---

A couple years ago I wrote a post presenting a few [unix commands that save me on
a daily basis](/4-unix-goodies-i-cannot-live-without/), and I thought it's probably
time to expand on that lists and add stuff I've grown fond of over the past few years.

<!-- more -->

## Locating a binary

I just downloaded an updated version of [terraform](https://www.terraform.io/) and I want to replace the old one I
have in my system. The problem is...I can't remember where I placed it, and my
`$PATH` looks very confusing:

```
~ ᐅ echo $PATH
/usr/local/heroku/bin:/home/alex/local/bin:/home/alex/bin:/home/alex/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/go-1.9/bin:/bin:/home/alex/Downloads:/home/alex/Downloads/google-cloud-sdk/bin:/usr/local/sbin:/usr/local/bin:/home/alex/local/node/bin:/home/alex/projects/go/bin:/home/alex/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/alex/.rvm/gems/ruby-2.0.0-p195/bin:/home/alex/.rvm/gems/ruby-2.0.0-p195@global/bin:/home/alex/.rvm/rubies/ruby-2.0.0-p195/bin:/home/alex/.rvm/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/alex/.rvm/bin:/home/alex/.rvm/bin:/home/alex/.rvm/bin:/home/alex/.rvm/bin
```

Fear no more, as `which` can be used to instantly locate binaries:

```
~ ᐅ which terraform
/home/alex/bin/terraform

~ ᐅ mv ./new-terraform $(which terraform)
```

If your script is, for example, a bash script, you can even edit it by just `vi $(which $SCRIPT)`.

## awk

Once an *awk-er*, always an awk-er.

I find myself using awk mostly when I need to run bash commands based on the input of
another command. For example, let's say I want to ping all hosts that are mapped to
`127.x.x.x` from my `/etc/host`:

```
~ ᐅ cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	puma

# minikube
192.168.99.100 kube.local

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

~ ᐅ cat /etc/hosts | grep 127 | awk '{print "ping -c 1 " $2}'
ping -c 1 localhost
ping -c 1 puma

~ ᐅ cat /etc/hosts | grep 127 | awk '{print "ping -c 1 " $2}' | bash
PING localhost (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.076 ms

--- localhost ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.076/0.076/0.076/0.000 ms
PING puma (127.0.1.1) 56(84) bytes of data.
64 bytes from puma (127.0.1.1): icmp_seq=1 ttl=64 time=0.051 ms

--- puma ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.051/0.051/0.051/0.000 ms
```

I was introduced to awk ~8 years ago, when SVN was still a thing -- if I remember correctly,
SVN did not allow an "add all" like git (`git add .`), so you had to mark all files you
wanted to commit separately, and that's when awk started to become handy.

## Do I have to type it all over AGAIN?

How many times have you found yourself in the middle of a long-ass command when you
realize you need to run something else before that? Are you going yo throw away all
you've typed so far?

Well, add a comment to that command, press enter and re-run it later on:

```
~ ᐅ #cat /etc/hosts | grep 127 | awk '{print "ping -c 1 " $2}' | bash

~ ᐅ echo "127.0.0.1 noplacelikehome.com" >> /etc/hosts

~ ᐅ cat /etc/hosts | grep 127 | awk '{print "ping -c 1 " $2}' | bash
PING localhost (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.091 ms

--- localhost ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.091/0.091/0.091/0.000 ms
PING puma (127.0.1.1) 56(84) bytes of data.
64 bytes from puma (127.0.1.1): icmp_seq=1 ttl=64 time=0.060 ms

--- puma ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.060/0.060/0.060/0.000 ms
PING noplacelikehome.com (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.039 ms

--- noplacelikehome.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.039/0.039/0.039/0.000 ms
```

Oversimplifying: when you hit enter in the terminal you end up running a bash one-liner,
so if you prepend `#` to the command, it will simply be executed as a comment -- but will
still be saved in your history.

## Decoding base64 text

If you, like me, end up dealing with base64 input (k8s' secrets anyone?) it could
be really handy to just decode it on the fly through a pipe:

```
~ ᐅ echo MTIzNAo= | base64 -d
1234
```

## Repeating a command

This is a glorified version of a for loop, but `repeat` comes really handy sometimes:

```
~ ᐅ repeat 1000 echo hello && sleep 1
hello
hello
hello
^C%
```

I generally use this as a poor man's benchmarking tool when I want to generate little
traffic on an endpoint (eg. a staging service) and compare pre/post some changes (It's
not a benchmarking tool but gives you a good idea early on without having to go through
[vegeta](https://github.com/tsenart/vegeta) or similar stuff.

## Sleeping forever

Sometimes you want to be able to halt a program indefinitely, or until a `ctrl+c` kicks
in.

You could use a while loop and a sleep or, on some systems, simply sleep forever:

```
~ ᐅ sleep infinity

(black hole here)
```

Worth to note that infinity is only available on a few linux systems (I think both ubuntu
and debian support it but, for example, alpine doesn't) so you might have to end up using
a while loop for portability.

## Waiting for background tasks

This is something I've been using in bash scripts, when I want to run things in
parallel and be able to do some other work once all of them are done (think, for example,
of backing up several mysql tables in parallel and then move them to s3 in one go) --  you can simply
move processes to the background and `wait` for them to finish:

```
~ ᐅ echo "start"; sleep 1 & sleep 2 & sleep 3 & echo "scheduled"; wait; echo "done"
start
[1] 5922
[2] 5923
[3] 5924
scheduled
[1]    5922 done       sleep 1
[2]  - 5923 done       sleep 2
[3]  + 5924 done       sleep 3
done
```
