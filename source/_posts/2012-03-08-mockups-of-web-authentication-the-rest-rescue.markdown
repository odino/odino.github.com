---
layout: post
title: "Mockups of web authentication: the REST rescue "
date: 2010-10-29 15:15
comments: true
categories: []
alias: "/238/mockups-of-web-authentication-the-rest-rescue"
---

As I stated yesterday about how [browsers should authenticate the client](http://www.odino.org/237/browsers-rest-too-much-rest-lesser) in order to let server remain stateless ( no session, no cookies, no tokens ) I wanted to show off a more tangible image of the "*authentication sidebar*" I mentioned in the post.
<!-- more -->

I played with [balsamiq](http://balsamiq.com/) - for the first time in my life - and here' my results.

## User opens a webpage

{% img center /images/auth.rest.1.png %}

( User access its facebook account, you can see the imploded sidebar at the left of the screen )

## User logs in

{% img center /images/auth.rest.2.png %}

The browser has logged in the user with the last opened client-side session ( browser cache ). Now the user is able to change the account of the website ( facebook ).

## User updates account

{% img center /images/auth.rest.3.png %}

Everything is transparent to the server: everything the user's doing is updating a browser's authentication DB.

## User creates an account?

{% img center /images/auth.rest.4.png %}

I got some doubts about new account creation ( it always should send a request to the server, so I dunno if it makes sense to keep in on the authentication sidebar ).