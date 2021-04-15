---
layout: post
title: "Re-doing things with Symfony2"
date: 2011-03-13 10:46
comments: true
categories: [symfony2]
alias: "/298/re-doing-things-with-symfony2"
---

At the end I realized I should re-write this website with the latest ( not stable ) version of my favourite framework: Symfony2.

I downloaded the PR7 and started converting the old Sf1.x application to Symfony2: since I had really cool impressions, and since I made a few mistakes, I want to share a few considerations.
<!-- more -->

## What's the stack?

{% img right /images/symfony2.png %}

The Symfony2 version is the PR7, as I said, while I used, for the first time, Twig.

I mapped a single entity, [Content](https://github.com/odino/odino_org/blob/master/src/Odino/BlogBundle/Entity/Content.php), through Doctrine2.

The backend is still the one made with symfony 1.4, since I had no reason at all to spend time on a backend without the admin generator.

I heavily used the HTTP caching headers: that's basically why I decided to move this site to Symfony2; I will monitor the stats of this VPS in order to get some conclusions in a few days.

## Twig

That's amazing.

Templates become [declarative](https://github.com/odino/odino_org/blob/master/src/Odino/BlogBundle/Resources/views/Default/tags.html.twig#L10) is a second.

Something we will definitely appreciate are the filters and the tests..

The filters are a way to format a variable:

```
article.publishedDate | date
```

and they become powerful when you think that, behind the scenes, Twig is purely OO, so you can plug it with stuff like:

```
article.title | slug
```

The **testers** are another really cool thing.

As far as I undertood, they follow a is statement:

```
if article.id is odd
```

Again, really powerful when you think at:

```
{% raw %}
{% if author.country is european %}
...
{% if article.date is summer %} 
{% endraw %}
```

However, I've made a few mistakes with the templates, because I didn't find a way to avoid the duplication of [declaring the metatags](https://github.com/odino/odino_org/blob/master/src/Odino/BlogBundle/Resources/views/Default/content.html.twig#L3) in every single template.

## Controllers

I practically have a [single controller](https://github.com/odino/odino_org/blob/master/src/Odino/BlogBundle/Controller/BlogController.php), which handles the whole blog.

Since I wanted to deploy the blog as faster as I could, I decided to have **fat controllers** without using the **repository pattern**, which is the one we will use for high-value code.

[Mapping your routes with the annotations](https://github.com/odino/odino_org/blob/master/src/Odino/BlogBundle/Controller/BlogController.php#L82), well, that is awesome: since the routing gets compiled down into the cache the overhead is really small.

Be aware that if you have [multiple parameters in the route](https://github.com/odino/odino_org/blob/master/src/Odino/BlogBundle/Controller/BlogController.php#L140), you must specify the requirements, otherwise **mess will come**.

I wrote tons of LoCs in the controller, but with the annotations you should be able to let the controller only fetch stuff from the DB (without even specifying the [template rendering](http://bundles.symfony-reloaded.org/frameworkextrabundle/annotations/view.html#usage) LoCs in PHP).

## Querying the database

The fact that you can use [N placeholders](https://github.com/odino/odino_org/blob/master/src/Odino/BlogBundle/Controller/BlogController.php#L92) for the query variables is really good, and the whole API hasn't changed so much from Doctrine 1.2.

## Conclusions

I've boiled a few spaghetti on GitHub this weekend, but I'm pretty satisfied that I know where I failed and why ( were we speaking about high-value code? ;-) ).

Symfony2 seems amazing, as I said [looking at the DIC](http://www.odino.org/268/creating-your-own-services-for-the-symfony2-dic).

Other conclusions, dealing with the HTTP cache and server resources, will come in a few days...

## Ah, wait!

If you find that something is broken, tell me in the comments or wherever!