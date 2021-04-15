---
layout: post
title: "Optimizing loading times with images' lazy loading"
date: 2012-09-21 07:45
comments: true
categories: [performances, javascript]
---

Sometimes I like to forget that I'm
mainly involved in other things and
get my hands dirty with low-level
stuff: last week I wanted to improve
some existing lazy loading code we use
with JavaScript.

<!-- more -->

Let's suppose that we have a page
showing almost 100 images, 500kb
per image, 5MB of a webpage.

It's clearly unpractical to load
all the images at once, since you
would force the use to download
stuff that he would only see scrolling
down with the mouse, so the solution
would be to store all the images' path
in an HTML attribute and trigger the load
just for visible images in the current window.

You'd have an HTML like this:

``` html
<html>
  <head>
  	...
  </head>
  <body>
  	...

  	...

  	<div class="imgContainer" >
  		<img class="lazy-loading" id="http://example.com/img1.jpg" />
  	</div>
  	<div class="imgContainer" >
  		<img class="lazy-loading" id="http://example.com/img2.jpg" />
  	</div>
  	<div class="imgContainer" >
  		<img class="lazy-loading" id="http://example.com/img3.jpg" />
  	</div>
  	<div class="imgContainer" >
  		<img class="lazy-loading" id="http://example.com/img4.jpg" />
  	</div>
  	<div class="imgContainer" >
  		<img class="lazy-loading" id="http://example.com/img5.jpg" />
  	</div>
  	<div class="imgContainer" >
  		<img class="lazy-loading" id="http://example.com/img6.jpg" />
  	</div>
  	...
  	...
  	...
  </body>
</html>
```

and the lazy laoding function looks like:

``` javascript
var lazyLoading = function(){
	$('img.lazy-loading').each(function(){            
	    var distanceToTop = $(this).offset().top;
	    var scroll        = $(window).scrollTop();
	    var windowHeight  = $(window).height();
	    var isVisible     = distanceToTop - scroll < windowHeight;
	    
	    if (isVisible) {
	        $(this).attr('src', $(this).attr('id'));
	    }
	});
}
```

As you see, we only trigger lazy loading for **visible**
items, which are appearing in the current window:
given the `windowHeight`, we calculate visibility
based on the difference between the item and
the mouse scroll, so that we can see whether the
product is comprehended in the current window
or not.

To trigger lazy loading you need to listen for
mouse scroll events **and** `domready` ( if some 
images would be visible without scrolling ):

``` javascript
$(document).ready(function() {
	lazyLoading();

	$(window).scroll(function() {
	    lazyLoading();
	});
});
```

We, at [Namshi](http://www.namshi.com/), use the same approach for
[catalog listing pages](http://www.namshi.com/women-shoes/).