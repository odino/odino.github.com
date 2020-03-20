---
layout: post
title: "Design patterns explained: circuit-breakers"
date: 2017-01-20 15:44
comments: true
categories: [design patterns, javascript, circuit-breaker, pattern]
description: "In this post we'll have a look at the circuit-breaker pattern and write a general-purpose implementation of it."
published: false
---

In one of my latest post I had a look at [timeouts](/better-performance-the-case-for-timeouts/)
and saw how employing them efficiently leads to
better performance and resiliency in an architecture;
today, I will instead focus on a design pattern,
the [circuit breaker](https://en.wikipedia.org/wiki/Circuit_breaker_design_pattern),
to see how we can further strengthen our application
against faults.

<!-- more -->

## The scenario

Suppose you are running a service that depends on
an HTTP API to fetch content to display to your
users -- nothing crazy, as our code could probably
look like this:

``` js
app.get('/users/:id', (req, res) => {
  client.get(`api.example.com/users/${req.params.id}`)
        .then(user => res.render('userProfile.html', {user}))
        .catch(err => res.render('error.html', {err}))
})
```

**That piece of code is fairly dangerous**{% fn_ref 1 %} as,
no matter what, for every request we process we're going to
be hitting `api.example.com` without considering
whether the service is up, down or shows degraded performance:
we blindly hit it, hoping we would eventually get an answer.

Now, imagine `api.example.com` is undergoing some stress due
to increased load on the frontends (our app): responses start
to lag, and we eventually hit some timeouts. After a bit,
we start getting 503 errors back: **the system's gone**.

## Cut the service some slack

Has anyone ever asked you to do fix some bug and
checked on you every other minute to undrestand
how that's coming along? You probably
found yourself saying (or at least thinking)
"*Hey, I can either fix this or answer you:
if you keep interrupting me every other minute
I can't focus on the issue*".

That's what happens when a service incurs in an
outage: we possibly have some self-healing
mechanism in place so that the software restarts,
cleans some resources up and tries to
come back up, but if we don't give it proper time
to heal, in peace, it's going to have a hard time:
in our case, if the API starts to continuously
throw 503 errors then there's no point in hitting
it -- we know it's down, so let's **give it time to
heal**.

## Introducing circuit-breakers

I'm fairly sure you are familiar with the broader concept
of [circuit breakers](https://en.wikipedia.org/wiki/Circuit_breaker),
as you've probably bumped into them at least once
in your life: they are heavily employed in electrical
circuits so that they can detect anomalies and "interrupt"
them to avoid greater risks.

{% pullquote %}
When you're at home, you probably know you wont be able
to turn all of your lights on while drying your hair, ironing
and watching the TV at the same time: after a few minutes,
the electricity will go off -- thanks to a circuit breaker:
it detects that the system is undergoing stress (we are using
too much current) and, to avoid damage to the electrical
circuit, it simply breaks it open so that no more electricity
is going through.

As much as it sounds annoying (everytime this happens, we have
to reset the circuit manually{% fn_ref 2 %}), that saves us from
bigger problems such as a damaged electrical circuit (no
electricity at all) or, worse, extreme over-heating and
possibly a fire (no house at all).

{"In computing, circuit breakers act very similarly, as they
are designed to provide relief to services under stress"}:
when they detect too many failures, they break the circuit
open so that we wont reach out to those services anymore,
giving them time to heal. Unlike electrical breakers, though,
we define automated ways for breakers to close the circuit
and restore service.
{% endpullquote %}

In other words, breakers follow a very basic workflow:

* whenever a call to an external service needs to be made, we should record its result (a circuit is created and a measure is taken)
* if we record too many failures in a specific span of time, that means the service is not available (the breaker "opens" the circuit)
* once the circuit is open, next calls should [fail immediately](https://en.wikipedia.org/wiki/Fail-fast), without reaching that service, so that we give it time to heal
* after a timeout has passed, new calls to the service can go through to see if it healed (breaker is closed)

Now that we've understood how they work, let's
try to write a general-purpose library to wrap external calls
with a circuit breaker: in this example we will use JavaScript,
but circuit breakers can be implemented in any language.

## The implementation

First off, we start from our initial code:

``` js
app.get('/users/:id', (req, res) => {
  client.get(`api.example.com/users/${req.params.id}`)
        .then(user => res.render('userProfile.html', {user}))
        .catch(err => res.render('error.html', {err}))
})
```

and decide that, rather than calling our HTTP client
directly, we want to wrap it through our library:

``` js
let breaker = require('node-circuit-breaker.js')
let wrappedHttpCall = breaker(client.get, {treshold: 5, timeout: 1000})

app.get('/users/:id', (req, res) => {
  wrappedHttpCall(`api.example.com/users/${req.params.id}`)
        .then(user => res.render('userProfile.html', {user}))
        .catch(err => res.render('error.html', {err}))
})
```

That's it: we will be wrapping our `client.get` function
through our breaker, which is configured to break the
circuit open after a threshold of 5 failed API calls.
The circuit will be closed again once a timeout of 1
second has passed.

Let's see how we would implement the breaker:

``` js node-circuit-breaker.js
function CircuitBreaker(fn, options) {
  this.fn = fn
  this.options = options
}

CircuitBreaker.prototype.run = function() {
  this.fn.apply(fn, arguments)
}

module.exports = function(fn) {

}
```

## Conclusion

{% footnotes %}
  {% fn Far from saying I never write code like that ;-) %}
  {% fn At least, that was the case in every house I lived in %}
{% endfootnotes %}