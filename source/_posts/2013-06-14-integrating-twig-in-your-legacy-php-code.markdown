---
layout: post
title: "Integrating Twig in your legacy PHP code"
date: 2013-06-15 23:15
comments: true
categories: [twig, php, legacy]
published: true
---

It might happen that you are working
on a legacy code that is years old,
with its own templating mechanism{% fn_ref 1 %}
that doesn't really allow you to take
advantage of the benefits that a structured
and object-oriented engine like
[Twig](http://twig.sensiolabs.org/).

In this situations, when a complete replacement
would cost too much to your organization,
you can take advantage of a *wild* integration between
this advanced template engine and your
existing code.

<!-- more -->

{% ribbonp info Outdated %}
	This article is outdated! A better approach was described here:
	http://integrating-twig-in-your-legacy-code-part-2-a-less-wild-approach/
{% endribbonp %}

## Approach

The main idea is that you should anyway
have a man function which outputs
what is being rendered on the view, so that
you can capture that output and parse it via
Twig, something like a `render` function
in your controllers:

``` php Example controller
<?php

class My_Controller extends Framework_Base_Controller
{
	public function indexAction()
	{
		// ....
		// do stuff
		// ...

		return $this->render('my_template', $parametersForTheView);
	}
}
```

``` php Example of a base controller
<?php

class Framework_Base_Controller
{
	public function render($templateName, array $parameters = array())
	{
		// ....
		// do stuff to render your template
		// ...

		return $templateOutput;

		// will become
		return $this->twig->render($templateOutput);
	}
}
```

At this point the only thing that
you need is to inject the Twig engine
into your base controller and parse the
output of your legacy templates with Twig{% fn_ref 2 %}:

``` php 
<?php

// your actual rendering:
return $this->twig->render($templateOutput);

// which means:
return $this->twig->render('<html><head><title>Hello world</title>...</html>');

// so that you can actually write twig in your templates:
return $this->twig->render('<html><head><title>{ % block title % }Hello world{ % endblock % }</title>...</html>');
```

{% ribbonp warning attention %}
The 'block' tag in the example above is having a space between curly brackets and the percentage char since my blog engine (octopress) doesn't allow those tags them in code blocks.
In all of the next examples you will see Twig tags written like that.
{% endribbonp %}

## Rendering content via Twig

To integrate Twig in your application
it it really a matter of a few minutes:
first, you will have to download and move
the library inside your codebase, then,
thanks to the PSR-0 autoloading (here we
will be using Symfony2's autoloader, but
you can use any PSR-0 compliant autoloader) you just
need to include it and setup Twig's own
autoloader:

``` php
<?php

require_once __DIR__.'/vendor/symfony/Symfony/Component/ClassLoader/UniversalClassLoader.php';

use Symfony\Component\ClassLoader\UniversalClassLoader;

$loader = new UniversalClassLoader();
$loader->register();

$loader->registerNamespaces(array(
    'Twig' => __DIR__ . '/vendor/twig/lib/',
));

require_once __DIR__ . '/vendor/twig/lib/Twig/Autoloader.php';
Twig_Autoloader::register();
```

At this point, let's get back to our `render`
function, which we will need to modify in order
to include Twig:

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

At this point we would be already able to write
Twig code inside our templates:

``` php my_index.html
{ % set posts = registry.get('blog_post').findByUser($user.id) % }
<p>
	{ % for post in posts % }
		...
	{ % else % }
		This user didn't write any post
	{ % endfor % }
</p>
```

## A new tag

Unfortunately, to support some kind of
inheritance, which is one of the greatest
features of Twig, the situation becomes a little
bit trickier: first of all, we will need to add
to the parsed HTML some extra content to override
blocks, then we will need to create a new Twig
token parser in order to allow declaring multiple
blocks with the same name, which is not allowed by the
`block` tag.

Let's say that all of your templates are including
a base layout made of a very clean HTML structure:

``` php Base layout of your framework
<html>
	<head>
		<title><?php echo $title; ?></title>
		...
		...
	</head>
	<body>
		<?php echo $content; ?>
	</body>
</html>
```

At this point, since we are able to parse generated
HTMLs with Twig, you can simply add a couple blocks:

``` php 
<html>
	<head>
		<title>
			{ % block title % }<?php echo $title; ?>{ % endblock % }
		</title>
		...
		...
	</head>
	<body>
		{ % block content % }
			<?php echo $content; ?>
		{ % endblock% }
	</body>
</html>
```

After we do it, how can we override these blocks
differently from each controllers' actions?
You simply include other Twig content at the end of the
generated HTML:

``` php Adding support for basic inheritance
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
		$twigTemplate = sprintf("path/to/twig/templates/%s.twig", $templateName;

		if (file_exists($twigTemplate))) {
			$templateOutput .= file_get_contents($twigTemplate);
		}

        return $twig->render($templateOutput, $parameters);
	}
}
```
And then override the content with your own twig template:

``` bash path/to/twig/templates/templateName.twig
{ % block title % }
	About: this is our about page
{ % endblock % }
```

After you setup everything, you will realize that
there is a huge problem here: since Twig doesn't allow
to declare blocks Twig, you can use the `block` tag!

To overcome the problem, you can simply add a new tag,
`partial`:

``` php The new tag is implemented via a token parser
<?php

/**
 * Token parser for the twig engine that adds support to redefinable blocks,
 * under the 'partial' alias.
 * 
 * IE:
 * { % partial myPartial % }First{ % endpartial %}
 * { % partial myPartial % }Second{ % endpartial %}
 * 
 * will render "Second".
 * 
 * This is needed since the { % block % } tag doesnt support redefining blocks
 * with the string loader, it just supports it via inheritance.
 */
class PartialTokenParser extends Twig_TokenParser_Block
{
    /**
     * Parses the twig token in order to replace the 'partial' block.
     * 
     * @param Twig_Token $token
     * @return Twig_Node_BlockReference
     * @throws Twig_Error_Syntax
     */
    public function parse(Twig_Token $token)
    {
        $lineno = $token->getLine();
        $stream = $this->parser->getStream();
        $name = $stream->expect(Twig_Token::NAME_TYPE)->getValue();
        $this->parser->setBlock($name, $block = new Twig_Node_Block($name, new Twig_Node(array()), $lineno));
        $this->parser->pushLocalScope();
        $this->parser->pushBlockStack($name);

        if ($stream->test(Twig_Token::BLOCK_END_TYPE)) {
            $stream->next();

            $body = $this->parser->subparse(array($this, 'decideBlockEnd'), true);
            if ($stream->test(Twig_Token::NAME_TYPE)) {
                $value = $stream->next()->getValue();

                if ($value != $name) {
                    throw new Twig_Error_Syntax(sprintf("Expected endblock for block '$name' (but %s given)", $value), $stream->getCurrent()->getLine(), $stream->getFilename());
                }
            }
        } else {
            $body = new Twig_Node(array(
                new Twig_Node_Print($this->parser->getExpressionParser()->parseExpression(), $lineno),
            ));
        }
        $stream->expect(Twig_Token::BLOCK_END_TYPE);

        $block->setNode('body', $body);
        $this->parser->popBlockStack();
        $this->parser->popLocalScope();

        return new Twig_Node_BlockReference($name, $lineno, $this->getTag());
    }

    /**
     * Returns the tag this parses will look for.
     * 
     * @return string
     */
    public function getTag()
    {
        return 'partial';
    }
    
    /**
     * Decides when to stop parsing for an open 'partial' tag.
     * 
     * @param Twig_Token $token
     * @return bool
     */
    public function decideBlockEnd(Twig_Token $token)
    {
        return $token->test('endpartial');
    }
}
```

Then you just need to tell the Twig environment to
add this token parser:

``` php While bootstrapping Twig:
<?php

$twig = new Twig_Environment(new Twig_Loader_String(), array(
	'autoescape' => false,
));
$twig->addTokenParser(new PartialTokenParser());
```

and at this point you can use it in your templates:

``` php 
<html>
	<head>
		<title>
			{ % partial title % }<?php echo $title; ?>{ % endpartial % }
		</title>
		...
		...
	</head>
	<body>
		{ % partial content % }
			<?php echo $content; ?>
		{ % endpartial% }
	</body>
</html>
```

``` bash path/to/twig/templates/templateName.twig
{ % partial title % }
	About: this is our about page
{ % endpartial % }
```

## So?

If you spot any typo / 
mistake please do let me know: I wrote the
example code adapting the one I had from a previous
project so it might be that something slipped my
mind.

Since I never dug **that deep** into
Twig it might be that some things
could be done in a cleaner way, so if
you have suggestions or feedbacks I would
strongly encourage you to go
*berserk mode* in the comments section below.

{% footnotes %}
	{% fn Being PHP or something like Smarty or xTemplate %}
	{% fn Unfortunately, to do so we will have to turn off Twig's default escaping strategy %}
{% endfootnotes %}