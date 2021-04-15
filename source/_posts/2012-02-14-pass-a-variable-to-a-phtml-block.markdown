---
layout: post
title: "Pass a variable to a .phtml block"
date: 2010-09-11 13:57
comments: true
categories: [magento]
alias: "/76/pass-a-variable-to-a-phtml-block"
---

Here's a simple snippet to pass a PHP variable from a controller ( or whatever magento file ) to a block, using the `createBlock()` method.
<!-- more -->

When you call a block:

``` php
<?php

$this->getLayout()->createBlock('module/template')
->setData('key', 'value')
->setTemplate('mediarepository/latest.phtml')->toHtml();
```

with the `setData()` method you'll be able to acces your variable with:

``` php
<?php

$this->key;
```