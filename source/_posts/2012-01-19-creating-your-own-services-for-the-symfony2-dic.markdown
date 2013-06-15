---
layout: post
title: "Creating your own services for the Symfony2 DIC"
date: 2011-01-8 19:50
comments: true
categories: [Symfony2, PEAA]
alias: "/268/creating-your-own-services-for-the-symfony2-dic"
---

I want you to know how to write a service and let the container handle it for you.
<!-- more -->

This post comes from a very cool evening with [Jacopo Romei](http://agiledevelopment.it)
and [David Funaro](http://davidfunaro.com), two friends of mine, developers too.

## A container? ##

Yes, a container: Symfony2 implements a [dependency injection container](http://fabien.potencier.org/article/12/do-you-need-a-dependency-injection-container)
able to load any service you need ( a service can be the **DB connection**, a
**Twitter WS**, a **mailer** ) in the way you prefer.

Ever thought the `factories.yml` of symfony 1.4 was evil? The DIC basically does
the same thing. But, the right way.

## Why does a container is that great? ##

Because it lets you decide the *behaviour* of the framework.

Ever thought the `sfActions` were crap and wanted to build **your own C of the MVC**
with symfony 1.4 in a simple way? A pain in the mess :)

With the DIC you are able to **configure Symfony's architecture**.

## Building your own service ##

I'll show a really simple example.

To let the container manage your extension you simply need:

* a bundle
* an extension, able to load the cascading configuration of your service
* your service class(es)

If you are familiar with the Sf2 sandbox you know it comes bundled with a simple
application bundle, `HelloBundle`, which exposes the route:

```
/hello/:name
```

and renders a template saying `hello` to the name:

{% img center /images/hello.sf2.png %}

We will add the mood of our application to that page ;-)

First of all we need to tell Sf2 that we want to enable our service:

``` yml app/config/config_dev.yml
hello.service: ~ 
```

Then we have to build an extension able to load the configuration for our service.

Inside `src/Application/HelloBundle` we create a directory `DependencyInjection`
and create the `HelloExtension` class:

``` php
<?php

namespace Application\HelloBundle\DependencyInjection;

use Symfony\Component\DependencyInjection\Extension\Extension;
use Symfony\Component\DependencyInjection\Loader\XmlFileLoader;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Definition;
use Symfony\Component\DependencyInjection\Reference;
use Symfony\Component\DependencyInjection\Resource\FileResource;

class HelloExtension extends Extension
{
    public function serviceLoad($config, ContainerBuilder $container)
    {      
        $loader = new XmlFileLoader($container, __DIR__.'/../Resources/config');
        $loader->load('hello.xml');
        
        $container->setParameter('hello.service.mood', isset($config['mood']));
    }

    public function getAlias()
    {
        return 'hello';
    }

    public function getXsdValidationBasePath()
    {
        return __DIR__.'/../Resources/config/schema';
    }

    public function getNamespace()
    {
        return 'http://www.symfony-project.org/schema/dic/doctrine';
    }
}
```

If you take a closer look to the `serviceLoad` method

``` php
<?php

public function serviceLoad($config, ContainerBuilder $container)
{      
    $loader = new XmlFileLoader($container, __DIR__.'/../Resources/config');
    $loader->load('hello.xml');
 
    $container->setParameter('hello.service.mood', isset($config['mood']));
}
```

you'll notice that it accepts, as parameters, the configuration ( yes, the YML
configuration, the one we left untouched with the `~` symbol ) and the container.

Why does our extension calls the `serviceLoad` method? That comes from the YAML
configuration done before:

``` yml
hello.service: ~
```

Remember? If we wrote `hello.obama`, we should have defined a `obamaLoad` method
in our extension.

Then it creates an `XMLFileLoader` and loads the configuration of our services, 
which lies in the `Resources/config` folder, an XML file called `hello.xml`.

Then, it sets a parameter, for the service: it sets `hello.service.mood`; `true`
if we have defined it in the configuration, false otherwise ( our situation ).

Ok, things will become clear watching at the `hello.xml`, located in
`src/Application/HelloBundle/Resources/config/hello.xml`:

``` xml
<?xml version="1.0" ?>

<container xmlns="http://www.symfony-project.org/schema/dic/services"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.symfony-project.org/schema/dic/services http://www.symfony-project.org/schema/dic/services/services-1.0.xsd">

    <parameters>
        <parameter key="hello.service.class">Application\HelloBundle\Service\Hello</parameter>
    </parameters>

    <services>
        <!--- Annotation Metadata Driver Service -->
        <service id="hello_service" class="%hello.service.class%">
          <argument>%hello.service.mood%</argument>
        </service>
    </services>
</container>
```

As you see, it defines a service ( `hello_service` ), which istantiates the class
`%hello.service.class%`, a parameter defined some lines above, with the argument
`%hello.service.mood%`.

Yes, that parameter comes from the `HelloExtension`!

Remember?

``` php
<?php

$container->setParameter('hello.service.mood', isset($config['mood']));
```

So, here we are passing to the XML the parameter `%hello.service.mood%` with
`false` value.

Ok, we are close to the end, what's missing there? Oh, our service!

In the XML we stated that the class of the `hello_service` service should be
`Application\HelloBundle\Service\Hello`, so we only need to create it under
`src/Application/HelloBundle/Service/Hello.php`: 

``` php
<?php

namespace Application\HelloBundle\Service;
 
class Hello
{
  public function __construct($mood)
  {
    $this->mood = $mood;
  }
 
  public function __toString()
  {
    if ($this->mood)
    {
      return "sunshine reggae!";
    }
 
    return 'Oh no';
  }
}
```

as you see, **the mood is passed by the DIC in the constructor***, and we have
defined a `__toString` returning 2 different strings based on the value of the mood.

Ok, we're done.

Open the dummy front controller bundled with the sandbox and pass a second
argument to the template:

``` php src/Application/HelloBundle/Controller/HelloController.php
<?php

public function indexAction($name)
{
    $hello = $this->get('hello_service');
 
    return $this->render('HelloBundle:Hello:index.twig', array('name' => $name, 'mood' => $hello));
}
```

then edit the twig template:

{% include_code [src/Application/HelloBundle/Resource/views/Hello/index.twig] lang:html %}

So, let's see it in action:

{% img center /images/on-no-sf2.png %}

Now we can edit the service configuration:

``` yml
hello.service:
  mood: true 
```

and see what happens:

{% img center /images/sf2-sunshine.png %}


## "Oh shit"... A bit lost? Here's a recap! ##

Ok, let's try to explain things again!

In the configuration of you application ( `app/config/config_dev.yml` ) you add
to your application a new service ( `hello.service` ), with no parameters.

Then, when in the application you call the service `hello_service`, the DIC
looks for an extension able to load the service, which is `HelloExtension`.
It runs the method serviceLoad, which looks to an XML describing the service 
passing it the parameters you defined in the YAML configuration ( none ).

Then the DIC instantiate the service class with the parameters mapped in the XML
( `$mood = false` ).

The second time, we have defined `$mood` as `true`, so the container instantiates
the class with a really simple:

``` php
<?php

$service = new Hello(true);
```

the result is that you get an instance of your service configured as you want.