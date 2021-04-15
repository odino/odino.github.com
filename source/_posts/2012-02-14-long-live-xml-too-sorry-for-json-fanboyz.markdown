---
layout: post
title: "Long live XML (too sorry for JSON fanboyz)"
date: 2011-04-02 11:47
comments: true
categories: [xml]
alias: "/320/long-live-xml-too-sorry-for-json-fanboyz"
---

Time after time, the web sees the exploit of a technology, sometimes new, other times old, applied in a different context.
<!-- more -->

{% img right /images/sandviper-3.jpg %}

This shouldn't be problematic, although it's always a pain to explain to fanboys that technology has limitations, because a universal solution would be too general-purpose to resolve all the problems with the most simple and clean approach.

JSON is definitely one of those, hyped, solutions.

## New is trendy

You know the proverbial hammer to nail solutions?

{% blockquote %}
Invented the hammer, everything becomes a nail
{% endblockquote %}

which means that *when the kid has something new, he tries to use it in every context*.

I remember the first time I've brought my '92 ZZR home, because one of the first things my dad said to me was:

{% blockquote %}
I bet when you'll need to buy cigarettes you'll go to the tobacconist with it.
and he was totally right, although the tobacconist was 500mt far from home.
{% endblockquote %}

I was excited everytime I was turning it on, although I knew that using it for such a limited distance was bad because:

* I needed to wait some minutes before going, in order to warm up the bike: the result was that, by foot, it took less time to buy my [Dianas](http://www.flickr.com/photos/crumblindown/3559589709/)
* if I didn't wait, every sudden acceleration was a pain for the bike

but I was so convinced, so happy, so dummy that I didn't care about it.

{% img left /images/6176_1170524713920_1552073836_445211_5558392_n.jpg %}

## Don't piss the audience off

At the [NoSQL day of the last week](http://www.odino.org/313/nosql-day-from-enthusiasm-to-consciousness) I attended a session about ElasticSearch and MongoDB and blablabla: the topic is irrelevant, while the fact that the speaker asserted that **XML should die in favour of JSON** is important.

Again, we tend to think that a technology ( JSON ) is the hammer for every nail.

## Why XML sucks

[Ward Cunningham](http://en.wikipedia.org/wiki/Ward_Cunningham) has a cool section about it and I tend to agree on this: XML sucks in so many ways, we know it.

{% img left /images/cat-obvious.jpg %}

I basically don't like some things about XML:

* verbosity
* not human-readable
* slow(er) to parse ( than JSON, for example )
* not prone to *once and one only*

but, as I know nothing is perfect, I'm ok with these drawbacks.

## Enters the hero

JSON is a cool format for exchanging data: it's extremely fast to read and almost human-readable.

Wikipedia has [some words](http://en.wikipedia.org/wiki/JSON) about:

{% blockquote %}
A lightweight text-based open standard designed for human-readable data interchange. It is derived from the JavaScript programming language for representing simple data structures and associative arrays, called objects.
It wins over XML on a large amount of things, as [David Zuelke states](http://www.slideshare.net/Wombert/xml-versus-the-new-kids-on-the-block-phpbnl11-20110129/43).
{% endblockquote %}

## Fails the hero

But, as usual, one size can't fit all.

Consider a JSON object: you have a product with 3 attributes ( name, sku, price ): since you know you are selling a product only in europe, your product's price is expressed in euros:

```
{
  "name":  "Banana",
  "sku":     1234,
  "price":   24
}
```

Time goes by and you open an API for online stores around europe: doing this, you let them know about your catalog ( a useful information for price-comparison services, for example ).

Other time goes by and the boss comes into your office telling your company is doing so good that is opening new branches in the united states: so your duty is to update the API in order to show prices both in euros and dollars:

```
{
  "name":  "Banana",
  "sku":    1234,
  "price":  {
    "EUR":   24,
    "USD":  19
  }
}
```

"Damn", you think, "the current implementation breaks old clients": long story short, they expect an attribute but they get an array, and as soon as the consume your service... **BOOOM** :)

With real attributes and other godness like namespaces XML is a solution for long-term stability:

``` xml
...
<product>
  <name>banana</name>
  <sku>1234</sku>
  <price>24</price>
</product>
...
```

because it let's you evolve your implementation without breaking existing clients:

``` xml
...
<product>
  <name>banana</name>
  <sku>1234</sku>
  <price currency='EUR'>24</price>
  <price currency='USD'>19</price>
</product>
```

You can't take control over the client side

Think at the [minitel](http://www.google.it/images?client=ubuntu&channel=cs&q=minitel&um=1&ie=UTF-8&source=og&sa=N&hl=it&tab=wi&biw=1280&bih=690), or any physical device you use ( e.g. GPS systems ). Their implementation have evolved during the years, the months and ( for example for smartphones ) the weeks.

Can you afford to oblige your clients ( = customers who paid your product/service ) to update their product/service? No.

Can you break one of your clients devices/software because you wanted to evolve your software implementation? No.

Would you use JSON to expose your services in such similar cases? No.

There lies XML{% fn_ref 1 %}.

{% footnotes %}
  {%fn ah, and a semantic web with JSON would obvioulsy be another pain too %}
{% endfootnotes %}