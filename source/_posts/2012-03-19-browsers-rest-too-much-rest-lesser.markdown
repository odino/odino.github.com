---
layout: post
title: "Browsers rest too much REST lesser"
date: 2010-10-29 15:50
comments: true
categories: [rest]
alias: "/237/browsers-rest-too-much-rest-lesser"
---

Today I asked, looking for valid replies, some guys of the [Rome PUG](http://roma.grusp.org/), about cool ways to authenticate a client over a REST architecture.
<!-- more -->

My constraints were:

* we cannot use any kind of server-side session, 'cause server must be stateless
* we cannot use cookies, because they're only implemented in HTTP
* we must think at the resource to identify as a webpage ( this seems stupid, but when I ask for authentication in REST people usually think about authentication in a webservice: no, let's think about **any** authentication system, like FaceBook's login, which has to **directly interact with a human** )

and the obvious answer came out to be "client sends credentials at each request".

Cool? No.

Why is this thing a crap?

Because, nowadays, *that thing* people use to interact with the server ( the **browser**, the **creepy browser** ) is unable to handle, by itself, the authentication.

I beg your pardon, I mean "a **decent** authentication".

Federico Galassi wrote ages ago about [authentication as it should be](http://federico.galassi.net/2009/12/31/web-authentication-as-it-should-have-been/): the problem that emerges - nowadays - is that browsers can handle [Basic HTTP Authentication](http://en.wikipedia.org/wiki/Basic_access_authentication) ( or Digest one ) without letting servers customize

* the way the the authentication form was displayed
* the mechanism behind authentication
* the way you can switch between authenticated and non-authenticated requests

## The ugly authentication form is not a caprice

Why don't they give you the possibility to customize that ugly form?

And, in addition, why they trigger the basic authentication after a 401, **automathically**?

Because of this look, web agencies don't like BHA.

## The mechanism is not a caprice

Why only username and password?

Why are we forcing websites to use server side authentication because of the lack of potential inside HTTP's basic authentication?

Keep in mind homebanking systems, where I **usually login with a username, a password and a external-device-generated token**.

There's a plethora of systems that need more than a couple params to authenticate a user.

## Switching states

Last but not least, modern browsers force you to close and restart them in order to log-out from BHA. Because - awesome - they cache authentication but - aweful - they forget anonymity.

## Authentication as it really should be

Client must look for a descriptive authentication-method "wiki" on the server, where the server, in any format, explains the parameters you must send to authenticate a request.

Something like:

``` bash
Authentication:
  /users:
    GET:  ~
    POST:
      username:
        string: plain
      password:
        string: md5
      token:
        integer: plain
... 
```
( this is a YAML response )

At last, the client must be able to communicate with the server for rendering the authentication form **inside** ( or outside... like a future "authentication sidebar"? ) the webpage the browser renders.

Once compiled the form, the client should ping the server on a service which only tells the client if it has succesfully logged in ( and eventually a URL to redirect towards ).

From now on, the user should be able to switch from authenticated and non-authenticated requests from the "authentication sidebar".

Browsers, let's do this now.