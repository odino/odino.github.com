---
layout: post
title: "Managing PHP dependencies with composer"
date: 2012-01-25 11:44
comments: true
categories: [PHP]
---

<!-- more -->
{% img right /images/white.puzzle.jpg %}

{% blockquote Henry Bergius http://bergie.iki.fi/blog/composer_solves_the_php_code-sharing_problem/ Composer solves the PHP code-sharing problem %}
In PHP we've had a lousy culture of code-sharing. Because depending on code from others as been tricky, every major PHP application or framework has practically had to reimplement the whole world. Only some tools, like PHPUnit, have managed to break over this barrier and become de-facto standards across project boundaries. But for the rest: just write it yourself.
{% endblockquote %}

Managing dependencies between pieces of software, in PHP, hasn't always
been a relief: we had [PEAR](http://pear.php.net/) and [PECL](http://pecl.php.net/)
{% footnote_ref 1 %}
with their workflows and problems while, in other ecosystems, the
solution to this problem has been solved in better ways, like
NodeJS's [NPM](http://npmjs.org/).

## Composer

Composer is the nifty missing brick in managing PHP dependencies:
inspired to what's hot in Ruby's and NodeJS's ecosystems, it is a
simple but powerful packaging system specifically written for PHP.

Born and mantained from a [few personalities](https://github.com/composer/composer/contributors)
of the Symfony2 community, it's really easy to use and install.

First of all, go to the root directory of your project and
download composer:

``` bash
wget http://getcomposer.org/composer.phar
```

then write a `composer.json` file describing your project's dependencies:

```
{
    "name": "vendor/NutsAPI",
    "type": "library",
    "description": "PHP SDK for IFeelNuts APIs.",
    "keywords": ["nuts", "API", "SDK"],
    "license": "MIT",
    "authors": [
        {
            "name": "Alessandro Nadalin",
            "email": "alessandro.nadalin@gmail.com",
            "homepage": "http://www.odino.org"
        }
    ],
    "autoload": {
        "psr-0": {
            "NutsAPI": "src/"
        }
    },
    "require": {
        "php": ">=5.3.2",
        "kriswallsmith/Buzz": ">=0.5"
    }
}
```

There are 3 main parts in the `composer.json`, the first one describing
your project (if you want to put that in Packagist - something I will
later explain):

```
{
    "name": "vendor/NutsAPI",
    "type": "library",
    "description": "PHP SDK for IFeelNuts APIs.",
    "keywords": ["nuts", "API", "SDK"],
    "license": "MIT",
    "authors": [
        {
            "name": "Alessandro Nadalin",
            "email": "alessandro.nadalin@gmail.com",
            "homepage": "http://www.odino.org"
        }
    ],
    ...
}
```

the second one is the **autoloading specification**:

```
"autoload": {
    "psr-0": {
        "NutsAPI": "src/"
    }
}
```

this is basically awesome because it lets you specify the
autoloading standard used for your library (I strongly suggest
you to follow the [PSR-0 convention](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md)):
in the example we see that our `NutsAPI` namespace will be
autoloaded in the `src` directory.

You can also specify **nested namespaces**:

```
"autoload": {
    "psr-0": {
        "Doctrine\\Common": "src/Doctrine/Common"
        "Doctrine\\DBAL":   "src/Doctrine/DBAL/Experiments"
    }
}
```

The last part of the file is the most important one, describing
which libraries you depend on:

```
"require": {
    "php": ">=5.3.2",
    "kriswallsmith/Buzz": ">=0.5"
}
```

as you see, this directive tells composer that it should download
the [Buzz](https://github.com/kriswallsmith/Buzz) library and
force a certain revision to be used; note that composer is also
able to verify that your PHP version is ok too.

Once you completed the `composer.json` you can run a:

``` bash
php composer.phar install
```

{% img left /images/composer.installation.png %}

and see that composer downloads the required dependencies and puts them
under the `vendor` directory, writes its lock file{% fn_ref 2 %} and
generates an **autoloader**.

The autoloader is located at `vendor/.composer/autoload.php` and you can
obviously use it for your application:

``` xml PHPUnit's configuration file using a composer-generated autoloader
<?xml version="1.0" encoding="UTF-8"?>

<phpunit backupGlobals="true"
         bootstrap="vendor/.composer/autoload.php"

...
```

One of the pains in managing dependencies is upgrading the libraries you depend
on, a problem that composer solves by just running a `php composer.phar update`.

Since some **composer-generated files and the 3rd party libraries are irrelevant**
for your SCM, it is highly recommended to ignore them:

``` bash Example of .gitignore
/vendor/.composer/
vendor/
```

As pointed out by [Nils](http://www.naderman.de/) from the PhpBB community
in the comments:

{% blockquote Nils Adermann %}
You should not ignore the [composer.lock] file in git.
In fact you should commit it whenever it is changed.
Users of your project or other developers can then run "composer install" to install exactly the versions you had in your lock file, rather than installing versions based on composer.json and potentially ending up with a slightly newer dependency which could result in problems, since you didn't test with that particular version.
{% endblockquote %}

## Packagist

[Packagist](http://packagist.org/) is the main repository of composer packages:
you can browse already-registered packages or [create your own one](http://packagist.org/packages/submit).

It is fully integrated with [Github](http://github.com): when creating a new package
you will be asked the URL of the git repository for your project.

Note that on the website there is some
[further documentation about composer](http://packagist.org/about-composer).

{% footnotes %}
  {% fn While PEAR is a repository of PHP software you can reuse, PECL collects various PHP extensions, written in C %}
  {% fn The lockfile is used by composer to track already-downloaded dependencies and check, on successive updates, that it doesn't needs to re-download the dependency %}
{% endfootnotes %}
