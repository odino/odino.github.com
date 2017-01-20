---
layout: post
title: "Connecting to the inflight internet on Emirates' flights"
date: 2016-02-11 09:00
comments: true
categories: [wifi]
description: Having troubles connecting to the internet on an emirates flight? 172.19.248.1 is the answer
---

It would really be hard for you to find this article useful because
you probably won't have internet to read this...

<!-- more -->

...but I'm going to share this anyhow, since I think the approach might
get you away with it in other occasions.

Once connected to the in-flight Wi-Fi network, I couldn't
connect to the usual login page from my browser -- the browser hangs,
the page keeps loading, the spinner keeps spinning, the wait keeps going...

I just gave a look at my syslog with the usual
`tail -50f /var/log/syslog` to see that my internet gateway
was `172.19.248.1`:

```
Feb 11 13:10:29 sunny NetworkManager[888]: <info>   address 172.19.248.93
Feb 11 13:10:29 sunny NetworkManager[888]: <info>   prefix 23 (255.255.254.0)
Feb 11 13:10:29 sunny NetworkManager[888]: <info>   gateway 172.19.248.1
Feb 11 13:10:29 sunny NetworkManager[888]: <info>   nameserver '8.8.8.8'
Feb 11 13:10:29 sunny NetworkManager[888]: <info>   nameserver '8.8.4.4'
Feb 11 13:10:29 sunny NetworkManager[888]: <info>   nameserver '172.19.248.1'
Feb 11 13:10:29 sunny NetworkManager[888]: <info>   domain name 'onboard'
```

Pasted that into the browser, and an HTML page suddenly appeared.
