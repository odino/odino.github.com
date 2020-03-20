---
layout: post
title: "Beware of Lodash (and the cost of abstractions)"
date: 2017-03-24 13:51
comments: true
categories: [javascript, performance]
description: "When abstractions cost: how we saved 5ms trading elegance for pragmatism."
---

Yesterday, while profiling one of [our](https://tech.namshi.com) NodeJS apps, I
bumped into an interesting piece of code that seemed to take too long to run:
interestingly enough, everything seemed to point to lodash's `pick` function.

<!-- more -->

For those of you who don't know what that function does, it basically creates a
new object from an existing one, picking only a user-defined list of properties
to "move over".

Easier in code than with words:

``` js
let a = {b: 1, c: 2}

_.pick(a, ['b']) // {b: 1}
```

It's kind of an elegant solution over doing these kind of
operations manually:

``` js
let user = {
  name: 'Alex',
  lastName: 'Nadalin',
  job: 'less',
  age: 'still ok',
  gender: 'M',
  hair: 'enough',
  ...
}

app.get('/full-user-details', res => {
  res.json({user})
})

app.get('/partial-user-details', res => {
  res.json({user: {
    name: user.name,
    lastName: user.lastName,
    age: user.age,
  }})
})

// VS

app.get('/partial-user-details', res => {
  res.json({user: _.pick(user, ['name', 'lastName', 'age'])})
})
```

It doesn't really change much in terms of style although, in my opinion, it looks
a bit more elegant and lets you [type less code](https://blog.codinghorror.com/the-best-code-is-no-code-at-all/).

So what about the performance impact? I wrote a small script to test it over a
long list of "user" objects:

``` js
const _ = require('lodash')
let user = {
  name: 'Alex',
  lastName: 'Nadalin',
  job: 'less',
  age: 'still ok',
  gender: 'M',
  hair: 'enough',
}

list = new Array(1000)
list.fill(user)

console.time('vanilla')
list.map(user => {
  return {
    name: user.name,
    lastName: user.lastName
  }
})
console.timeEnd('vanilla')

console.time('lodash')
list.map(user => _.pick(user, ['name', 'lastName']))
console.timeEnd('lodash')
```

So, we're creating a list of a thousand objects with a handful of properies,
loop through that list and map them, hand-picking a couple properies. The result:

``` bash
/tmp ᐅ node beware-lodash.js

vanilla: 1.064ms
lodash: 14.271ms
```

## What the actual [expletive] is going on here?

Well, [Lodash needs to loop through all the keys in the object](https://github.com/lodash/lodash/blob/4.17.4/lodash.js#L13537)
to cherry-pick the specific properties and, additionally, "needs" to call a whole
bunch of functions:

* `pick`
* `basePick`
* `basePickBy`
* `hasIn`
* `hasPath`
* `castPath`
* `toKey`

...and I honestly lost the count by then -- I wonder what that does to the
stack :)

So, even though I can't pinpoint the exact bottleneck, I think there are a bunch
of different factors that make its implementation way slower compared to
using some more tedious, vanilla JS: the Big O is in itself less efficient, plus
the fact that it needs to call a few different functions and do some sanity
checks around definitely play a role in the slowdown.

In our case we used lodash in a loop that, worst-case scenario, involved ~100 items:

``` bash
# Use list.fill(100)
/tmp ᐅ node beware-lodash.js

vanilla: 0.357ms
lodash: 5.250ms
```

Guess how much time did we save in our app? Exactly 5ms.

To many, that might not seem too much, but considering that the response time of the given
service was around 44ms, we basically cut it down by 10%.

## Does this mean that Lodash suck?

**Heck, no!** How would you do this?

``` js
// GET /users?fields=name&fields=lastName
app.get('/:collection', (req, res) => {
  let data = require(`./${req.params.collection}.json`)

  res.json({data: data.map(d => _.pick(d, req.query.fields))})
})
```

As always, there's a use case for everything{% fn_ref 1 %}, so you just need to understand
if the function, API or library you're using is the best fit in your scenario:
for us, since we always knew the properties to pick in advance, using `_.pick`
and all the power it offers didn't make a lot of sense.

Too often we rely on libraries and abstractions, thinking we're never going to
"pay" for that: granted that many times these abstractions are necessary so that
we don't re-invent the wheel and rely on someone else's great work, we still need
to evaluate what consequences using a framework or library brings to the
table.

Cheers!

{% footnotes %}
  {% fn Okay, maybe requiring JSON files from the filesystem based on user-input pushes it too far... %}
{% endfootnotes %}