---
layout: post
title: "Integrating Zend Framework 2 in Symfony 1.4"
date: 2011-07-21 14:14
comments: true
categories: [symfony, Zend Framework]
alias: "/370/integrating-zend-framework-2-in-symfony-1-4"
---

With PHP 5.3 the [new era of PHP frameworks](http://blog.webspecies.co.uk/2011-05-23/the-new-era-of-php-frameworks.html) has begun, and things are really, for example, simpler to integrate, thanks to the [PSR0](http://groups.google.com/group/php-standards/web/psr-0-final-proposal), which is the standard autoloader adopted by the community.
<!-- more -->

The PSR0 is, obviously, not supported by the symfony 1.4 framework, which was released far before PHP 5.3 was ready, but it's not *that* difficult to integrate PSR0-compliant projects in Sf1.4.

If you want, for example, to use the [Zend Framework 2](https://github.com/zendframework/zf2) in symfony you just need a few quick steps: first of all, copy the standard [SplClassLoader](https://gist.github.com/221634) in your symfony project ( lib/autoload? ), then require it in your `projectConfiguration.class.php`:

``` php
<?php

require_once dirname(__FILE__).'/../lib/vendor/symfony/lib/autoload/sfCoreAutoload.class.php';
require_once dirname(__FILE__).'/../lib/autoload/SplClassLoader.php';
sfCoreAutoload::register();
```

then, put the Zend Framework wherever you want ( `lib/vendor/ZF2`? ) and re-edit the `projectConfiguration`:

``` php
<?php

...
sfCoreAutoload::register();
$classLoader = new SplClassLoader('ZF2', '/path/to/zend/framework/2');
$classLoader->register();
```

and you're done!

You can start using the Zend Framework 2 using namespaces inside your existing symfony code, without breaking anything:

``` php
<?php

use ZF2\Service\Twitter;
class twitterActions extends sfActions
{
  public function executeTwitterLogin(sfWebRequest $request)
  {
    $service = new Twitter();
```
