---
layout: post
title: "Headers already sent... what's up PHPUnit?"
date: 2010-09-11 13:50
comments: true
categories: [phpunit]
---

Here we go with a simple workaround to resolve a bad error that you can encounter with PHPUnit: `headers already sent` and failure of the tests.
<!-- more -->

It happens, sometimes, that you have to work with the headers but your tests fail because PHPUnit sends headers before your application, and your `session_start()` ( or similar ) call produces the error:

``` 
headers already sent by (output started at...
```

So you need to include a `session_start()` before PHPUnit is executed.

This can be done with the latest releases of PHPUnit ( > 3.3 ) using a bootstrap file.

Talking to *buntu users: installing PHPUnit via package manager (or `apt-get`) will install the `3.2.x` version, not compatible with the bootstrapping stuff we need to do.

You can read an amazing tutorial on [installing PHPUnit via pear on *buntu](http://grover.open2space.com/node/243).

So after having succesfully installed PHPUnit ( today the lates package I could retrieve via PEAR was `3.4.9` )... let's create this ( very silly ) bootstrap:

```
cd path/to/my/project/test/unit
sudo gedit bootstrap.php
```

filling the file with a simple:

``` php
<?php
    session_start();
?>
```

So now you can lunch your tests using this syntax:

```
phpunit --bootstrap bootstrap.php MyPhpunitTest(.php)
```

If you use an XML config file you can use:

```
phpunit --bootstrap bootstrap.php --configuration phpunit.xml
```

or, adding this

```
bootstrap="bootstrap.php"
```
in the opening tag of the XML ( `<phpunit>` ), simply this:

```
phpunit --configuration phpunit.xml
```

as you normally do.