---
layout: post
title: "Google's Kubernetes explained to humans"
date: 2015-08-14 10:19
comments: true
categories: [microservices, soa, kubernetes]
published: false
---

{% img right /images/kubernetes-logo.png %}

[Kubernetes' the Next Big Thing](http://kubernetes.io/):
Google has created an amazing orchestration platform
for container-based microservices and just
[launched version 1.0 at Oscon](http://www.oscon.com/open-source-2015/public/schedule/detail/45281).

If you have been playing with Docker in the past
couple years, you probably stumbled upon the problem
of orchestrating your infrastructure in a way that
makes it easy for services to discover each
other ([service discovery](http://jasonwilder.com/blog/2014/02/04/service-discovery-in-the-cloud/)),
be replicated within a cluster and scale rapidly
without much manual intervention: for your joy,
**Kubernetes does all of this** in a very simple
but structured and robust way.

As of today, the only problem I see with Kubernetes
(or `kube` or `k8s`) is that newcomers might get
scared of the "new" concepts it introduces and the jargon
it uses, as some terms (like *pods* or *replication controllers*)
are hard to grasp for someone who doesn't get the whole
picture at first.

This week, [we](https://www.namshi.com) started working
on integrating our [hubot-based chat bot](https://hubot.github.com/)
with Kube and I wanted to give an overview of the platform
to a couple of engineers that are going to be working on
this: since many more people might benefit of understanding
the basic concepts behind Kubernetes, I'm writing this
article to share the approach I used to **explain Kube to humans**.

<!--  more -->

## Welcome to the party!

{% img right /images/food-festival.jpg %}

Imagine that you have to organize a very big food festival
in your town's biggest park that will gather thousands of
people together to taste food from different regions of your
country: the festival is your [SOA](https://en.wikipedia.org/wiki/Service-oriented_architecture)
and the people who are going to attend it are the clients
that are going to consume your different services.

You are faced with the complicated task of organizing this
massive event so you decide to break the problem down into
3 parts:

* figure out how to organize the stands ([pods](https://cloud.google.com/container-engine/docs/pods/))
* decide where to lay the stands and make sure you can add / remove them based on the influx of people ([replication controllers](https://cloud.google.com/container-engine/docs/replicationcontrollers/))
* give people directions on how to easily reach the stands they're interested into ([services](https://cloud.google.com/container-engine/docs/services/))

This seems a good overall design: you broke your initial problem into
3 smaller sub-problems and keep responsibilities separate among the
members of your staff -- some will manage the stands, some will be dedicated
to making sure people can reach the festival and so on.

You are the main actor behind this orchestration, the master of the event:
this is exactly [what the word Kubernetes means](http://classic.studylight.org/lex/grk/view.cgi?number=2942).

## Set the first stands up

You got the park (which, in real world, would probably mean installing
kube on a set of [AWS machines](https://aws.amazon.com/), or through
the [Google Container Engine](https://cloud.google.com/container-engine/))
and start to plan which stands will be part of your festival: the first
2 that come to your mind are a live BBQ station and another stand that
primarily serves different types of cheese.

{% img left /images/cheese-stand.jpg %}

Now, setting up the cheese stand is quite simple: you only need to get
the food on the table and you're done; in terms of our Service-Oriented
Architecture, this would mean that you have a small container running
on its own, without too many complications or external dependencies
to other services.

Now, the tricky part kicks in: organizing the live BBQ station is quite
more problematic as you will need to first get the meat, bring a large
grill next to the stand and some gas tanks. Last but not least, the municipality
informed you that you will also need to comply to some basic safety rules,
which means you will need to get some fire extinguisher else you won't
be allowed to grill anything.

{% img center /images/bbq.jpg %}

There you go: in our architecture this would be a container that needs
some other "utility" containers running next to it. Utility containers
could be providing authentication, sharing a volume or have similar responsibilities
that you don't want to put in the "main" container, to avoid bloating it.

In Kubernetes' terms, these stands are called [pods](https://cloud.google.com/container-engine/docs/pods/):
a list of co-located containers that usually provide one functionality to
the architecture. Just like the food stands serve a specific part / niche
of the festival, pods are going to be running a specific functionality of
your architecture, ie. your frontend, your cache layer or your
user signup logic.

One important thing to understand is that pods might be made of **multiple containers**
(this is why I used the term *co-located*): just like the BBQ stand needs
the stand, the meat, the grill and the fire extinguisher, your user signup
pod might need the main container with the application's logic, a
[data volume container](https://docs.docker.com/userguide/dockervolumes/#creating-and-mounting-a-data-volume-container)
and an [ambassador container](https://docs.docker.com/articles/ambassador_pattern_linking/) to connect to the DB.

**You solved the first problem on your list**: you created  the list of stands
and realized that each of them will need different parts to work. You noted
those parts down and are ready to set the stands in the park.

## Plan and scale accordingly

## Get everyone in!

## Are all of these new concepts?

No, at all -- quoting Kube's documentation:

{% blockquote Kubernetes' pods https://cloud.google.com/container-engine/docs/pods/ %}
A pod models an application-specific "logical host" in a containerized environment. It may contain one or more containers which are relatively tightly coupled —- in a pre-container world, they would have executed on the same physical or virtual host.

Like running containers, pods are considered to be relatively ephemeral rather than durable entities. Pods are scheduled to nodes and remain there until termination (according to restart policy) or deletion. When a node dies, the pods scheduled to that node are deleted. Specific pods are never rescheduled to new nodes; instead, they must be replaced.
{% endblockquote %}

## What to do from here?
