---
layout: post
title: "Introducing ABS, a programming language for shell scripting"
date: 2018-12-25 07:33
comments: true
categories: [abs, scripting, programming language, open source]
---

Over the past few days I took some time to work on a project
I had in mind for ages, a scripting alternative to Bash:
let me introduce you to the [ABS programming language](https://www.abs-lang.org/).

{% img center /images/abs-horizontal.png %}

<!-- more -->

## Why

Let me keep this brief: we all love shell programming -- automating
repetitive tasks without too much effort.

We might probably agree that shell programming is also kind of
nuts in terms of syntax:

``` bash
if [ -z $STRING ]; then
    ...
fi
```

Like, ehm, *what the hell? fi? -z? brackets?*

Fighting with Bash, or the common shell programming language,
can get intense from time to time. Writing code such as:

``` js
if (this == that) {
    parts = this.split("/").filter(...).map(...)
}
```

will bring tears to your eyes if you're using the shell.

Now, you can do similar things with any mainstream programming
languages (the example above is valid javascript): what these
languages are not great at is their integration with the
underlying system -- a [shell is simply much more coincise / powerful](https://stackoverflow.com/questions/796319/strengths-of-shell-scripting-compared-to-python)
from that perspective.

Imagine you could run code like:

``` bash
host = $(hostname)

if (host == "johns_computer") {
    ...
}
```

Well, you don't have to "imagine" no more: ABS is a language that
combines quick and simple system commands with a more elegant syntax.

Think of it as the best thing since candy, only to remember this
is the definition ABS' author gave you. But seriously, it's pretty
darn convenient.

Don't believe me? Read on!

## Examples

I'm a firm believer in the "*show me the code!*" mantra, so let's quickly
get to it. Running shell commands is extremely easy in abs:

``` bash
# Get the content of your hostfile
$(cat /etc/hosts)
```

and pipes work too:


``` bash
# Check if a domain is in your hostfile
$(cat /etc/hosts | grep domain.com | wc -l)
```

At this point we can just capture the output of our
command and script over it:

``` bash
# Check if a domain is in your hostfile
matches = $(cat /etc/hosts | grep domain.com | wc -l)

# If so, print an awesome string
if matches.int() > 0 {
  echo("We got ya!")
}
```

It won't happen, but let's say that *an error* happens:

``` bash
# Check if a domain is in your hostfile
matches = $(cat /etc/hosts | grep domain.com | wc -l)

if !matches.ok {
    echo("How do you even...")
}

# If so, print an awesome string
if matches.int() > 0 {
  echo("We got ya!")
}
```
We could make this a bit more general:

``` bash
$ cat script.abs
# Usage $ abs script.abs domain.com
# Check if a domain is in your hostfile
domain = arg(2)
matches = $(cat /etc/hosts | grep $domain | wc -l)

if !matches.ok {
    echo("How do you even...")
}

# If so, print an awesome string
if matches.int() > 0 {
  echo("We got %s!", domain)
}
```

Now, strings are fairly boring, so we can try something
more fun:

``` bash
# Say we're getting some JSON from a command
x = $(echo '{"some": {"dope": "json"}}')
x.json().some.dope # "json"

# Arrays, you say?
tz = $(cat /etc/timezone) # "Asia/Dubai"
parts = tz.split("/") # ["Asia", "Dubai"]

# You better destructure the hell out of that!
[continent, city] = tz.split("/")
```

...and so on. There are loads of "regular" things you
can do with ABS, so I won't focus much on those --
let me show you the weirder parts instead:

``` bash
# Avoiding the bug that happened because
# we forgot to compare strings case-insensitively
"HELLO" ~ "hello" # true

# Just range
1..3 # [1, 2, 3]

# Combined comparison operator (thanks Ruby!)
5 <=> 5 # 0
5 <=> 6 # -1
6 <=> 5 # 1

# Classic short-circuiting
1 && 2 # 2
1 || 2 # 1
```

You can skim through the whole [documentation](https://www.abs-lang.org/introduction/why-another-scripting-language)
within 15 minutes: ABS' aim is not to be a general-purpose, feature-loaded language,
so the surface isn't that wide. In addition, if you've worked with languages such as JavaScript,
Python or Ruby you won't have troubles getting used to ABS.

## What's going to happen now?

You can head over to [ABS' website](https://www.abs-lang.org/), and
learn more about the language. The brave ones will instead make a trip
to [ABS's github repo](https://github.com/abs-lang/abs) and
[download a release](https://github.com/abs-lang/abs/releases) to install
it locally.

The braver ones will just:

``` bash
bash <(curl https://www.abs-lang.org/installer.sh)
```

*(you might need to sudo right before that)*

Which one will you be?