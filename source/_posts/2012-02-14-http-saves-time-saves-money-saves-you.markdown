---
layout: post
title: "HTTP saves time, saves money, saves you"
date: 2011-09-21 10:33
comments: true
categories: [HTTP]
alias: "/384/http-saves-time-saves-money-saves-you"
---

It Italy, as usual, our govern is a mess when talking about *{insert any topic here}*: today's topic will be... **webservices, saving money, time and providing an efficient service to the citizens**.
<!-- more -->

## Veryfing a VAT number

A requirement in your projects could be to verify, when a user subscribes to your service, which is intended for business owners, his VAT number.

The italian govern has such a service in the form of a [webpage](http://www1.agenziaentrate.it/servizi/vies/vies.htm), thus thought for humans: they don't offer a specific webservice but that's not a problem, as I can submit the form ( it uses GET, which is exactly meant for the purpose ) with an HTTP request. Cool.

## Doing HTTP wrong

So the first thing that came to my mind was to use cURL to verify the service:

``` bash
curl -I -X GET http://www1.agenziaentrate.it/servizi/vies/transazione.htm -d "s=IT&p=02524130305" -G
```

where `s` is the country of the company and `p` its VAT number (bare in mind that the VAT number used here is wrong, as it was the one of my first company, now closed).

Bare in mind that:

``` bash
GET /vats?s=IT&p=02524130305
```

logically equals to

```
GET /vats/IT/02524130305
```

The result?

```
HTTP/1.1 200 OK
Date: Wed, 21 Sep 2011 13:02:25 GMT
Server: Apache
X-Powered-By: PHP/4.3.11
Connection: close
Transfer-Encoding: chunked
Content-Type: text/html
```

First of all, let's try not to be angry for that `X-Powered-By` header right there: let's just ignore it :-|

Then... Oh, wow, `200 OK`.

## Why is this so bad?

At first glance, it seemed weird to me, but I tought that they, for some reasons, considered my old company's VAT number still valid, but then I realized **how much noob an entire IT department can be** so I started suspecting that the system was **responding 200 to every request**.

Guess what, I was right.

I repeated the cURL call omitting the `-I` option (retrieve headers only) and saw the entire response body: in a table, beautiful as the sun, `VAT number not found`.

So, if I need to verify the existence of a VAT number with the tools provided by my govern, I need to **parse an entire HTML document**, **look for a DOM element** ( `table#feedback > td` and stuff like that ), **parse the resulting string** and... oh, I'm already annoyed by describing the steps to do it!

Take a look at the pseudo-code for this implementation:

```
vat = request.get('vat')
vatVerifyService = new ItalianGovernVatService 

vatResponse = vatVerifyService.check(vat)

if (vatResponse) {
  body = varResponse.getBody()

  // parse the body
  // look for a DOM attribute, 
  // which will change as they update the website with a new fancy markup
  // then evaluate the resulting string
}
```

and your code if you keep HTTP in consideration:

```
vat = request.get('vat')
vatVerifyService = new ItalianGovernVatService 

vatResponse = vatVerifyService.check(vat)
// vatResponse.getCode() tells you if the VAT is good or not 
```

Ok, this resource is not intended to be a *machine-consumed* service but:

* using the proper HTTP status code would have saved my time
* using the proper HTTP status code helps you expose a resource that, in some cases like this one, can be useful to both human-beings and computer programs, without writing any line of code, thus without wasting money

Adapt your resources and domain application protocols to HTTP: this is the only way to save your and your consumers' money and time in the modern web.
