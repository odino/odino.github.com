---
layout: post
title: "Unit testing your symfony forms"
date: 2012-08-01 14:01
comments: true
categories: [symfony, testing]
alias: "/374/unit-testing-your-symfony-forms"
---

Tired of slow test suites? Not enough RAM to satisfy both tests and your browser? Have you ever committed without seeing tests results because "It 18.30!"?

Good, this one is totally for you.
<!-- more -->

## The problem

You all know how symfony1 test suites become a problem as you have lots of tests: when I say lots, I mean 30, 40 tests, which should not be *that* huge amount of tests.

A possible solution for this problem is not to test forms with functional tests, when you have tons of:

```
->click('Submit', array('form' => array('name' => 'Alessandro') ... ))

...

with('form')->begin()->
  hasError(true)->
  isError(...)
```

but to use unit tests.

How could this be possible? Well, thanks to the form framework, all forms, widgets and validators are, obviously, objects, so they are easy to test as a unit.

Let's imagine this scenario: I want to test that a form has one and one widget only, in which the user can type multiple email addresses, separated by comma.

## Testing the form

Create the empty form under `lib/form` directory:

``` php
<?php

class MultipleMailForm extends BaseForm
{
}
```

Let's write the test, which checks that the form has 1 widget and 1 validator:

``` php
<?php

include(dirname(__FILE__).'/../../bootstrap/unit.php');
$t = new lime_test(); 
$f = new MultipleMailForm();
$ws = $f->getWidgetSchema();
$vs = $f->getValidatorSchema();

$t->isa_ok($ws['email_addresses'], 'sfWidgetFormInput');
$t->isa_ok($vs['email_addresses'], 'MultipleInlineEmailAddressesValidator');
$t->is(1, count($ws));
$t->is(1, count($vs));
```

Run the test ( `php symfony test:unit MultipleMailForm` ): you will se that it's gonna fail.

Now implement your feature:

``` php
<?php

class MultipleMailForm extends BaseForm
{
  public function configure()
  {
    parent::configure();
    
    $ws = $this->getWidgetSchema();
    $ws['email_addresses'] = new sfWidgetFormInput();
    
    $vs = $this->getValidatorSchema();
    $vs['email_addresses'] = new MultipleInlineEmailAddressesValidator();
  }
}
```

Create the validator class under lib/validator:

``` php
<?php

class MultipleInlineEmailAddressesValidator extends sfValidatorEmail
{
}
```

If you re-launch the test, a green bar will appear :)

As you might notice, now the test isn't meaningful: we know how many widgets/validators we have but we didn't tested in which conditions the form is valid, which kind of data it accepts and so on.

To do so, you have 2 things to do: first, bind the form in the test with an array of values and then check the `isValid()` method; second, test your custom validator.

## Testing the validator

Create a test for the validator:

``` php
<?php

include(dirname(__FILE__).'/../../bootstrap/unit.php');
 
$t = new lime_test();
$v = new MultipleInlineEmailAddressesValidator();
 
try
{
  $t->is($v->clean('alessandro.nadalin@mymail.com'), true); 
}
catch (Exception $e)
{
  $t->fail('The validator accepts a single email address');
}
 
try
{
  $t->is($v->clean('alessandro.nadalin@gmail.com, luca@gmail.com'), true); 
}
catch (Exception $e)
{
  $t->fail('The validator accepts multiple email addresses');
}
 
try
{
  $t->is($v->clean('alessandro.nadalin@mymail.com,luca@gmail.com'), true); 
}
catch (Exception $e)
{
  $t->fail('The validator accepts multiple email addresses, without spaces');
}
 
try
{
  $t->is($v->clean(' alessandro.nadalin@mymail.com ,    luca@gmail.com  '), true); 
}
catch (Exception $e)
{
  $t->fail('The validator accepts multiple email addresses, without caring about spaces');
}
 
try
{
  $t->is($v->clean('alessandro.nadalinmymail.com'), true); 
  $t->fail('Exception should be raised');
}
catch (Exception $e)
{
  $t->pass('The validator fails if an address is wrong');
}
 
try
{
  $t->is($v->clean('alessandro.nadalin@mymail.com, luca@gmail.com2'), true); 
  $t->fail('Exception should be raised');
}
catch (Exception $e)
{
  $t->pass('The validator fails if a multiple address is wrong');
}
```

which checks the validator under lots of circumstances ( single email, multiple emails, multiple emails some good some wrong, etcetera ): launching it, you should get a red bar.

Now you can implement the validator, overriding the `doClean()` method:

``` php
<?php

protected function doClean($value)
{
  $addresses = explode(',', $value);
  $emails    = array();
 
  foreach ($addresses as $address)
  {
    $emails[] = parent::doClean(trim($address)); 
  }

  return $emails;
}
```

Green bar all the way.
