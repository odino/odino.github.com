---
layout: post
title: "Command line spinners: the magic tale of modern typewriters and terminal movies"
date: 2019-09-22 06:54
comments: true
categories: [cli]
description: "A brief journey into what it takes to build a command line spinner / loader, with a practical example"
---

In the latest release of ABS, we introduced a package manager
that fetches an archive from GitHub and installs it locally:
like in many other command-line interfaces, we decided to
add a "loader" to accompany the process, something that looks
like this:

<video controls autobuffer playsinline><source src="/images/abs-installer-spinner.webm" type="video/webm" /></video>

I want to take a moment to reflect on how we implemented
the simple spinner you see in the video, a process that derives
from typewriters and movies -- let's get to it!

<!-- more -->

## We're going to see a picture???

{% img right https://upload.wikimedia.org/wikipedia/commons/d/dd/Muybridge_race_horse_animated.gif %}

My wife usually refers to movies as pictures, something that leaves me
confused as I'm not familiar with the term. But
when you think about it, we're often dealing with the same term in the
context of award winning movies -- who won *best picture* at the last
[academy awards](https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture)?

This happens because movies, in their essence, are simply a collection
of pictures stitched together, put *in motion* to give us the illusion
of something happening in front of our eyes while, in reality, it's just
a very quick passing of images, aided by sounds, that trick us into
believing a story is unfolding in front of our eyes.

Now, we said we wanted to create a command-line spinner, and you can
probably see where I'm going already: we can borrow the very same concept
of motion picture and apply it to the command-line -- have a few different
characters (pictures) that are swapped very quickly to give us the illusion
of an animation, kinda like this:

<div style="border: 3px dotted black; padding: 50px; margin: 50px; text-align: center">
    <p>
        <span id="spinner">THIS SPINS</span>
    </p>
    <p>
        <a onClick="spin()">start</a> - <a onClick="unspin()">stop</a>
    </p>
    <script>
        let chars = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']
        let cancel;
        function spin() {
            cancel && clearInterval(cancel)
            i = 0
            cancel = setInterval(_ => {
                if (i > chars.length - 1) {
                    i = 0
                }
                document.getElementById("spinner").innerHTML = chars[i]
                i++
            }, 50)
            
        }

        function unspin() {
            cancel && clearInterval(cancel)
        }
    </script>
</div>


The list of characters, or "pictures", we've used in this sequence is
`['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']`, but you can
try this one out yourself by playing around in the example below, where
you decide both the speed of the "animation", as well as the characters
involved (I'm using [these unicode characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters#Box_Drawing) in this example):

<div style="border: 3px dotted black; padding: 50px; margin: 50px; text-align: center">
    <p>
        <span id="spinner_custom">THIS SPINS</span>
    </p>
    <p>
        <p>
            Enter the list of comma-separated characters:
        </p>
        <textarea id="chars">▛,▜,▟,▙</textarea>
    </p>
    <p>
        <p>
            Enter the speed at which characters rotate (in ms):
        </p>
        <input type="text" value="75" id="speed" />
    </p>
    <p>
        <a onClick="spin_custom()">start / update</a> - <a onClick="unspin_custom()">stop</a>
    </p>
    <script>
        let cancel_custom
        function spin_custom() {
            cancel_custom && clearInterval(cancel_custom)
            let chars = document.getElementById("chars").value.trim().split(",")
            i = 0
            cancel_custom = setInterval(_ => {
                if (i > chars.length - 1) {
                    i = 0
                }
                document.getElementById("spinner_custom").innerHTML = chars[i]
                i++
            }, document.getElementById("speed").value)
            
        }

        function unspin_custom() {
            cancel_custom && clearInterval(cancel_custom)
        }
    </script>
</div>

Now, it should be very clear what the mechanics behind spinners
are, but we're still missing one key element -- on the command line, how can
we "override" the previous characters? This is no HTML, where a simple
`document.getElementById("id").innerHTML = "myNewChar"` does the trick,
this is the CLI we're talking about. 

This example illustrates the problem we're talking about:

<video controls autobuffer playsinline><source src="/images/fail-spinner.webm" type="video/webm" /></video>

Enter good old fashioned typewriters.

## Carriage returns

{% img right /images/typewriter.png %}

Hey there! Have you ever set your hands on an old-school typewriter?

If you say "it's all good" rather than "[it's all gucci](https://www.urbandictionary.com/define.php?term=its%20all%20gucci)",
chances are you're old enough to have, at least, seen one of them. I've
personally never used one, but a mechanism they use is the basis of how modern terminals
allow you to replace content inline.

This animation by [Haley Schbeeb](https://dribbble.com/haleyshbeeb) gives you a little bit more context --
watch closely what happens when the typewriter reaches the end of the line:

{% img center https://cdn.dribbble.com/users/1000955/screenshots/2993972/ezgif.com-gif-maker.gif %}

It "resets", right? This mechanism is called "carriage return" and it's best explained by
Wikipedia:

{% blockquote Wikipedia https://en.wikipedia.org/wiki/Carriage_return %}
Originally, the term "carriage return" referred to a mechanism or lever on a typewriter. For machines where the type element was fixed and the paper held in a moving carriage, this lever was operated after typing a line of text to cause the carriage to return to the far right so the type element would be aligned to the left side of the paper. The lever would also usually feed the paper to advance to the next line.
{% endblockquote %}

Now, typewriters need to advance one line ("line feed") as well as reset their 
position to the far left of the paper ("carriage return"). The same exact mechanisms can
be applied to your terminal too: these two operations are done through the characters
`\n` and `\r`.
Nowadays, most systems consider `\n` the equivalent of `\n\r`,
but understanding how these characters work is important to fully grasp how to
replace a character in your terminal: `\n` will "move the cursor down one line",
while `\r` will move it all the way back to the starting position of the current
line.

With this understanding, we will now be able to create a CLI spinner using this
simple loop:

* print character `X`
* print a carriage return (`\r`): the cursor is moved back to the beginning of the line
* print character `Y`, it will override character `X` since they're printed at the same position

## Put it altogether

The simple example I'm going to use is written in Go, but you could build it
in virtually any programming language. What we need to do is to simply start with a
list of characters, then print one of them at a time, followed by a carriage
return, so that the next character will be printed in place of the current one:

```go
package main

import (
    "fmt"
    "time"
)

func main() {
  chars := []string{"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"}
  i := 0
  for true {
    if i > len(chars) - 1 {
      i = 0
    }

    fmt.Printf("%s\r", chars[i])
    time.Sleep(100 * time.Millisecond)
    i++
  }
}
```

And the result is this beauty:

<video controls autobuffer playsinline><source src="/images/go-spinner.webm" type="video/webm" /></video>

Adios!