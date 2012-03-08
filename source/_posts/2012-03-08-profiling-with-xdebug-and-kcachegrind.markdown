---
layout: post
title: "Profiling with Xdebug and Kcachegrind"
date: 2010-09-11 13:40
comments: true
categories: [profiling, xdebug]
alias: "/5/profiling-with-xdebug-and-kcachegrind"
---

Here you can find the instructions for installing Xdebug and Kcachegrind to profile and debug PHP applications.
<!-- more -->

Supposing that you're using the penguin, with Debian or *buntu, there are a few steps ( very easy steps ) that you have to do in order to set up an environment which helps you on debugging PHP and profiling scripts.

First of all install the software:

``` 
sudo apt-get install php5-xdebug

sudo apt-get install kcachegrind
```

then modify your `php.ini`:

``` 
sudo gedit /etc/php5/apache2/php.ini
```

inserting these lines of code:

``` 
; Xdebug params
xdebug.remote_enable = On
xdebug.profiler_enable=1
xdebug.profiler_output_dir = "/var/benchmark/"
zend_extension="/usr/lib/php5/20060613+lfs/xdebug.so"
xdebug.auto_trace = On
```

Remember to change, obviously, the values for `profiler_output_dir` and `zend_extension`.

TIP: to get `zend_extension` value use:

``` 
locate xdebug.so
```

Then remember to give apache write premissions of the profiler output directory and restart it:

``` 
sudo /etc/init.d/apache2 restart
```

Now you can navigate your local applications and find generated files in the output directory: you need to open these files with Kcachegrind and...   ...profile them!
