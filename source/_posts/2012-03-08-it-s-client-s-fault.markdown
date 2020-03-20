---
layout: post
title: "It's client's fault"
date: 2011-04-21 12:50
comments: true
categories: [hypermedia, rest]
alias: "/334/it-s-client-s-fault"
---
<!-- more -->

{% blockquote Will Hartung http://tech.groups.yahoo.com/group/rest-discuss/message/17492 Predefined DAPs %}
The quality of the client does not affect the RESTyness of an application. You can have a full boat REST application and stupid clients that choose (for whatever reason) to ignore it and tromp on their way doing whatever they do. Whether it's a hard coded client shoving requests at the server, or simply a  user that simply can not navigate the interface (doesn't see the links, doesn't understand them, whatever, wasn't trained to click the X button, was trained to click the Y button -- and the Y button is no longer there).

Motivation to create a more flexible and adaptable client is tied to the difficulty of maintaining that client, the consequences of failure, and the velocity of change on the service that client is using. If someone writes a perl script against an interface that's been stable for 5 years, for something that can withstand failure IF the service changes, that has no effect on the capabilities and robustness of the service itself.

[...] That's a client error [...], not the applications weakness.
So, write clients as you like. It's the REST applications promise to provide the proper information for a client to make better decisions, but it can't force the clients to use that information appropriately, rather all it can do it try and protect itself when they don't.
{% endblockquote %}