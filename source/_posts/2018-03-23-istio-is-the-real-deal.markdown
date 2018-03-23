---
layout: post
title: "Istio is the real deal"
date: 2018-03-23 14:06
comments: true
categories: [kubernetes, cloud native, istio, microservices]
---

I don't generally spend time blogging (or bragging) about technologies I don't
use in production, but today I wanted to make sure [Istio](https://gist.github.com/odino/7ce4dc3bb77d6282b2f2aaf1050c29e3) gets a special mention on
this blog.

<!-- more -->

The original problem was: how do I package and run apps with ease? And Docker came.

Then it was a matter of how do we organize all of these containers. And Kubernetes came.

Last but not least, we now have to sort out how to make services communicate
to each other, how to route them conditionally and secure this layer of communication.
That's where Istio, a [service mesh](https://buoyant.io/2017/04/25/whats-a-service-mesh-and-why-do-i-need-one/) for microservices developed [Google, IBM and Lyft](https://developer.ibm.com/dwblog/2017/istio/), kicks in.

Some of the cool things you can do with this service mesh?

* [rate limiting](https://istio.io/docs/tasks/policy-enforcement/rate-limiting.html)
* [circuit breakers](https://istio.io/docs/concepts/traffic-management/handling-failures.html)
* [auto-retry API calls](https://istio.io/docs/concepts/traffic-management/rules-configuration.html#timeouts-and-retries)
* [canary releases](https://istio.io/blog/2017/0.1-canary.html)
* [JWT authn/authz](https://istio.io/docs/reference/config/istio.mixer.v1.config.client.html#JWT)

...and much, much more.

I'll leave you with this talk by Kelsey Hightower -- I'm sure that, with time,
Istio will blow your mind:

<iframe width="860" height="615" src="https://www.youtube.com/embed/s4qasWn_mFc" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
