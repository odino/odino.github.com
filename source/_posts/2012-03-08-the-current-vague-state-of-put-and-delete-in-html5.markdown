---
layout: post
title: "The current vague state of PUT and DELETE in HTML5"
date: 2011-05-06 13:01
comments: true
categories: [html5, http]
alias: "/316/the-current-vague-state-of-put-and-delete-in-html5"
---

If you followed my [REST in peace](http://www.slideshare.net/odino/rest-in-peace-codemotion-2011) presentation, you probably noted that I was [a bit angry against HTML5](http://www.slideshare.net/odino/rest-in-peace-codemotion-2011/180).
<!-- more -->

The story is pretty straightforward: the original working draft included also PUT and DELETE verbs in the forms' method attribute, while, one year ago, [an update to the draft removed them](http://www.w3.org/TR/2010/WD-html5-diff-20101019/#changes-2010-06-24).

A month ago [I announced](http://twitter.com/#!/_odino_/status/53555681088905217) that the working group was reconsidering its decision [after the suggestions of Mike Amundsen](http://www.w3.org/Bugs/Public/show_bug.cgi?id=10671#c8): shortly after, we have a new proposal, which carries on the [management of HTTP headers in the forms](http://lists.w3.org/Archives/Public/public-html/2011Apr/0259.html).

I still don't know if the proposal will be implemented in HTML5, but imagine a world with:

``` html HTTP headers in HTML forms
<form action="/users/1" method="PUT">
	<input type="header" name="Authorization" value="BASIC"/>
	<input type="hidden" name="realm" value="authorized@server.example.com"/>

	<input type="text" name="username"/>
	<input type="email" name="username"/>
	<input type="password" name="password"/>
        ...
</form>
```