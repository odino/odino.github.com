---
layout: post
title: "Configuring a Symfony2 application to support SOA"
date: 2013-06-06 13:00
comments: true
categories: [SOA, Symfony2, PHP]
---

When you think in terms of
[Service Oriented Architecture](/refactoring-your-architecture-go-for-soa/)
one of the tricky things is to decide
how to organize your development workflow
in order to develop **architecture**,
not a single application: for example, how would
you configure deployments (when you need
to deploy **part** of your architecture, not
just a web application) or push cross-service
features to your SCM?

<!-- more -->

This article gives an overview of the constraints
and preferences that we wanted to implement
in our SOA, which is mainly done with Symfony2,
but most of it can be read in a
framework/language-agnostic key.

## Problems

We can at least identify 3 problems which pop
up after you decide to layer your architecture
and avoid [a monolithic approach](http://www.slideshare.net/odino/the-rocket-internet-experience-phptostart-2013-in-turin/103):

* given that every of your service will require
some time (1~5 minutes) to be deployed, how do you
ensure that you can release a new version of a service
without the need of updating **all** the other
services?
If you have, for example, 9 machines and 3 services
(A, B and C, 3 machines for each service),
you cant really afford to **deploy everywhere**
when you need to update just the service A, because
you might need to shutdown service B and C during the
deployment, while they dont really need to be updated.
The solution here would be to update just a bunch of
your servers

* how do you create *Pull Requests* and organize your
repositories? This is not a trivial question: if you
need a feature that involves changes in services A and B,
and you have 2 repositories you will need to add some
overhead on top of every single operation that you
would usually do with a new feature

* is your software able to automatically support SOA?
By this I mean, when you want to add a new service,
how easy is to configure your architecture to be able
to support the new layer? Of course, you would need
something that lets you do this in a matter of a minute

## Deployments

As I stated earlier, the solution is to be able
to specify, upon deployments, which services need
to be updated, and your best friend, here, could
be something like [Capistrano](https://github.com/capistrano/capistrano).

If you ever worked with capistrano, you know
that deployments basically depend on the `deploy.rb` file,
in which you can configure different **stages** of your
architecture:

``` ruby
set :stages, %w(live staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
```

In the example, weare declaring that our application
can be deployed on 2 stages, `live` and `staging`; by doing a
`cap live deploy` or `cap deploy` you are ready to either deploy to your live
servers or staging ones, after configuring the staging
files (`live.rb` and `staging.rb`):

``` ruby An example live.rb
role :web,        "company.com"
role :app,        "company.com", :primary => true
role :db,         "company.com", :primary => true

set :app_environment, "live"
set :deploy_to,   "/var/www/htdocs/#{application}.#{app_environment}"
```

This still doesn't solve the problem of
**just deploying a single service**, but to
overcome it, thanks to the capistrano `multistage`
extension, it's a matter of configuring a few deployment
files.

For example, here's how you would write your deployment
files once you have a couple services (`A` and `B`):

``` ruby deploy.rb
set :stages, %w(a-live a-staging b-live b-staging, live, staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
```

``` ruby a-live.rb
role :web,        "a.company.com"
role :app,        "a.company.com", :primary => true
role :db,         "a.company.com", :primary => true

set :app_environment, "live"
set :deploy_to,   "/var/www/htdocs/#{application}.#{app_environment}"
```

As you see, we are creating a few different stages:

* `serviceName-environment` (ie. a-live), which includes servers for a
specific environment of a service
* `environment` (ie. live), which includes the entire architecture,
useful in those cases when you really want to deploy
the entire architecture{% fn_ref 1 %}

For Symfony2, to ease your job, you can use
[capifony](http://capifony.org/) which takes
care of configure the remaining,
specific, crucial parts of the deployment for the
framework (such as clearing and warming up the cache,
installing the dependencies via composer and so on).

## Software lifecycle

{% img left /images/cylinders.png %}

Ah, good old SCM problems!

Let's say your are working on a traditional, monolithic application:
you branch to implement a new feature, commit, push, open
a pull request, the PR gets merged, deployed on staging, tested and
then goes to live; very simple as well as efficient:
**zero overhead**.

You might think that in SOAs this is not different: you `cd` into a
specific's service repository, branch to
implement a new feature, commit, push, open
a pull request, the PR gets merged in that repository, the service gets deployed
on its staging servers, tested and then goes to live;
very simple as well as efficient?

No, at all.

Thing is, often you will need to develop **cross-service
features**, which require code to be updated in N different
repositories: as a result, you will need to open N pull requests;
{% pullquote %}
if you think that this is not a problem, consider what happens
once you pack and test everything and are ready to go live:
a critical bug is found, and it couldn't have been discovered
earlier since it just happens due to some specific configuration
that you have on the live environments: time to **rollback N new services**.

Since rollbacking is a very critical operation{% fn_ref 2 %}, you
want to rollback each of the affected services separately, which makes your
downtimes N times slower than a usual, monolithic rollback: in these
cases, {" to be on the safe side, being able to rollback the
entire architecture is a must "}.
{% endpullquote %}

That's why I would advice to keep all of your services under
one repositories, to avoid overheads:

* N projects in your IDE
* N SCM operations (`git checkout -b myBranch` as well as `git push origin myBranch`)
* N pull requests
* N code reviews

Due to this, honestly, I don't really see the need of separating services
into different repositories: when you deploy, you deploy a tag of the architecture
itself (only on the servers which host the services to be updated with that tag),
when you rollback, you rollback the entire architecture to a specific
version.

{% img left /images/baby-birds.jpg %}

This seems to go against what I preached earlier, while talking
about deployments, but the truth is that you want to be on the safe side
once something goes wrong: you can optimize deployments so that you can
just deploy some services, but in case of rollback, you need to take an
immediate, "total" action to **restore all of your services**.

Consider the situation from a very similar perspective coming
from a very, very different context: cultivate an healthy colony of newborns
in nature - as opposed to maintaining an healthy architecture on the internets.

Exactly like the mom of newborn birds, when it comes to feed (update)
them, you would give the weaker ones, in order to help them develop as healthy
as their stronger brothers, the biggest meals; but when it comes
to rescue (rollback) them from a predator, you would crave for having an
option to move them all in one go, without the risk of moving them one by
one, leaving the unluckiest ones defenseless against their own fate.

## Configuring new services in Symfony2

{% img right /images/cubic-architecture.jpg %}

This post has to come to an end dealing with Symfony2,
since, in our experience,
[we have decided to go SOA with this framework](/why-we-choose-symfony2-over-any-other-php-framework/):
all in all, we found that due to the integration with capistrano
and the concept of bundles, together with the ability to have
per-bundle specific hostnames, this framework is pretty friendly
towards the ideas and constraints that we want to implement in
our SOA: what we've seen is no rocket science, and even
the approach that we are using with Symfony2 is nothing
extraordinary, but it helps maintaining a very clean and
efficient workflow while developing a SOA.

As I said, for deploying you might want to use capifony,
and when it comes to isolate services in just one repository
we realized that a good solution would be to have **one
Symfony2 application** and create **a bundle for each service**
that we need.

Thanks for the capabilities of Symfony2's routing
mechanism, you can also bind a subdomain to a specific
bundle; once you create the bundle, you can tell symfony
that the routes of that specific bundle can be matched only
if the subdomain of the application matches a particular
string:

``` bash app/config/routing.yml
mycompany_service_a:
    resource: "@AcmeServiceABundle/Resources/config/routing.yml"
    prefix:   /
    host:     service-a.mycompany.com
```

``` bash src/Acme/ServiceABundle/Resources/config/routing.yml
mycompany_service_a_index:
    pattern:  /index/{whateverParameter}
    defaults: { _controller: AcmeServiceABundle:Default:index }
```

In this case, the route `mycompany_service_a_index` will only
be matched when the URL is using the hostname
`service-a.mycompany.com`: for example, `http://mycompany.com/index/param`
won't match it; this is pretty interesting since it gives you the
flexibility to develop features in just once repository, on
**as many services as you want**.

We are still heavily experimenting, but out of a few approaches - 
for example [route prefixing](http://symfony.com/doc/2.0/book/routing.html#prefixing-imported-routes) -
we decided to go on with the ones I explained here for cleanness,
clarity, efficiency and security of your development cycles
and architecture: if your experience suggests something different
or you want to share doubts, feel free to abuse of the comments
section, since I am very open and interested to discuss this topic.

{% footnotes %}
	{% fn Cases such as disaster recovery or deployments to a brand new servers' set (for example, if you want to switch from AWS to another provider) %}
	{% fn Rollbacking, per se, shouldn't be a pain in the ass, but you need to focus on it in order to reduce mistakes in an already-critical situation %}
{% endfootnotes %}