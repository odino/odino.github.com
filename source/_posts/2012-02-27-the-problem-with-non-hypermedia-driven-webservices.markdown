---
layout: post
title: "The problem with non hypermedia-driven webservices"
date: 2011-05-31 11:12
comments: true
categories: [hypermedia]
alias: "/353/the-problem-with-non-hypermedia-driven-services"
---

I don't like SOAP. But I don't blame people using it.
<!-- more -->

You have tons of reasons to use it:

* integration with an existing architecture
* WS-*-prone development environment
* forced conditions ( like, in Italy, when working with public administrations )

But since today I had a meeting with the developers of a series of SOAP services we will integrate with, one of my first questions was "How do you manage the fact that the customer has the need to change the domain of the application and you need to update the WS and its consumers?".

{% blockquote %}
We don't.
We tend to force the customer embrace the way the domain model has been already designed .
If it really needs to change it, we just evolve it, push it to the staging/testing area and then deploying it in production.
Since this is so expensice, we force it to happen twice or so in a year.
Which is perfectly understandable.
{% endblockquote %}

This is all you need to be aware of.

The choice is yours: you can decide to feed your consumers with WSDL or hypermedia controls, and your specific need is the only thing that matters in this decision.