---
layout: post
title: "Human-readable user agents for JavaScript error reporting"
date: 2012-08-22 09:40
comments: true
categories: [javascript, log management]
published: true
---

Some time ago I published a few posts
on logging, one on how to [report JavaScript errors](/logging-javascript-errors/) and another one
which illustrates how to [log on New Relic with Monolog](/using-monolog-for-php-error-reporting-on-new-relic/).

In this post I'd like to go even
further with JavaScript error logging
and tell you how we - at [Namshi](http://namshi.com) -
are trying to ease frontend debugging
across multiple browsers.

<!-- more -->

## User agents, the gotchas

With JavaScript, it's pretty easy to detect
the user agent from a client ( you just need
to access `navigator.userAgent`), the problem
is that user agents are one of the most incredible
*gotchas* in web development.

For example, how would you guess that

```
Mozilla/5.0
(Windows; U; Windows NT 6.1; WOW64; en-US; rv:2.0.4)
Gecko/20120718 AskTbAVR-IDW/3.12.5.17700 Firefox/14.0.1
```

represents Firefox 14 on Windows 7?

Let me tell you, **you wouldn't**, that's why
you should convert user agents in a human-readable
format for the people who are going to debug
the frontend.

## Converting user agents with remote calls

Luckily, [UserAgentString](http://www.useragentstring.com/) is a service which allows
you to query them whenever you need to retrieve useful
and **meaningful** informations from a user agent string;
combined with [Guzzle](http://guzzlephp.org/), you can directly have meaningful
JavaScript errors' reports with a few lines of code.

For example, this is a simple class which retrieves the informations from
the service:

``` php
<?php

namespace Vendor\Service;

use Guzzle\Http\ClientInterface;

class UserAgentConverter
{
    const URL_USERAGENT_API = 'http://www.useragentstring.com/';
    const BROWSER_INFO      = '%s %s on %s';
    
    protected $client;
    
    /**
     * Instantiates the service and injects the HTTP client that will be used
     * to perform requests.
     * 
     * @param ClientInterface $client 
     */
    public function __construct(ClientInterface $client)
    {
        $this->client = $client;
    }
    
    /**
     * Retrieves a human-readable string identifying the $userAgent for error
     * reporting (ie Internet Explorer 8 on Windows 7).
     * 
     * @param string $userAgent
     * @return string|null
     */
    public function lookup($userAgent)
    {
        $request  = $this->client->post(self::URL_USERAGENT_API, null, sprintf('uas=%s&getJSON=all', $userAgent));
        $response = $request->send();
        
        if ($response->getStatusCode() === 200) {
            return json_decode($response->getBody(true), true);
        }
        
        return null;
    }
}
```

and you can use it like this:

``` php
<?php

$ua         = 'Mozilla/5.0 (Windows; U; Windows NT 6.1; WOW64; en-US; rv:2.0.4) Gecko/20120718 AskTbAVR-IDW/3.12.5.17700 Firefox/14.0.1';
$uaService  = new Vendor\Service\UserAgentConverter(new Guzzle\Http\Client());
$userAgent  = $uaService->lookup($ua);

if ($userAgent) {
	// outputs "Firefox 14.0.1 on Windows 7"
	echo sprintf(
	    "%s %d on %s", 
	    $userAgent['agent_name'],
	    $userAgent['agent_version'],
	    $userAgent['os_name']
	);
}
```

That's pretty easy, even easier if you use the
[dependency injection container of Symfony2](/using-the-symfony2-dependency-injection-container-as-a-standalone-component/),
where you can just do the instantiation
in a config file:

``` bash container.yml
services:
  http.client:
    class: "Guzzle\\Http\\Client"
  useragent.converter:
    class: "Vendor\\Service\\UserAgentConverter"
    arguments:
      client: @http.client
```

``` php The one liner to get the user agent's informations
<?php

$container->get('useragent.converter')->lookup($ua);
```

## Caching

At this point it becomes obvious that you should put
a **caching layer** in front of the `UserAgentConverter`
since you don't want to always query a remote service
to retrieve informations that you already have:
something like Redis should perfectly do the job,
as a cache - in this scenario - is essential, needs
to be as fast as hell and you don't need a SLA with it,
so if the Redis server is down you are gracefully
degradating: at the same time, Memcache can be a good candidate
to substitute Redis, but remember that you will
renounce to persistence, since you won't be able to
store informations on the disk as you would
do with Redis.

The implementations is very trivial:

``` php Adding a caching layer to our code
<?php

$ua         = 'Mozilla/5.0 (Windows; U; Windows NT 6.1; WOW64; en-US; rv:2.0.4) Gecko/20120718 AskTbAVR-IDW/3.12.5.17700 Firefox/14.0.1';
$cache      = new CacheProvider();
$userAgent  = $cache->lookup($ua)

if (!$userAgent) {
	$uaService  = new Vendor\Service\UserAgentConverter(new Guzzle\Http\Client());
	$userAgent  = $uaService->lookup($ua);
}

if ($userAgent) {
	$cache->store($ua, $userAgent);

	// outputs "Firefox 14.0.1 on Windows 7"
	echo sprintf(
	    "%s %d on %s", 
	    $userAgent['agent_name'],
	    $userAgent['agent_version'],
	    $userAgent['os_name']
	);
}
```