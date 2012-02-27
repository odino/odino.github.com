---
layout: post
title: "REST better: common pitfalls"
date: 2011-03-19 22:54
comments: true
categories: 
alias: "/304/rest-better-common-pitfalls"
---

REST is a critical buzzword since 10 years, and I really don't know why: seems like this 4 letters altogether, R E S T, have a magical power on IT people's brain{% fn_ref 1 %}...
<!-- more -->

{% img right /images/witch.jpg %}

In the last months I talked with a few people referring to **that word** with no clue about what it actually means, that's why I would like to sum up some common misunderstanding about **that word**.

**No one was born learned** ( that's an italian expression, hope you got it ), so I'd like to share the following thoughts to shutter some myths.

## Clean URIs, strict schemas

It's fun how [David Zuelke introduces this concept in 3 slides](http://www.slideshare.net/Wombert/designing-http-interfaces-and-restful-web-services-confoo11-20110310/60).

Why is this ironic?

We are used to think that REST says we should use a unique uri for each resource, and that URIs should be hierarchical.

Don't get me wrong: a URI must not point to different resources, that would mean the introduction of state into the communication, and the greatest problem with this approach is that your resources aren't linkable and, for example, you won't be able to bookmark them ( since I'm lazy I don't want to talk about **scalability** for now...  ).

It's like having a POST-based search engine for the end user ( or one of those [cheap TK sites](http://www.pxel.tk/) )... like using HTTP without its constraint and features ( llike statelessness and hypermedia, in this case ).

While 1-N relations are totally wrong ( and, therefore, N-N ), N-1 relations are **perfectly OK**.

You are probably used to listen people saying that your resource must by identified by a single URI ( and worse people tend to say its identifier must be a numerical resource ID ), but, although this is a good approach, we can get over it ( through hypermedia ).

{% img left /images/URIschema.jpg %}

The biggest problem with URI schemas and common URI/verb mapping is that they've become a set of conventions to guide the consumer through the services, completely **ignoring the hypermedia constraint of REST**.

It's because of this that Zuelke says this part is hironic: through hypermedia we don't have to give to the client tons of documentation, and we don't have to be afraid of changing the location of our resources. **An hypermedia-aware client is able to adapt to our service** as long we change some aspects of the implementation ( like locations ).

## Wait, URIs matter somehow

Ehi, I'm not advocating that the URI/verb map you see on the right is wrong: we just don't need it.

But if you are conscious about hypermedia and want to follow this kind of schemas, you have plain support in doing so: they help you design widely-recognized clean URIs.

## POX over HTTP

{% blockquote %}
You know, I have this REST webservice...
Since today there's a boom of mobile apps it's cool to have them act as a proxy between the phone and the real content on the web via some REST APIs.
So I wanted to know if there were some PHP frameworks out there that could help me writing this APIs... Do you know something?
This was a question I received during a geek dinner from a young programmer, that, basically, wanted to use stuff like Frapi and Recess.
{% endblockquote %}

The problem was that when, after this short description, I asked what he wanted to do for this "REST" API, the response was:

{% blockquote %}
Well, you know, an HTTP request, then an XML back...
{% endblockquote %}

that was what I imagined: this guy thought that REST means an HTTP requests serving an XML back into the response.

I talked to him about other awesomeness of REST but I bet he didn't care too much..

Well, getting back to us, the problem with POX ( *Plain Old Xml* ) over HTTP is that you are missing some fundamentals about RESTful architectures, and, therefore, the benefits they give you:

* having only XML ( although acceptable ) brings away **content negotiation**, which is basically a commodity for your clients
* [POX](http://www.google.it/imgres?imgurl=http://www.sqlservercentral.com/articles/SS2K5%2B-%2BXML/2826/xml_result1.gif&imgrefurl=http://www.sqlservercentral.com/articles/SS2K5%2B-%2BXML/2826/&usg=__VTGK7M7iMz05Faa-gqox9ziWiio=&h=566&w=576&sz=19&hl=it&start=0&sig2=8scznEq2t7fI6w5GyVaCnw&zoom=1&tbnid=--Cfpfrp2ulFRM:&tbnh=164&tbnw=167&ei=TQGFTcKTIYzEsgb8v_yaAw&prev=/images%3Fq%3Dxml%26um%3D1%26hl%3Dit%26safe%3Doff%26sa%3DN%26biw%3D1280%26bih%3D690%26tbs%3Disch:1&um=1&itbs=1&iact=hc&vpx=141&vpy=363&dur=1808&hovh=223&hovw=226&tx=189&ty=149&oei=TQGFTcKTIYzEsgb8v_yaAw&page=1&ndsp=16&ved=1t:429,r:11,s:0) drops support for hypermedia, reducing your service's durability, mantainability and non-breaking retrocompatibility capabilities

Roughly speaking, if you think at REST like POX over HTTP you are also probably missing some other monumental benefits of REST, like the ones brought by the [cache](http://www.odino.org/301/rest-better-http-cache).

## Verbs are enough

{% blockquote %}
No, it's REST: it uses aso PUT and DELETE!
{% endblockquote %}

Another pitfall you may have encountered in your career is when you think that verbs ( *HTTP method* in 99% of the cases ) are enough to define REST a service.

Without adhering to the principles of cacheability, statelessness, stratification and to the [uniform interface](http://www.w3.org/2003/Talks/techplen-http/slide6-0.html), your service will never be considered RESTful.

Ah, and it should also happen between a client and a server, but this just sounded obvious.

## The SOAPy  way

Let me introduce you *The SOAPy way*, which is basically SOAP with REST clothes :)

The most common SOAPy pitfall occurs when you think that, in case of any error, **your application should always return a 500, specifying the error in the body of the response**.

That is a terrible mistake, moreover when you think that GETting a resource that doesn't exist anymore is an error, for you.

**404 turns into 500**.

You are basically rewriting a layer HTTP has already implemented: waste.

An HTTP-loving client would not understand your DAP ( *Domain Application Protocol* ), because you have just re-invented protocol semantics under the DAP itself!

The [symfony 1.X](http://www.symfony-framework.org/) framework does a similar thing when, with its admin generator, generates the actions able to create and redirect the browser to the just created resource: it basically uses an [explicit redirect](https://github.com/symfony/symfony1/blob/master/lib/plugins/sfDoctrinePlugin/data/generator/sfDoctrineModule/admin/parts/processFormAction.php#L36) ( `302` ), without telling the client that the object has been created ( `201` ), giving informations about its current place ( `Location` header ).

What's wrong with this? When you create an element you will always have to wait for the redirect in order to know if the resource has been created.

Gosh...

## There is one more thing

{% blockquote Jurgen Appelo, http://twitter.com/#!/jacoporomei/status/46316430379065344 %}
How much you learned today is indicated by level of embarrassment at what you did yesterday.
Trust me: that level of embarassment, is the one I feel at least once a week ;-)
{% endblockquote %}

{% footnotes %}
  {% fn Cloud computing is another one %}
{% endfootnotes %}
