---
layout: post
title: "Contributing to the Zend Framework via GitHub"
date: 2011-07-18 13:05
comments: true
categories: [ZF2, Github]
alias: "/368/contributing-to-the-zend-framework-via-github"
---

So, I managed to integrate [some crap I daily write into the Zend Framework 2](https://github.com/zendframework/zf2/commit/fe60cf8deb9888adfc7757dcec536dd24c021653) git repository, and here's how to do that.
<!-- more -->

## Code

The "real" repository of the ZF2 isn't on Github but, someway, they are managing to integrate [pull requests from the Github mirror](https://github.com/zendframework/zf2) to the [real repo hosted by Zend Technologies](http://git.zendframework.com/?a=summary&p=zf).

Thanks to this, you only need to fork it and work on what you'd like to change, improve or implement.

From my viewpoint, I needed to integrate into the `Zend\Service\Twitter` an API to retrieve the users who retweeted a certain tweet, identified by an ID.

So, first thing you should do is take a [look at the tests of the class you are working on](https://github.com/zendframework/zf2/blob/fe60cf8deb9888adfc7757dcec536dd24c021653/tests/Zend/Service/Twitter/TwitterTest.php) to confidently understand how the hell your code can be tested: after doing so, you can [write a test](https://github.com/zendframework/zf2/blob/fe60cf8deb9888adfc7757dcec536dd24c021653/tests/Zend/Service/Twitter/TwitterTest.php#L604) which should cover your functionality.

Then you can run your tests with PHPUnit:

``` bash Launching your test with PHPUnit
phpunit --bootstrap tests/Bootstrap.php tests/Zend/Service/Twitter/TwitterTest.php
```

and see that something is failing :)

So, here's the actual work, you can implement your functionality using ZF2 coding standards without messing around things: in my case, it was all about [less than 5 LoCs](https://github.com/zendframework/zf2/blob/fe60cf8deb9888adfc7757dcec536dd24c021653/library/Zend/Service/Twitter.php#L906).

## Formalities

Good: you have just done a work for the PHP community, and you are ready to ask an integration in the real ZF2 codebase: be aware, you need a couple formalities for completing the job.

First of all, download the [CLA](http://framework.zend.com/cla) ( contributor license agreement ): print, fill, scan and send it to `cla@zend.com`.

If this seems weird to you, consider the fact that you are just signing a paper telling that you are not submitting copyrighted code and so on: so, Zend Framework, is just basically defending itself from jackasses :)

Try to understand it, please.

After that, you'll be contacted from a lady at Zend Technologies asking to create an account on ZF bug tracker: 2 minutes and you're done.

## Github

Ready to go?

Go to your github forked repository and [create a pull request](https://github.com/zendframework/zf2/pull/221), better if you include a couple of informations with it.

That's all, folks!
