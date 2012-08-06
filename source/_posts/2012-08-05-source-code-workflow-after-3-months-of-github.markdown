---
layout: post
title: "Source code workflow after 3 months of Github"
date: 2012-08-05 23:16
comments: true
categories: [git, github, rocket-internet, teams]
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
stuff that you should know to get started with
this VCS:

* distribute vs centralized versioning system
* Github act as a remote
* `commit` is local
* `push`, `pull` and `fetch`
* rebasing
* branching and merging
* [gitflow](http://nvie.com/posts/a-successful-git-branching-model/)

All in all we wanted to follow gitflow but at the
end it turned out that in some parts we had to simplify
the workflow and add more complexity somewhere else:
keep reading to get more insights.

## Our development workflow

So let's say that today we have `master` and `dev` aligned:

* `master` is an *always-ready-to-be-released* branch, in which
you commit code that is tested and works on production: the aim is
to have a solid fallback if you deploy and need to rollback ( [capistrano](https://github.com/capistrano/capistrano/wiki/) 
would probably be a better solution, since it's more immediate, but
again you need an history of working versions )
* `dev` branches from `master`: it's the integration branch, where
you merge features developed for your next release

As the days go by, people will branch from develop to
implement new features/fix bugs:

``` bash
git checkout develop
git checkout -b bug-1123
```

The developer is free to handle its *ticket* with both
local and remote branches: although pushing to the remote
makes [squashing](http://ariejan.net/2011/07/05/git-squash-your-latests-commits-into-one/) harder, I would always recommend to push
every day.

Let's say that the bugfixing seems done and we are ready
to include that code in the `develop`, which is gonna lead
to our next release: the developer now opens a [pull request](https://help.github.com/articles/using-pull-requests/)
from its branch to `develop`:

{% img center /images/pull-request.jpeg %}

It's always useful to name the PR like `TICKET-ID Headline`
and add a few more comments to explain your changes, if it's worth it:
given that you **name your branches after the tickets** that they
implement/fix, adding the ticket ID to the PR's title lets
who needs to merge it into develop to directly copy the branch
name from Github - otherwise you need to type it manully{% fn_ref 2 %}.

The release manager ( who reviews PRs and merges them into
the integration branch ) can now have a look at your PR,
comment it and accept or reject it:

* if it's accepted it gets merged and the ticket status
changes from `bugfixing`{% fn_ref 1 %} to `Ready for QA`
* if rejected it's re-assigned back to the developer, and
technical comments are added **directly on Github**

``` bash After the release manager has positively evaluated your PR, ctrl+c on the branch name...
git fetch
git checkout TICKET-ID
git checkout develop
git merge --no-ff TICKET-ID
```

{% img left /images/pull-request-namshi.png %}

Now times has come to go live with a set of changes:
a **release branch** is created and we tag version
`X.Y.Z-beta1`, that is gonna be deployed in the first
development environment ( sort of pre-staging ).

If some tests are not passing, the developers add the
related fixes and open the PRs in the release branch
( `release-X.Y.Z` ), so we re-tag and redeploy ( `X.Y.Z-beta2` ):
if someone is working on other tickets, which don't have to
be included in version `X.Y.Z`, the integration branch
is still `develop`.

After this, a new tag `X.Y.Z-rc1` is deployed into the
staging environment: if everything is good we create a
new tag, `X.Y.Z` and go live with it.

After a few hours, we can consider this tag **valid**
and update both `master` and `develop`:

``` bash
git checkout master
git merge --no-ff X.Y.Z
git push origin master
git checkout develop
git rebase master
git push -f origin develop
```

The development cycle starts again.

## Critical paths

There are some problematic aspects to consider when
you are working with almost 10 people daily pushing/pulling
from the same remote:

* when you rebase `develop`, pull request can include old commits
that are already merged, so you just need to ask for a rebase of the
PR's branch
* when you rebase `develop`, always ask people to pull the remote
develop in their local ones, otherwise they will be working with a
different tree ( after the rebase Git is not smart enough to
connect the pre-rebase and after-rebase trees )
* if you need to do an hotfix deployment, always branch from
`master` or the release branch ( if the related tag wasn't merged into
`master` ): you don't want to `cherry-pick` commits and then
manually update the PR which takes care of the hotfix

## Conclusions

All in all I think our process has improved so much: first of all
we see less conflicts, thanks to the Git engine{% fn_ref 3 %}, second we have more **control,
transparency and visibility** towards code: being able to comment
every single line of code on Github really helps you when you need
to handle several PRs at once; not to mention the fact that doing
**release-management is way easier**.

By the way, pull request are another good stage of the workflow, since
they let the developer take a final look at the code, review it for
the last time and explain it in the PR message, something that with
SVN and SVN-based services ( like GH ) was **nearly impossible**.

Additionally, coming from Atlassian's hosted services, Github gives
you the reliability I always missed: no apparent downtime so far
and pulling/pushing is really fast; compared to SVN,
this is a huge win for us.

At the end I'd say that **we almost doubled our potential** with
these changes, and I think it's 50% because of Git and another 50%
'cause of Github: if you don't use them, I definitely recommend
you to switch as soon as possible{% fn_ref 4 %}.

{% footnotes %}
  {% fn We use 'bigfixing' both for new features and bugs, it's just to identify a status in which the developer is working on the ticket %}
  {% fn Github's markup makes it difficult to `ctrl+c` it from the "You're asking @user to merge 1 commit into repo:develop from repo:TICKET-ID" string %}
  {% fn But this can just be just my personal feeling %}
  {% fn BitBucket is a pretty cheap alternative to Github %}
{% endfootnotes %}