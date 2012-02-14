---
layout: post
title: "Basic HTTP authentication on a symfony backend"
date: 2010-09-17 11:09
comments: true
categories: [symfony. PHP]
alias: "/263/basic-http-authentication-on-a-symfony-backend"
---

Since I'm not a ninja from this point of view, any better solution is welcome.
<!-- more -->

You only need to edit your application's front controller:

``` php

<?php

if ($_SERVER['PHP_AUTH_USER'] !== 'username' || $_SERVER['PHP_AUTH_PW'] !== 'password')
{    
  header('WWW-Authenticate: Basic realm="Site Administration Area"');
  header('Status: 401 Unauthorized');
  /* Special Header for CGI mode */
  header('HTTP-Status: 401 Unauthorized');
}
else
{
  require_once(dirname(__FILE__).'/../config/ProjectConfiguration.class.php');
 
  $configuration = ProjectConfiguration::getApplicationConfiguration('backend', 'prod', false);
  sfContext::createInstance($configuration)->dispatch();
}
```

The IF block is not something I've done by myself ( although it's really easy ), I've taken it from an article on [PHPnerds](http://www.phpnerds.com/article/securing-php-files-using-http-authentication/2): since the code in the article has a **huge flaw** don't use it.

The problem lies in the IF conditions:

```
$_SERVER['PHP_AUTH_USER'] !== 'username' && $_SERVER['PHP_AUTH_PW'] !== 'password'
```

which are concatenated by an AND and not an OR, leading through a possible unauthorized authentication knowing only the username **or** the password ( the negative  operator ! supports the trick, damn ).

A better solution is to use a more direct approach:

``` php
<?php

if ($_SERVER['PHP_AUTH_USER'] == 'username' && $_SERVER['PHP_AUTH_PW'] == 'password')
```
