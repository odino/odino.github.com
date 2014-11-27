---
layout: post
title: "3 deployments a day: how we are doing it, why it rocks and how it still sucks"
date: 2014-11-12 02:24
comments: true
categories: [Namshi, tech, team]
published: false
---

In the last 6 months our tech team at [Namshi](http://namshi.com)
has deployed to our live environments roughly ~600 times, which
makes it up for around 3 deployments a day.

You won't even imagine where we started from, so I would
like to briefly recap our experience with various deployment
strategies.

<!-- more -->

## Where we come from

{% img right /images/legacy-deployment.png %}

When I joined Namshi, in April 2012, **deployments happened
via email**.

If you are thinking "*oh that's cool, you guys
had an automated system that woule receive those emails
and deploy*" you're **totally mistaken**: the way we
used to deploy was by sending an email to our (remote)
team of sysadmins so that they could SSH into the live
machines and run the deployments script with the tag
I would have specified in my email.

We've come a long way, from (finally) getting access to
the live machines to moving to capistrano (and atomic 
docker deployments, recently), which has eased our way
big time.

Of course, the way we used to deploy in Namshi's prehistory
was totally screwed up as:

* it put a burden on our sysadmins to be available whenever we needed to deploy
* was totally inefficient, as TTLIVE (time-to-live) was higher and debugging a failed deployment, without access to the machine, was a real pain

By moving to a SOA we started integrating new components in
our architecture, like Symfony2, inheriting their
deployment tools: enter capistrano, which we started using
for both Symfony2 and JS apps (both client and server side).

## Sprints

1 deploy a week

## Move fast and deploy faster

split deployments, earlybird

## It still sucks

amazon every 6s, need to find a way for automated deployments
