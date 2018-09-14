---
layout: post
title: "Introduction to Web Application SECurity"
date: 2018-07-29 04:21
comments: true
categories: [WASEC, book, security, web application security]
description: "Attackers lurk, vulnerabilities proliferate: time to better understand how to secure web applications."
---

{% render_partial series/wasec.markdown %}

WASEC is a series about Web Application SECurity, written in the attempt
to summarize security best practices when building web applications.

Today's web platform allows developers to build magnificent products, with
technologies that were unthinkable of just a few years ago, such as
web push notifications, geolocation or even "simpler" features such as
localStorage.

These additional technologies, though, come at a cost: the spectrum of
vulnerabilities is amplified, and there's more we must know
when developing for the web. When iFrames were introduced, everyone
was quick to point out how great of an invention they were (at least back in the day),
as they allowed to embed content from different webpages very
easily; few, though, would have thought that the very same technology
would serve as the basis of [clickjacking](https://en.wikipedia.org/wiki/Clickjacking),
a type of vulnerability only possible thanks to additional features
to the HTML standard.

As Wikipedia puts it:

> Clickjacking is possible because [of] **seemingly harmless** features of HTML web pages

Let me twist the tale and ask you if you were aware that CSRF attacks are about
to disappear. How? Thanks to browsers supporting `SameSite` cookies (discussed
further on in the series).

See, the landscape surrounding the web is changing quickly, and having a good
understanding of the platform, with a keen eye on security, is the goal
of this series: to make sure we've raised our **security awareness**.

WASEC is a series written to demistify web security, and make it easier for
the everyday developer to understand important, security-related aspects
of this universal platform.

<!-- more -->

## Who this series is for

WASEC is intended for the everyday software engineer that develops
web applications: most of us prefer spending their time reviewing
interesting repositories on GitHub, or skimming through a Google
developer advocate's Twitter feed in order to find cool announcements,
while few of us spend time focusing on the boring parts, such as
hardening HTTP cookies with the right flags.

Truth to be told, security is as rewarding as writing code: when it works,
you should celebrate your approach and start a round of high-fives with your
colleagues.

Besides the everyday software engineer, the writing style of the series
and its content make it an interesting read for a couple additional *species*:

* students or novice programmers, as this series will cover technical aspects
without going too deep: we'll definitely talk about HTTPS, but there's no
need to deep-dive into how the Diffie-Hellman key exchange algorithm works
* non-web software engineers: WASEC will prove to be an interesting
introduction to security on a platform you seldom work with

This series assumes the average reader has basic knowledge of web technologies such as
browsers, HTML and JavaScript. You will not need to know the difference between
`var` and `let`, but rather how scripts are loaded and executed when a browser
renders a web page.

## Errata and additional content

The [ToC](/web-security-demistified/#contents) of the series appears exhaustive, but I know things go missing,
no matter what.
I will try my best to include additional content in future versions of
the series, which you will hopefully be able to access through LeanPub
or the Kindle store. Container or [Kubernetes](https://kubernetes.io/) security,
for example, are chapters I could instantly think of, but I opted
to exclude them from the series in order to cover what I think are the most important
bits first -- they might be included in a future edition though.

In addition, I'd like to apologize in advance for the typos: my fat fingers,
as well as the fact that English is not my mother tongue, definitely played
an important role here.

In some cases, there might be incorrect information possibly due to
my (mis)interpretation of data, a specification or other information
I obtained while writing this series, so feel free to reach out and let me know
what I should fix: *alessandro.nadalin@gmail.com* is only an e-mail away.

No matter whether you'd like to suggest the addition of a new chapter,
report misinformation or a simple typo, I'll be happy to have a look
at your feedback and, hopefully, integrate it into WASEC, so other
readers can benefit from your contribution.

Enough with the formalities, it's now time to see what's cooking: in the next article
we'll be taking a look at browsers, pieces of software we use on a daily basis that
can reserve plenty of surprises for our users.

{% assign next_title="Understanding the browser" %}
{% assign next_link="/wasec-understanding-the-browser/" %}
{% render_partial _includes/series_nav.html %}
