---
layout: post
title: "SfWidgetFormChoice* with spicy empty values"
date: 2010-10-25 11:02
comments: true
categories: [symfony]
alias: "/227/sfwidgetformchoice-with-spicy-empty-values"
---

To pass empty values to the widgets based on choices is really simple with symfony.
<!-- more -->

For example, the `sfWidgetFormDoctrineChoice` accepts a `with_empty` option, which can be a boolean or a string:

``` php
<?php

new sfWidgetFormDoctrineChoice(array('model' => 'ModelName', 'add_empty' => ...));
```

which renders the empty option according to the following rules:

```
given true:
  null => ''
given a string:
  null => 'string' 
```

The other widget I was working on, `sfWidgetFormI18nDate`, accepts an array to configure empty options:

``` php
<?php

new sfWidgetFormI18nDate(array('culture' => 'en', 'empty_values' => $empty_values));
```

with the following format:

```
Array
  day:   Day
  month: Month
  year:  Year
```

and the rendered form is something like this:

{% img center /images/empty_value_form.png %}