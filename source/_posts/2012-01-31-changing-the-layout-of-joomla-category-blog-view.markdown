---
layout: post
title: "Changing the layout of Joomla! 'category blog' view"
date: 2011-09-11 23:43
comments: true
categories: [PHP]
alias: "/46/changing-the-layout-of-joomla-category-blog-view" 
---

Here's a simple tutorial to override the layout of the 'category blog' view in order to eliminate the readmore and link article titles instead of the readmore.
<!-- more -->

First of all we need to create the override folder `/templates/current_template/html/com_content/category/`.

Paste and copy the `blog_item.php` file located in `/components/com_content/views/category/tmpl` into the override folder we previously created.

At this point we only need to edit a few lines of code into the file located in the override folder:

* at line 13 delete `$this->item->params->get('link_titles') &&`
* delete everything from line 129 to line 142

That's it!

You can try managing Joomla!'s native view options to do that but I think it's so much easier to do that with the override, considering also that you can handle lots of powerful customization that with the default options included with Joomla! you can't.
