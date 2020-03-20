---
layout: post
title: "Book review: Site Reliability Engineering"
date: 2017-04-24 19:07
comments: true
categories: [book, review, readings, sre, devops, google]
description: "What an immense contribution from Google to the dev & sys community."
---

One of the longest reads I took up over the past months was the
[Google SRE book](https://landing.google.com/sre/book.html), after an interesting comment by [Giorgio](https://www.linkedin.com/in/giorgiosironi/?ppe=1) on one of my
[previous posts on the advantages of timeouts](http://odino.org/better-performance-the-case-for-timeouts/).

Even though the book is free available online, I decided to buy the kindle
edition as I enjoy reading on the device, as it keeps me distraction-free
and lets me focus on reading (more on falling in love with the kindle later on,
I promise!).

<!-- more -->

{% img right /images/sre.gif %}

Needless to say, **the content of the book is gold**, as it explains how Google
approaches DevOps in their own fashion, which they call *Site Reliability Engineering*:
no matter where you work (backend, frontend, systems) this book is a good collection
of lessons, best practices and patterns by one of the ultimate industry leaders.

As a friend once told me, "*Google had SREs when the world was starting to spell DevOps*",
and I couldn't agree more -- you might get lost in between specific chapters that
deal with Google-scale problems (which might not be applicable to your specific
context), but I'd say that, even considering that, **the book is a must read**.

There's
also a plethora of other SRE material on the internet (ie. things like [this](https://landing.google.com/sre/) and [this](https://landing.google.com/sre/interview/ben-treynor.html),
but [lmgtfy](http://lmgtfy.com/?q=what+is+an+sre+google) as well) so you might want
to warm up with those and then, if interested, dive in the book, as it's not
super-lightweight.

Some interesting quotes from the book:

{% blockquote %}
Software engineering has this in common with having children: the labor before the birth is painful and difficult, but the labor after the birth is where you actually spend most of your effort.
{% endblockquote %}

{% blockquote %}
40–90% of the total costs of a system are incurred after birth
{% endblockquote %}

{% blockquote %}
However, we expend effort in this direction only up to a point: when systems are “reliable enough,” we instead invest our efforts in adding features or building new products.
{% endblockquote %}

{% blockquote %}
Hope is not a strategy -- Traditional SRE saying
{% endblockquote %}

{% blockquote %}
our Site Reliability Engineering teams focus on hiring software engineers to run our products and to create systems to accomplish the work that would otherwise be performed, often manually, by sysadmins
{% endblockquote %}

{% blockquote %}
Google caps operational work for SREs at 50% of their time
{% endblockquote %}

{% blockquote %}
In general, for any software service or system, 100% is not the right reliability target because no user can tell the difference between a system being 100% available and 99.999% available. There are many other systems in the path between user and service (their laptop, their home WiFi, their ISP, the power grid…) and those systems collectively are far less than 99.999% available. Thus, the marginal difference between 99.999% and 100% gets lost in the noise of other unavailability, and the user receives no benefit from the enormous effort required to add that last 0.001% of availability.
{% endblockquote %}

{% blockquote %}
An outage is no longer a “bad” thing — it is an expected part of the process of innovation, and an occurrence that both development and SRE teams manage rather than fear.
{% endblockquote %}

{% blockquote %}
Google Software Engineers work from a single shared repository
{% endblockquote %}

{% blockquote %}
users typically don’t notice the difference between high reliability and extreme reliability in a service, because the user experience is dominated by less reliable components like the cellular network or the device they are working with
{% endblockquote %}

{% blockquote %}
We strive to make a service reliable enough, but no more reliable than it needs to be. That is, when we set an availability target of 99.99%,we want to exceed it, but not by much: that would waste opportunities to add features to the system, clean up technical debt, or reduce its operational costs
{% endblockquote %}

{% blockquote %}
The target level of availability for a given Google service usually depends on the function it provides and how the service is positioned in the marketplace. The following list includes issues to consider: What level of service will the users expect? Does this service tie directly to revenue (either our revenue, or our customers’ revenue)? Is this a paid service, or is it free? If there are competitors in the marketplace, what level of service do those competitors provide? Is this service targeted at consumers, or at enterprises?
{% endblockquote %}

{% blockquote %}
If we were to build and operate these systems at one more nine of availability, what would our incremental increase in revenue be? Does this additional revenue offset the cost of reaching that level of reliability? To make this trade-off equation more concrete, consider the following cost/benefit for an example service where each request has equal value: Proposed improvement in availability target: 99.9% → 99.99% Proposed increase in availability: 0.09% Service revenue: $1M Value of improved availability: $1M * 0.0009 = $900 In this case, if the cost of improving availability by one nine is less than $900, it is worth the investment. If the cost is greater than $900, the costs will exceed the projected increase in revenue.
{% endblockquote %}

{% blockquote %}
Again, not enough testing and you have embarrassing outages, privacy data leaks, or a number of other press-worthy events. Too much testing, and you might lose your market.
{% endblockquote %}

{% blockquote %}
If a human operator needs to touch your system during normal operations, you have a bug. The definition of normal changes as your systems grow.
{% endblockquote %}

{% blockquote %}
The four golden signals of monitoring are latency, traffic, errors, and saturation.
{% endblockquote %}

{% blockquote %}
The sources of potential complexity are never-ending. Like all software systems, monitoring can become so complex that it’s fragile, complicated to change, and a maintenance burden. Therefore, design your monitoring system with an eye toward simplicity.
{% endblockquote %}

{% blockquote %}
Google does have a strong bias toward automation.
{% endblockquote %}

{% blockquote %}
We graduated from optimizing our infrastructure for a lack of failover to embracing the idea that failure is inevitable, and therefore optimizing to recover quickly through automation.
{% endblockquote %}

{% blockquote %}
In one case, a multi-petabyte Bigtable cluster was configured to not use the first (logging) disk on 12-disk systems, for latency reasons. A year later, some automation assumed that if a machine’s first disk wasn’t being used, that machine didn’t have any storage configured; therefore, it was safe to wipe the machine and set it up from scratch. All of the Bigtable data was wiped, instantly.
{% endblockquote %}

{% blockquote %}
The price of reliability is the pursuit of the utmost simplicity.
{% endblockquote %}

{% blockquote %}
it is very important to consider the difference between essential complexity and accidental complexity. Essential complexity is the complexity inherent in a given situation that cannot be removed from a problem definition, whereas accidental complexity is more fluid and can be resolved with engineering effort. For example, writing a web server entails dealing with the essential complexity of serving web pages quickly. However, if we write a web server in Java, we may introduce accidental complexity when trying to minimize the performance impact of garbage collection.
{% endblockquote %}

{% blockquote %}
Some might protest, “What if we need that code later?” “Why don’t we just comment the code out so we can easily add it again later?” or “Why don’t we gate the code with a flag instead of deleting it?” These are all terrible suggestions. Source control systems make it easy to reverse changes, whereas hundreds of lines of commented code create distractions and confusion (especially as the source files continue to evolve), and code that is never executed, gated by a flag that is always disabled, is a metaphorical time bomb waiting to explode
{% endblockquote %}

{% blockquote %}
every new line of code written is a liability.
{% endblockquote %}

{% blockquote %}
French poet Antoine de Saint Exupery wrote, “perfection is finally attained not when there is no longer more to add, but when there is no longer anything to take away”
{% endblockquote %}

{% blockquote %}
If you haven’t tried it, assume it’s broken.
{% endblockquote %}

{% blockquote %}
Remember that not all software is created equal. Life-critical or revenue-critical systems demand substantially higher levels of test quality and coverage than a non-production script with a short shelf life.
{% endblockquote %}

{% blockquote %}
we’ve learned (the hard way!) about one very dangerous pitfall of the Least-Loaded Round Robin approach: if a task is seriously unhealthy, it might start serving 100% errors. Depending on the nature of those errors, they may have very low latency; it’s frequently significantly faster to just return an “I’m unhealthy!” error than to actually process a request. As a result, clients might start sending a very large amount of traffic to the unhealthy task, erroneously thinking that the task is available, as opposed to fast-failing them!
{% endblockquote %}

{% blockquote %}
Weighted Round Robin is fairly simple in principle: each client task keeps a “capability” score for each backend in its subset. Requests are distributed in Round-Robin fashion, but clients weigh the distributions of requests to backends proportionally. In each response (including responses to health checks), backends include the current observed rates of queries and errors per second, in addition to the utilization (typically, CPU usage).
{% endblockquote %}

{% blockquote %}
We’ve also significantly extended our RPC system to propagate criticality automatically. If a backend receives request A and, as part of executing that request, issues outgoing request B and request C to other backends, request B and request C will use the same criticality as request A by default.
{% endblockquote %}

{% blockquote %}
we implement a per-request retry budget of up to three attempts. If a request has already failed three times, we let the failure bubble up to the caller. The rationale is that if a request has already landed on overloaded tasks three times, it’s relatively unlikely that attempting it again will help because the whole datacenter is likely overloaded.
{% endblockquote %}

{% blockquote %}
we implement a per-client retry budget. Each client keeps track of the ratio of requests that correspond to retries. A request will only be retried as long as this ratio is below 10%. The rationale is that if only a small subset of tasks are overloaded, there will be relatively little need to retry.
{% endblockquote %}

{% blockquote %}
As a concrete example (of the worst-case scenario), let’s assume a datacenter is accepting a small amount of requests and rejecting a large portion of requests. Let be the total rate of requests attempted against the datacenter according to the client-side logic. Due to the number of retries that will occur, the number of requests will grow significantly, to somewhere just below . Although we’ve effectively capped the growth caused by retries, a threefold increase in requests is significant, especially if the cost of rejecting versus processing a request is considerable. However, layering on the per-client retry budget (a 10% retry ratio) reduces the growth to just 1.1x in the general case — a significant improvement.
{% endblockquote %}

{% blockquote %}
The key point is that a failed request from the DB Frontend should only be retried by Backend B, the layer immediately above it. If multiple layers retried, we’d have a combinatorial explosion.
{% endblockquote %}

{% blockquote %}
Increased rate of garbage collection (GC) in Java, resulting in increased CPU usage A vicious cycle can occur in this scenario: less CPU is available, resulting in slower requests, resulting in increased RAM usage, resulting in more GC, resulting in even lower availability of CPU. This is known colloquially as the “GC death spiral.”
{% endblockquote %}

{% blockquote %}
If a user’s web search is slow because an RPC has been queued for 10 seconds, there’s a good chance the user has given up and refreshed their browser, issuing another request: there’s no point in responding to the first one, since it will be ignored!
{% endblockquote %}

{% blockquote %}
Once the recovery team had identified the backup tapes, the first recovery wave kicked off on March 8th. Requesting 1.5 petabytes of data distributed among thousands of tapes from offsite storage was one matter, but extracting the data from the tapes was quite another. The custom-built tape backup software stack wasn’t designed to handle a single restore operation of such a large size, so the initial recovery was split into 5,475 restore jobs. It would take a human operator typing in one restore command a minute more than three days to request that many restores, and any human operator would no doubt make many mistakes. Just requesting the restore from the tape backup system needed SRE to develop a programmatic solution.11 By midnight on March 9th, Music SRE finished requesting all 5,475 restores. The tape backup system began working its magic. Four hours later, it spat out a list of 5,337 backup tapes to be recalled from offsite locations. In another eight hours, the tapes arrived at a datacenter in a series of truck deliveries.
{% endblockquote %}

{% blockquote %}
Contingency measures are another part of rollout planning. What if you don’t manage to enable the feature in time for the keynote? Sometimes these contingency measures are as simple as preparing a backup slide deck that says, “We will be launching this feature over the next days” rather than “We have launched this feature.”
{% endblockquote %}

{% blockquote %}
Roll out many changes in parallel, each to a few servers, users, entities, or datacenters Gradually increase to a larger but limited group of users, usually between 1 and 10 percent Direct traffic through different servers depending on users, sessions, objects, and/or locations Automatically handle failure of the new code paths by design, without affecting users Independently revert each such change immediately in the event of serious bugs or side effects Measure the extent to which each change improves the user experience
{% endblockquote %}

{% blockquote %}
A phone app developer might decide that 2 a.m. is a good time to download updates, because the user is most likely asleep and won’t be inconvenienced by the download. However, such a design results in a barrage of requests to the download server at 2 a.m. every night, and almost no requests at any other time.
{% endblockquote %}

{% blockquote %}
Should an outage occur for which writing a postmortem is beneficial, the on-caller should include the newbie as a coauthor. Do not dump the writeup solely on the student, because it could be mislearned that postmortems are somehow grunt work to be passed off on those most junior. It would be a mistake to create such an impression.
{% endblockquote %}

{% blockquote %}
former defense contractor Peter Dahl described a very detailed design culture in which creating a new defense system commonly entailed an entire year of design, followed by just three weeks of writing the code to actualize the design. Both of these examples are markedly different from Google’s launch and iterate culture, which promotes a much faster rate of change at a calculated risk. Other industries (e.g., the medical industry and the military, as previously discussed) have very different pressures, risk appetites, and requirements, and their processes are very much informed by these circumstances.
{% endblockquote %}

{% blockquote %}
At their core, Google’s Site Reliability Engineers are software engineers with a low tolerance for repetitive reactive work.
{% endblockquote %}

{% blockquote %}
Practice handling hypothetical outages (see “Disaster Role Playing”) routinely and improve your incident-handling documentation in the process.
{% endblockquote %}

...oh boy, lots of inspiring content: as I already said, this book is definitely
recommended!