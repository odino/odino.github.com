---
layout: post
title: "Book review: Designing Distributed Systems"
date: 2019-01-25 14:03
comments: true
categories: [book, review, kubernetes, distributed systems]
description: "A quite informative read by Brendan Burns, one of kubernets' fathers."
---

{% img right /images/book-cover-designing-distributed-systems.png %}

This was a fairly quick and informative read, one that maybe dosn't *fully*
justify its price, currently trending at around $30 from Amazon.

At the end of the day, though, I'm happy with my choice and certainly
cannot complain, as the book gave me a couple interesting ideas / 
perspectives that I would have missed otherwise -- and I was pretty
excited to read [Brendan Burns](https://www.linkedin.com/in/brendan-burns-487aa590/)' take, one of Kubernetes' fathers,
on distributed systems. 

<!-- more -->

The book mostly covers basic topics around distributed systems, and
pulls Kubernetes in when it comes down to examples: some have complained
that this feels like a k8s book rather than a book on distributed systems,
but I would argue that given the state of k8s within the ecosystem
(clear leader by far, far away) it only seems fitting to use it when
it comes to getting your hands dirty. If you, like me, also appreciate
the design and primitives k8s offers, then you're going to enjoy this
part as well.

At the end of the day, as I mentioned, the price is a bit steep for a book
that would take 3/4h to complete, but it's one of those reads I'm glad 
to have gone through, even if a tad overpriced.

Some interesting quotes from the book:

{% blockquote %}
Simply proxying traffic into an existing application is not the only use for a sidecar. Another common example is configuration synchronization.
{% endblockquote %}

{% blockquote %}
If a microservices architecture is made up of well-known patterns, then it is easier to design because many of the design practices are specified by the patterns.
{% endblockquote %}

{% blockquote %}
Often, session tracking is accomplished via a consistent hashing function. The benefit of a consistent hashing function becomes evident when the service is scaled up or down. Obviously, when the number of replicas changes, the mapping of a particular user to a replica may change. Consistent hashing functions minimize the number of users that actually change which replica they are mapped to, reducing the impact of scaling on your application.
{% endblockquote %}

{% blockquote %}
You might wonder why we include a v1 in the API definition. Will there ever be a v2 of this interface? It may not seem logical, but it costs very little to version your API when you initially define it. Refactoring versioning onto an API without it, on the other hand, is very expensive. Consequently, it is a best practice to always add versions to your APIs even if you’re not sure they will ever change. Better safe than sorry.
{% endblockquote %}

{% blockquote %}
Given implementations of the two container interfaces described previously, what is left to implement our reusable work queue implementation? The basic algorithm for the work queue is fairly straightforward: Load the available work by calling into source container interface. Consult with work queue state to determine which work items have been processed or are being processed currently. For these items, spawn jobs that use the worker container interface to process the work item. When one of these worker containers finishes successfully, record that the work item has been completed. While this algorithm is simple to express in words, it is somewhat more complicated to implement in reality. Fortunately for us, the Kubernetes container orchestrator contains a number of features that make it significantly easier to implement. Namely, Kubernetes contains a Job object that allows for the reliable execution of the work queue. The Job can be configured to either run the worker container once or to run it until it completes successfully. If the worker container is set to run to completion, then even if a machine in the cluster fails, the job will eventually be run to success. This dramatically simplifies the task of building a work queue because the orchestrator takes on responsibility for the reliable operation of each work item. Additionally, Kubernetes has annotations for each Job object that enable us to mark each job with the work item it is processing. This enables us to understand which items are being processed as well as those that have completed in either failure or success.
{% endblockquote %}

Adios!