---
layout: post
title: "XML vs JSON for real"
date: 2011-04-17 13:23
comments: true
categories: [evolvability]
alias: "/321/xml-vs-json-for-real"
---

Since somebody, on Twitter, didn't appreciated my examples in the [JSON vs XML](http://www.odino.org/320/long-live-xml-too-sorry-for-json-fanboyz) fight ( and I just want to remember everybody that I'm not for the former or the latter, **without context** ), here I post an example that should be a *for-real* case in favour of XML, applied in the context of evolving a system without breaking existing clients.
<!-- more -->

## You know Twitter, uh?

Twitter lacks of I18N: you can't selectively filter tweets without recurring to some hacks.

So, when you follow foreign users, you'll face incomprehensible tweets, sooner or later: the guys of Twitter designed the service this way, so the API probably reflects this business logic.

The [Atom representations of public timelines](http://dev.twitter.com/doc/get/statuses/public_timeline) are pretty self-explanatory; so if you want to add the possibility to select a language for the tweet, the Atom would look like:

``` xml
<content type="html">MissChristolyn: Do i really have to go back to work! #bullshit</content>
```

so, when twitter will add I18N support we'll probably see something like this:

``` xml
<content type="html" ns:lang='en_EN' >MissChristolyn: Do i really have to go back to work! #bullshit</content>
<content type="html" ns:lang='it_IT' >MissChristolyn: Devo proprio tornare al lavoro! #minghia</content>
```

Ciao!