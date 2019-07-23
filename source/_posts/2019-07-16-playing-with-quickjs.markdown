---
layout: post
title: "Playing with QuickJS"
date: 2019-07-17 19:10
comments: true
categories: [JavaScript, QuickJS]
description: "Fabrice Bellard just released QuickJS, a small, embeddable JS engine...and using it is simpler than I thought."
---

A few days ago [Fabrice Bellard](https://bellard.org/) released
[QuickJS](https://bellard.org/quickjs/), a small JS engine that
targets embedded systems.

Curious to give it a try, I downloaded and set it up on my system
to try and understand this incredible piece of software.

<!-- more -->

## Installation

Setting up QuickJS is *dead* simple:

* clone one of the Github mirrors with `git clone git@github.com:ldarren/QuickJS.git`
* `cd QuickJS`
* `make`

...and that's it: the installation will leave you with a few
interesting binaries, the most interesting one being `qjsc`,
the compiler you can use to create executables out of your JS
code.

## Trying it out

Let's try to write a simple script that calculates powersets
for a given list:

``` js
function powerSet(str) {
    var obj = {}
    
    for(var i = 0; i < str.length; i++){
       obj[str[i]] = true;
    }
    
    var array = Object.keys(obj);
    var result = [[]];

    for(var i = 0; i < array.length; i++){
       var len = result.length; 

       for(var x = 0; x < len; x++){
         let set = result[x].concat(array[i])
         console.log(set)
         result.push(set)
       }
    }
    
    return result;
}

powerSet([1,2,3,4])
```

then we can compile it down to a binary:

```
./qjsc -o powerset powerset.js
```

and execute it:

```
$ ./powerset
1
2
1,2
3
1,3
2,3
1,2,3
4
1,4
2,4
1,2,4
3,4
1,3,4
2,3,4
1,2,3,4
```

That's it -- quite of a breeze!

## Where's the catch?

Well, QuickJS' standard library is fairly limited at the moment,
meaning you won't be able to use most NPM modules or the NodeJS standard
library since it's not really implemented: QuickJS simply implements
the ES2019 specification, which doesn't include any kind of standard
item you might be used to, like `require` or `process`.

The full [documentation for QuickJS is available here](https://bellard.org/quickjs/quickjs.html),
and you will notice that the only [standard objects you can work with](https://bellard.org/quickjs/quickjs.html#Standard-library)
are `std` and `os` -- very limited when compared to other, fully-bloated
engines but useful nevertheless (again, you have to think of QuickJS as an
engine to be embedded, and not something you can use to write your next
web app).

Still, quite an impressive piece of work!