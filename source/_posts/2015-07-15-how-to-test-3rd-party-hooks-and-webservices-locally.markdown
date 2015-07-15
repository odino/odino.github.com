---
layout: post
title: "How to test 3rd party hooks and webservices locally"
date: 2015-07-15 20:35
comments: true
categories: [ngrok, tools, webservice, testing, hooks]
---

In the past few months I have spent a bit of my spare time
helping [the Namshi team](http://tech.namshi.com/) build a
very small [NodeJS](https://nodejs.org/) app to trigger builds
of our projects through Github.

<!-- more -->

The main idea is that when someone pushes changes to
one of the github repos, we'd want to build a new docker image
with that code and push it to our private registry{% fn_ref 1 %}.

After laying down most of the app, time had come to test
the integration with Github's hooks, and I was left wondering
how easy it would have been to test this on my local machine,
without having to deploy the app somewhere where it would be
publicly accessible.

## ngrok to the rescue

Turns out that Github has a very good tutorial on [how to test
hooks locally](https://developer.github.com/webhooks/configuring/)
through a very interesting software, [ngrok](https://ngrok.com/).

Ngrok tunnels traffic from the internet to your local machine
through some black magic. Just [download it](https://ngrok.com/download)
and create a sample NodeJS server on your machine:

``` javascript
require('http').createServer(function(req, res){
  res.writeHead(200, {});
  res.end('Hello');
}).listen(8888);
```

Running it through `node server.js` will, of course, make it accessible at
`localhost:8888`.

Now, **the magic**: run `./path/to/ngrok http 8888`
and ngrok will tell you at what public address your server is now
available:

```
ngrok by @inconshreveable                                                                                                                                                                    (Ctrl+C to quit)

Tunnel Status                 online
Version                       2.0.19/2.0.19
Web Interface                 http://127.0.0.1:4040
Forwarding                    http://b8b939d0.ngrok.io -> localhost:8888
Forwarding                    https://b8b939d0.ngrok.io -> localhost:8888

Connections                   ttl     opn     rt1     rt5     p50     p90
                              1       1       0.01    0.00    59.49   59.49
```

{% img right /images/ngrok.png %}

Open `http://xxxx.ngrok.io` (of course, the address / hash will be
different everytime you launch ngrok) and you will now be able to access
your local service from the internet.

Icing on the cake: now, to test your application, you
can simply point the github hook to `xxxx.ngrok.io` and receive
hooks on your local machine.

{% footnotes %}
  {% fn As much as I don't like to re-invent the wheel, the builds on the dockerhub were a bit too slow and using stuff like codeship would have been a bit too expensive, so while we were using the Dockerhub we started developing this tool "for fun and profit" %}
{% endfootnotes %}
