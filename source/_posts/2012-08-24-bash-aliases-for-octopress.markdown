---
layout: post
title: "Shell aliases for Octopress"
date: 2012-08-24 11:02
comments: true
categories: [octopress, shell]
published: false
---

A few days ago I moved to [ZSH](http://en.wikipedia.org/wiki/Z_shell) 
from bash, since my friend David was pushing me to try it:
after a few days I really have to say
that there is no reason not to switch
- mainly for the git integration and
double-tab behaviour - and I also
created a few *aliases* that work like
a charm in Octopress.

<!-- more -->

The majority of them would also work in
bash, but I remember I had to make
[some changes](https://github.com/imathis/octopress/issues/117)
to make Octopress work with ZSH, so
you may want to have a look at that discussion first.

Bare in mind that all of this aliases need to be put in
the `~/.zshrc` file.

## octopreview

``` bash
alias octopreview='rake preview'
```

Starts Octopress' preview mode:

``` bash
~/Sites/odino.github.com (source ✘)✹✭ ᐅ octopreview

Starting to watch source with Jekyll and Compass. Starting Rack on port 4000
```

## octopost

``` bash
octopost () {
  rake new_post && octopreview;
}
```

This task let's you create a new post and
automatically launches Octopress' preview mode:

``` shell
~/Sites/odino.github.com (source ✘)✹ ᐅ octopost

Enter a title for your post: bash aliases for octopress
mkdir -p source/_posts
Creating new post: source/_posts/2012-08-24-bash-aliases-for-octopress.markdown
Starting to watch source with Jekyll and Compass. Starting Rack on port 4000
```

## octostat

``` bash
octostat () {
  rake list_posts;
}
```

Based on this [rake task](http://tonytonyjan.github.com/2012/05/02/list-all-posts-rake-task-for-octopress/)
that I [slightly modified for ZSH](https://github.com/odino/odino.github.com/blob/source/Rakefile#L388),
this lets you find out which posts are published/unpublished
in your blog:

``` bash
~/Sites/odino.github.com (source ✘)✹✭ ᐅ octostat

(pub|unpub): unpub
2012-08-24-bash-aliases-for-octopress.markdown
```

## octosave

``` bash
octosave () {
        git add . && git commit -m "$@" && git push origin source;
}
```

Saves all your local changes committing
and pushing everything on the remote `source`
branch:



## octodeploy