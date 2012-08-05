---
layout: post
title: "Source code workflow after 3 months of Github"
date: 2012-08-05 23:16
comments: true
categories: [git, github, rocket-internet, teams]
published: false
---

When I joined *Rocket Internet* 4 months ago,
here in Dubai, the team was about to experience
the transition from the very old SVN to Git, with
everything hosted on [Github](https://github.com).

In this post I try to wrap-up the impressions
of the team and the changes in the lifecycle of
our source code with the adoption of the
Git+Github combo.

<!-- more -->

{% img right /images/github.png %}

## Premise

We had our first meeting about the switch to Git
after our CTO migrated our repositories from
our hosted SVN repos to Github with
[git-svn](http://www.kernel.org/pub/software/scm/git/docs/git-svn.html).

In that meeting - useful for a lot of people who
never used Git before - we explained the basic
knowlegde that you should have to get started with
this VCS:

* distribute vs centralized versioning system
* Github act as a remote
* `commit` is local
* `push`, `pull` and `fetch`
* rebasing
* branching and merging
* [gitflow](http://nvie.com/posts/a-successful-git-branching-model/)

All in all we wanted to follow gitflow but at the
end it turned out that in some parts we simplified
the workflow and added some complexity somewhere else:
keep reading to get more insights.

In this post I will also refer to **tickets**: we use JIRA
to handle them - if you don't know it, it's a really
wondeful issue tracker, and the concept I'll mention here are
common to any issue tracking tool, like tickets' statuses.

## Our development workflow

So let's say that today we have `master` and `dev` aligned:

* `master` is an *always-ready-to-be-released* branch, in which
you commit code that is tested and works on production: the aim is
to have a solid fallback if you deploy and need to rollback ( [capistrano](https://github.com/capistrano/capistrano/wiki/) 
would probably be a better solution, since it's more immediate, but
again you need an history of working versions )
* `dev` branches from master: it's the integration branch, where
you merge features developed for your next release

As the days go by, people will branch from develop to
develop new feature/fix bugs:

``` bash
git checkout develop
git checkout -b bug-1123
```

The developer is free to handle its *ticket* with both
local and remote branches: although pushing to the remote
makes squashing harder, I would always recommend to push
every day.

Let's say that the bugfixing seems done and we are ready
to include that code in the `develop`, which is gonna lead
to our next release: the developer now opens a [pull request](https://help.github.com/articles/using-pull-requests/)
from its branch to the develop.

{% img center /images/pull-request.jpeg %}

It's always useful to name the PR like `TICKET-ID Headline`
and add a few more comments to explain your changes, if it's worth it:
given that you **name your branches after the tickets** that they
implement/fix, adding the ticket ID to the PR's title lets
who needs to merge it into develop to directly copy the branch
name from Github - otherwise you need to type it manully:
Github's markup makes it difficult to `ctrl+c` it from the
*You're asking @user to merge 1 commit into
repo:develop from repo:TICKET-ID* string.

The release manager ( who reviews PRs and merges them into
the integration branch ) can now have a look at your PR,
comment it and accept or reject it:

* if it's accepted it gets merged and the ticket status
changes from `bugfixing`{% fn_ref 1 %} to `Ready for QA`
* if rejected it's re-assigned back to the developer, and
technical comments are added **directly on Github**

preparando la release si brancha
altri commit su dev
commit correttivi sulla release branch, PR su branch
release della branch
QA
merge sul master
develop rebase

## Critical paths

PR senza rebase
pull dopo rebase del develop
code review
hotfix

## Conclusions

meno conflitti
molto piu' velocepraticamente nessun downtime
commenti sul codice sono stupendi
possibilita' di analizzare una PR per filo e per segno, diff...
fare release management e' piu' facile
tra commit hash e link a PR isolare le feature e' molto piu' facile

{% footnotes %}
  {% fn We use 'bigfixing' both for new features and bugs, it's just to identify a status in which the developer is working on the ticket %}
{% endfootnotes %}