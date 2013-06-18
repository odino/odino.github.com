---
layout: post
title: "Integrating Twig in your legacy code, Part 2: a less wild approach"
date: 2013-06-18 12:07
comments: true
categories:  [Twig, PHP, legacy]
---

In my last post I wrote about
[integrating Twig into your legacy code](/integrating-twig-in-your-legacy-php-code/)
with a really **wild**
approach.

Today I came up with a better
solution that lets you take advantage
of Twig full features without any hack
(like the `partial` tag I was
talking about in my previous post).

<!-- more -->

Instead of parsing the generated output
as a string with Twig, we can store it
into a template, which lets us use
features like `use`, `extends`, `include`,
thing that is almost impossible - in a clean way -
if we use the Twig string loader:

``` php
<?php

class Framework_Base_Controller
{
  public function render($templateName, array $parameters = array())
  {
      // ....
      // do stuff to render your template
      // we have the HTML output in the $templateOutput variable
      // ...

        $twig = new Twig_Environment(new Twig_Loader_String(), array(
          'autoescape' => false,
      ));

        return $twig->render($templateOutput, $parameters);
  }
}
```

Instead of using the `Twig_String_Loader` we would use an array
loader, and store `$templateOutput` in a unique template, called `__MAIN__`.

``` php
<?php

class Framework_Base_Controller
{
  public function render($templateName, array $parameters = array())
  {
      // ....
      // do stuff to render your template
      // we have the HTML output in the $templateOutput variable
      // ...

      $finder     = new Symfony\Component\Finder\Finder();
      $templates  = array();
                
      foreach ($finder->in('/path/to/twig/templates') as $file) {
          if (!$file->isDir()) {
              $templates[$file->getRelativePathName()] = $file->getContents();
          }
      }
        
      $loader = new Twig_Loader_Array($templates);
  	  $loader->setTemplate('__MAIN__', $templateOutput);

      $twig = new Twig_Environment($loader, array(
          'autoescape' => false,
      ));

      try {
          return $this->twig->render($templateName, Alice_Component_Registry::getAll());
      } catch (Twig_Error_Loader $e) {
          return $this->twig->render("__MAIN__", Alice_Component_Registry::getAll());
      }
  }
}
```
And that's it!

Now you can write your own `$templateName`:

``` bash /path/to/twig/templates/$templateName
{ % extends '__MAIN__' % }

{ % use 'whatever' % }

{ % block somewhat % }
	some content
{ % endblock % }
```