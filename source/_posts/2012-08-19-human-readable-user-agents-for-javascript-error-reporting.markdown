---
layout: post
title: "Human-readable user agents for JavaScript error reporting"
date: 2012-08-19 01:36
comments: true
categories: [JavaScript, log management]
published: false
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

With JavaScript, it's pretty easy to detect
the user agent from a client (you just need
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

Luckily, [useragentstring](http://www.useragentstring.com/) is a service which allows
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

That's pretty easy, even easier if you use the dependency
injection container of Symfony2, where you can just do the instantiation
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

Caching... scrivi di una cache di frontend

devi mettera posto due esempi e un link a inizio pagina su Guzzle, cerca PUT_EXAMPLE_HERE