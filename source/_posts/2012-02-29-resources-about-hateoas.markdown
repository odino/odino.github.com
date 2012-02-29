---
layout: post
title: "Resources about HATEOAS"
date: 2011-07-16 13:50
comments: true
categories: [REST, hypermedia]
alias: "/363/resources-about-hateoas"
---

Since [Matteo](http://matteo.vaccari.name/), an italian XP coach and university teacher, [asked me where he could find some free resources about HATEOAS](http://twitter.com/#!/xpmatteo/status/81392376928665600) for his students, I thought the thing deserves a post.
<!-- more -->

## On the web

[RESTpatterns](http://restpatterns.org/) has a cool series of articles about this architectural style, and they have a small chapter dedicated to [HATEOAS](http://restpatterns.org/Articles/The_Hypermedia_Scale).

Mike Amundsen recently started a Google group related to [hypermedia in the WWW](https://groups.google.com/forum/#!forum/hypermedia-web): the great thing is that the group has already seen some great material, like the [HAL specification](http://stateless.co/hal_specification.html), whose aim is to provide a lean media type to build hypermedia-driven applications; some code example can be found on gist, where a representation of the infamous [RESTBucks DAP](https://gist.github.com/1028986) ( actually, a few of its states ) has been written.

## On the blogs

[Amundsen's blog](http://www.amundsen.com/blog/), by the way, is one of the most crucial resources when talking about hypermedia and system evolvability nowadays: he recently posted a masterpiece, "[designing a RESTBucks media-type](http://www.amundsen.com/blog/archives/1101)", which obviously guides you towards the design of a domain-specific media type.

Mike also conducted a few [researches on well-known media-types](http://amundsen.com/hypermedia/), and has been the creator of the [hFactor](http://amundsen.com/hypermedia/hfactor/), a representation of the level of hypermedia-capabilities of media-types.

On Oracle's blogs, there's a nice article providing some [explanations of HATEOAS goodness](http://blogs.oracle.com/craigmcc/entry/why_hateoas) after having succesfully implemented it into some real-world projects.

Subbu Allamaraju, the writer of *RESTful webservices cookbook*, has briefly analyzed [facebook's new graph API](http://www.subbu.org/blog/2010/04/uncomplicated-hypermedia-facebooks-graph-api), poiting out how and why they implement hypermedia as the engine of application state ( Subbu also wrote [something introductive to the topic](http://www.subbu.org/blog/2010/01/hypertext-is-the-transaction-engine) ).

## Code on demand

Talking about code ( .NET & Java ), *REST in practice*'s authors started publishing the source code of the book on the web: for teachers, by the way, who use the book for their lessons, a few [copies of the materials available within the book are freely available](https://groups.google.com/d/msg/restinpractice/VuFf0n9Pz_0/amfZphib-i0J), you only need to directly contact the authors through the mailing list.

## Presentations

Wayne Lee has published a really interesting presentation entitled "[Why HATEOAS?](http://www.slideshare.net/trilancer/why-hateoas-1547275)": a cool point of his presentation is when he explains the benefits of HATEOAS through a car-parking management example.

And here come the big names: Jim Webber had a tremendously great [presentation](http://www.slideshare.net/adorepump/hateoas-the-confusing-bit-from-rest) of the topic, while the second part of David Zuelke's [Designing HTTP interfaces and RESTful webservices](http://www.slideshare.net/Wombert/designing-http-interfaces-and-restful-web-services-phpday11-20110514/81) is totally awesome, explaining with theory and practice why we should rely on hypermedia instead of giving service consumers fixed contracts which can't be easily evolved.

## A final consideration

Ok, I hope this is enogh to start with free documentation on HATEOAS: the main point of this resources is to make you conscious about the benefits of hypermedia-driven workflows.

It would be cool, if you, without knowing anything about HATEOAS before reading these stuff, after reading them are able NOT TO THINK that:

{% blockquote Phil Sturgeon, http://philsturgeon.co.uk/blog/2011/03/video-set-up-a-rest-api-with-codeigniter %}
I have never seen the point of jamming links into the response, that is what documentation is for.
{% endblockquote %}
