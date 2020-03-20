---
layout: post
title: "Magento and PHPUnit"
date: 2010-09-11 13:43
comments: true
categories: [php, phpunit, testing]
alias: "/90/magento-and-phpunit"
---

Although there is a good [tutorial about PHPunit and Magento integration](http://www.magentocommerce.com/wiki/development/phpunit_integration_with_magento) and I'd rather using Lime ( the symfony-integrated test engine ) here I'll show you how to set up PHPUnit tests in order to improve the QA of your Magento customizations.
<!-- more -->

I'm working on **Ubuntu Jaunty**, so a few steps might be different based on your OS: nevermind, with a bit of patience you'll be able to set up your environment correctly.

First of all let's install `PHPUnit` from the repo:

```
sudo apt-get install phpunit
```

You can decide to download PHPUnit from its official website and run a single installation under a magento directory: I prefer having PHPUnit running in my whole environment because I want to test different applications, so I don't have to re-install PHPunit for all of them.

So, now let's set up our environment:

```
cd /var/www/magento/
mkdir test
mkdir test/unit
cd test/unit
sudo gedit phpunit.xml
```

and here's how you need to populate the confg file `phpunit.xml`:

``` xml
<phpunit>
    <testsuite name="projectname">
        <directory>./</directory>
    </testsuite>
</phpunit>
```

so now we can create directories and testfiles under `/var/www/magento/test/unit` and run them with a single command:

```
phpunit --configuration phpunit.xml
```

But we have no tests now! Let's create, at least, one.

Let's assume we want to test an helper file of a custom module we created, for example a "faq" module.

```
mkdir faq
mkdir faq/helper
cd faq/helper
sudo gedit ProjectnameFaqHelperDataTest.php
```

So we have to fill that file with the **standard PHPUnit structure**:

``` php
<?php

    require_once 'PHPUnit/Framework.php';

    require_once '/var/www/magento/app/Mage.php';

    class ProjectnameFaqHelperDataTest extends PHPUnit_Framework_TestCase {
        
        public function setUp (){
        }

    }
?>
```

Now we need to populate the setup function in order to have he ability to use all Magento functions:

```php
<?php

     public function setUp (){

            Mage::app('default');

            $this->object = Mage::helper("heart");
            
        }
```

After this we can test the methods of our helper: for example the `getUrl()` method we've created in order to retrieve the URL of a FAQ from its id:

``` php
<?php


     public function testGetUrl (){
            $this->assertEquals('faq/read/id/1/',$this->object->getUrl(1));
        }
```

So now we have a test covering our fictional `getUrl()` method of the class `Projectname_Faq_Helper_Data` we've created in Magento.

To run the test use the code I wrote some lines above:

```
phpunit --configuration phpunit.xml
```

If you create other directories and tesfiles under `test/unit` directory of Magento, using this command all of those will be run by PHPUnit.

That's it!