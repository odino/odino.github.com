---
layout: post
title: "Deliver content as XML with Zend Framework"
date: 2012-02-14 12:00
comments: true
categories: [Zend Framework, PHP]
alias: "/78/deliver-content-as-xml-with-zend-framework"
---

In the [DevZone of ZF](http://devzone.zend.com/article/884) there's a good tutorial: my aim is to give you a silly example of how to deliver content as XML in ZF and/or Magento.
<!-- more -->

Create a simple action in your controller:

``` php
<?php

public function xmlAction()
{
    ...
}
```

which we're gonna use to construct a single-node ( sooo silly example ) XML structure.

First we create the DOMDocument:

``` php
<?php

$xml = new DOMDocument('1.0', 'utf-8');
```

then we create our nodes:

``` php
<?php

$xml->appendChild($xml->createElement('nodename', 'nodevalue'));
```

We close this routine operations telling that the output has to be saved as XML, but also that the headers might fit XML requirements:

``` php
<?php

$output = $xml->saveXML();
$this->_response->setHeader('Content-Type', 'text/xml; charset=utf-8')->setBody($output);
```

That's it!
