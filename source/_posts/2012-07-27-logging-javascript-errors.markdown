---
layout: post
title: "Logging JavaScript errors"
date: 2012-07-27 09:00
comments: true
categories: [JavaScript, log management]
---

In one of my latest posts I talked about
[using Monolog to remotely log stuff on New Relic](/using-monolog-for-php-error-reporting-on-new-relic/):
getting a bit deeper on log management
systems, here's how we managed to report
JavaScript errors on our logs.

<!-- more -->

## A note on JavaScript errors

It may not sound obvious, but errors,
in JavaScript, can be pretty nasty, since
it's an - almost completely{% fn_ref 1 %} - client-dependent
technology that can react differently to
your code based on the client's platform.

Cross-browser testing may not always be
performed *that* accurately, so you should
definitely start tracking JS error that may
happen of different clients.

## The concept

This is **totally not an idea of mine**: it
comes from a pretty smart [blog post which illustrates the main concept](http://devblog.pipelinedeals.com/pipelinedeals-dev-blog/2012/2/12/javascript-error-reporting-for-fun-and-profit-1.html):
when a JS error is encountered, you trigger an HTTP request
to a URL that collect the data transmitted
within that request and logs it with
server-side code.

``` javascript How to trigger JS error reporting
window.MaximumErrorCount = 5;

window.onerror = function(errorMsg, file, lineNumber) {
  window.errorCount || (window.errorCount = 0);

  if (window.errorCount <= window.MaximumErrorCount) {
    jQuery.post('/jsError/', {
        errorMessage:   errorMsg, 
        file:           file, 
        url:			window.location.href, 
        lineNumber:     lineNumber, 
        ua:             navigator.userAgent
    });
  }
}
```

So, at the end, you only need to add some basic
server-side code to handle the reported data:

``` php How to handle reported informations
<?php

class ErrorController extends Controller
{
	const MESSAGE_LOG_JAVASCRIPT = 'A javascript error "%s" has been encountered at the URL %s on file %s:%s by an agent of type %s';

	public function logJavaScriptAction($postData)
	{
		$logMessage = sprintf(
			self::MESSAGE_LOG_JAVASCRIPT,
			$postData['errorMessage'],
			$postData['url'],
			$postData['file'],
			$postData['lineNumber'],
			$postData['ua']
		);

		$this->getLogger()->addError($logMessage);
	}
}
```

You may want to write some additional
code to only report errors that you should
really fix: based on the user-agent, for
example, you can ignore errors triggered
on `MSIE 7.0`/`MSIE 6.0`.

## All in all...

This has been a great solution for us,
since we could easily keep track of JS
code which was causing errors due to:

* lack of compatibility between developers'/users'
platforms
* typos and small errors
* tricky situations in which our code depends on
3rd party scripts that would break our functionality
whenever they are not available/cause an error upon
execution

{% footnotes %}
  {% fn NodeJS %}
{% endfootnotes %}