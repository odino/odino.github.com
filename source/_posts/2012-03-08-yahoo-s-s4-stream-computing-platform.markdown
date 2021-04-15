---
layout: post
title: "Yahoo's S4 stream computing platform"
date: 2011-06-02 12:29
comments: true
categories: [s4]
alias: "/356/yahoo-s-s4-stream-computing-platform"
---

The internet had a huge bump during the late '90s, and all the majors needed something web-scale in order to conquer the 'net.
<!-- more -->

Google, after its launch, suddenly became the king of the web, destroying the competitors year by year.

Far from being a simple search engine, it evolved giving us incredible services, like Gmail and Docs: web-ready and web-scale services able to endure massive traffic and data-exchange.

Furthermore, the search engine was accumulating an extraordinary amount of records and it probably needed a brand new algorithm to index and process its contents.

It was 2004, and Google came out with [MapReduce](http://en.wikipedia.org/wiki/MapReduce), a new way of thinking the distribution of the workload.

## Beyond MapReduce

MapReduce rocks, everybody thought.

But then the problems came out: MR is solid and ass-kicking when you need to process tons of permanent data; when you need to do huge batch operations you should use it, nobody hesitates.

But there is a scenario where MR probably isn't the best choice for your needs: processing huge streams of data.

## Enters S4

[S4](http://www.s4.io/) - I really don't know the reason behind this name - is a framework developed by Yahoo for processing continuoos streams of data.

Its entire architecture is thought to obviusly be event-driven, where computational units, known as *processing elements* (PE), process and possibly re-dispatch events emitted by the internal framework.

It already supports client adapters and an high level API, so you should be able to integrate with the platform in any language you want to: unfortunately, the docs have a PERL example :)