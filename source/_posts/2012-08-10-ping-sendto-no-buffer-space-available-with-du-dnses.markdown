---
layout: post
title: "ping: sendto: No buffer space available with DU DNSes"
date: 2012-08-10 13:03
comments: true
categories: [UAE, DNS]
published: true
---

Today I faced I pretty weird issue, having
no internet connection since last night.

<!-- more -->

Chrome is telling me that the DNS lookup
failed, and since I know, here in UAE,
problems with [DU](http://www.du.ae/en/default?gclid=COC_7Jvd3LECFUp76wodgB0Apg) DNSes are pretty frequent,
I thought I just needed to use different DNS
servers.

Unfortunately, openDNS wasnt solving my
issues, and when I tried with the infamous
Google Public DNS ( `8.8.8.8` and `8.8.4.4` )
without any good feedback, I thought it could be
something out of my jurisdiction :)

Pissed off, I told myself to try to ping the DNS
servers manually:

``` bash
ping 8.8.4.4          
PING 8.8.4.4 (8.8.4.4): 56 data bytes
ping: sendto: No buffer space available
ping: sendto: No buffer space available
```

So now things are interesting: the `No buffer space available`
tells me that there is something seriously
weird going on today - never seen before.

With a quick search I'm able to fix the problem:
seems that I need to shutdown the interface
itself.

First, I needed to retrieve the interface used:

``` bash
sudo route -n get 8.8.8.8

   route to: 8.8.8.8
destination: 8.8.8.8
    gateway: 10.168.10.221
  interface: tun0
      flags: <UP,GATEWAY,HOST,DONE,WASCLONED,IFSCOPE,IFREF>
 recvpipe  sendpipe  ssthresh  rtt,msec    rttvar  hopcount      mtu     expire
       0         0         0         0         0         0      1500         0 
```

then it's a simple matter of:

``` bash
sudo ifconfig tun0 down
sudo ifconfig tun0 up
```

DNS working as expected and the connection is back.