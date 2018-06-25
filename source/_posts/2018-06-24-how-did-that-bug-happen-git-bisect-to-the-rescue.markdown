---
layout: post
title: "How did that bug happen? Git bisect to the rescue!"
date: 2018-06-24 23:47
comments: true
categories: [git, debugging, vcs]
description: "A brief guide to git bisect, a handy utility that helps you which commits introduced a bug in your software."
---

{% img right /images/git.png %}

`git bisect` is a very handy command that lets you [isolate which commit introduced a bug](https://git-scm.com/docs/git-bisect):
you tell it which version of your repository was bug-free and it runs a [binary search](https://en.wikipedia.org/wiki/Binary_search_algorithm)
between your current commit and the one that seems to have bug, asking you to
confirm on whether the bug seems to be there at each step of the search.

Curious? Let's see it in action!

<!-- more -->

Let's first create a repository with a bunch of "fake" commits:

```
/tmp ᐅ mkdir test-repo

/tmp ᐅ cd test-repo

/tmp/test-repo ᐅ git init
Initialized empty Git repository in /tmp/test-repo/.git/

/tmp/test-repo (master ✔) ᐅ touch test.txt

/tmp/test-repo (master ✔) ᐅ for i in $(seq 1 100); do echo $i > test.txt && git add test.txt && git commit -m "Now: $i"; done
[master (root-commit) 28ea863] Now: 1
 1 file changed, 1 insertion(+)
 create mode 100644 test.txt
[master fc57245] Now: 2
 1 file changed, 1 insertion(+), 1 deletion(-)
[master 81e693c] Now: 3
 1 file changed, 1 insertion(+), 1 deletion(-)
...
...
...
[master b68f338] Now: 100
 1 file changed, 1 insertion(+), 1 deletion(-)
```

Let's say that the commit that introduced our bug is where the number in the `test.txt`
file is higher than 9 (so the commit that starts at 10 is the culprit) -- how would we find it in real life?

Enter `git bisect` -- let's tell git that:

* we want to start *bisecting*
* our current, latest commit seems to be broken
* a commit back in the history does not seem to have the bug

...and let's have git do the heavy-lifting for us:

```
/tmp/test-repo (master ✔) ᐅ git bisect start

/tmp/test-repo (master ✔) ᐅ git bisect bad # Our last commit seems to have a bug

/tmp/test-repo (master ✔) ᐅ git checkout 28ea863 # let's go back to a commit we're sure does not have the bug
Note: checking out '28ea863'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 28ea863... Now: 1

/tmp/test-repo (28ea863 ✔) ᐅ git bisect good
Bisecting: 49 revisions left to test after this (roughly 6 steps)
[bcba603c516783f6ad42b9410f6889e10aea0717] Now: 50
```

Now git will checkout right in the middle of those 2 commits -- it asks you to
test your changes and ask you whether this commit is good or bad. Let's go ahead:


```
/tmp/test-repo (bcba603 ✔) ᐅ cat test.txt
50

/tmp/test-repo (bcba603 ✔) ᐅ git bisect bad
Bisecting: 24 revisions left to test after this (roughly 5 steps)
[b276476e9f1d989f011db4fefc5b92df1685b313] Now: 25

/tmp/test-repo (b276476 ✔) ᐅ cat test.txt
25

/tmp/test-repo (b276476 ✔) ᐅ git bisect bad
Bisecting: 11 revisions left to test after this (roughly 4 steps)
[ba653f4df25a0192d83c813e14ca5851653ab30f] Now: 13

/tmp/test-repo (ba653f4 ✔) ᐅ cat test.txt  
13

/tmp/test-repo (ba653f4 ✔) ᐅ git bisect bad
Bisecting: 5 revisions left to test after this (roughly 3 steps)
[a77f93ed29fe3bfaac69c686ce140a4284acee68] Now: 7

/tmp/test-repo (a77f93e ✔) ᐅ cat test.txt  
7

/tmp/test-repo (a77f93e ✔) ᐅ git bisect good
Bisecting: 2 revisions left to test after this (roughly 2 steps)
[affade823e7f0cb72a1a97052f700c31dc90cfee] Now: 10

/tmp/test-repo (affade8 ✔) ᐅ cat test.txt   
10

/tmp/test-repo (affade8 ✔) ᐅ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 1 step)
[11e5f969458ad51f4009e2e3ac81f38d1ede6d07] Now: 9

/tmp/test-repo (11e5f96 ✔) ᐅ cat test.txt  
9

/tmp/test-repo (11e5f96 ✔) ᐅ git bisect good
affade823e7f0cb72a1a97052f700c31dc90cfee is the first bad commit
commit affade823e7f0cb72a1a97052f700c31dc90cfee
Author: odino <some.one@gmail.com>
Date:   Sun Jun 24 23:29:02 2018 +0400

    Now: 10

:100644 100644 ec635144f60048986bc560c5576355344005e6e7 f599e28b8ab0d8c9c57a486c89c4a5132dcbd3b2 M	test.txt
```

Amazing, `git bisect` found out the exact commit our bug was introduced -- nothing more,
nothing less: just an amazing trick that can save you hours of debugging!
