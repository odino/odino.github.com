---
layout: post
title: "What's up with my gem install? symbol SSLv2_method, version OPENSSL_1.0.0 not defined"
date: 2017-03-14 17:33
comments: true
categories: [ruby, docker, gem]
description: "An easy workaround due to a 'bad' version of OpenSSL"
---

Ever met this guy?

```
ERROR:  Loading command: install (LoadError)
	/usr/lib/x86_64-linux-gnu/ruby/2.1.0/openssl.so: symbol SSLv2_method, version OPENSSL_1.0.0 not defined in file libssl.so.1.0.0 with link time reference - /usr/lib/x86_64-linux-gnu/ruby/2.1.0/openssl.so
ERROR:  While executing gem ... (NoMethodError)
    undefined method `invoke_with_build_args' for nil:NilClass
```

<!-- more -->

I have encountered it in a bunch of docker containers that are running ubuntu
and doing a gem install. Looks like we're trying to install a ruby / rubygems
version that's not compatible with the pre-configured OpenSSL shipped on
our Ubuntu machine -- so the easy fix is:

```
apt-get update
apt-get install openssl
```

which will upgrade OpenSSL.

An alternative method (thanks to [Mohamed](https://medium.com/@MohamedAmin88)):

```
apt-get install -y libssl-dev
```

which I assume takes care of updating OpenSSL as well.

Cheers!
