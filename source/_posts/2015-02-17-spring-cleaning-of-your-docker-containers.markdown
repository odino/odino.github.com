---
layout: post
title: "Spring cleaning of your docker containers"
date: 2015-02-17 01:43
comments: true
categories: [docker, bash voodoo]
published: true
description: Low on disk space thanks to docker? Let's cleanup those containers!
---

[Docker](https://www.docker.com/) is an amazing tool, but sometimes you
might find out that it isn't super-careful towards your HD space.

<!-- more -->

If you used Docker extensively you might
have noticed that sometimes this tool consumes
a lot of disk space, usually because you either
have too many dead containers with [persistent storages](https://docs.docker.com/userguide/dockervolumes/)
attached or similar gotchas.

I usually use three life-savers when I am running
out of space on my machine.

## Remove dead containers

```
~  ᐅ docker rm $(docker ps -a -q)
686861e0ed5f
1e1fb6a3a484
8e1c38aadf64
17570bc2f79f
Error response from daemon: Conflict, You cannot remove a running container. Stop the container before attempting removal or use -f
87705c9ace3f
867b6bca775c
f2f2aaa872f4
a3a094e8580c
FATA[0000] Error: failed to remove one or more containers
```

This will try to remove all containers, even the
running ones (don't worry, as you see from the snippet
above Docker will prevent running containers to be killed)
so that you can get rid of some dead stuff.

## Remove untagged images

Sometimes you will notice that there are some
docker images that are just the result of intermediate
containers running. These images will show up as `<none>`
and are the so-called "untagged images":

```
~  ᐅ docker images | grep none                                              
<none>                                                             <none>              40008f2b8e22        6 hours ago         412.6 MB
<none>                                                             <none>              08b8be934a53        6 hours ago         412.6 MB
<none>                                                             <none>              ed1b3d292f74        6 hours ago         412.6 MB
<none>                                                             <none>              bc472bb30fb6        7 hours ago         412.6 MB
<none>                                                             <none>              b3cd05e59b91        7 hours ago         412.6 MB
<none>                                                             <none>              69e508db0285        7 hours ago         412.6 MB
<none>                                                             <none>              0ca87c90be73        7 hours ago         412.6 MB
<none>                                                             <none>              2ee3e785cd28        7 hours ago         412.6 MB
<none>                                                             <none>              76696adc7a00        7 hours ago         412.6 MB
<none>                                                             <none>              6bf0028f0b01        7 hours ago         412.6 MB
<none>                                                             <none>              8a6da7bae442        7 hours ago         412.6 MB
...
```

Jeez! Luckily, removing those layers it's a matters
of knocking on awk's door:

```
~  ᐅ docker images | grep "<none>" | awk '{ print "docker rmi " $3 }' | bash                                                                               
Deleted: 529cae0c61835a5b7dd7ef681090dd9bce402a474ccd11715909990e3a95a968
Deleted: b854c13ebaac0f77359c4e9caa7523887a058f7a8782c3f1579daa1b960b3e92
Deleted: 7b39f624194fdf148dfe82cd88ad8176b0cdd9ab9d1d31c0a38ad32941e72ec4
Deleted: cf330b468b67499a46c859a44792ee1c089a4175568bff67f1455e2905d9b4e1
Deleted: 0a4b0dd1ec8217d51726ccfbb0410ff8074bd9654986f55d6c06f91ef6292c13
Deleted: 3e60ee2a9d34fdffdb121494925d1ffc3a32943310f991a2b6b5051e4fae187e
Deleted: d4e795c50ac25e88f71d1a5e6f6f7ebb197c7d4e9f4e3a316e4203cd04e68c4e
Deleted: 713c6007a60f91446ac7d811ab53463dbcea7fdd09e13f7f098027437c990dd1
Deleted: 929a45c5f4ae29a9489db677b7300e9044e34541a5d6777205c79eabfaed72c5
Deleted: e7b5083ceee33f29604505bc7157f624af351038ef44cc1145368863beaf4276
Deleted: 313cb946313d66f7bae33194429318b34b9aa422a88f08f0d63348c59e225376
Deleted: cf4a1e65f20930ffcd887a2a61fefe9b93b8fedc1d25bb0109aaae3319c68aec
Deleted: 2285b7f71bbbe9e7691d9ca08ae6d042c49d3424bfb29ecc923a5f9260ff7f9f
Deleted: 5d1b9d2ba21bb5de52baf97ed5fa7fe32f54c3f522f6c8f5631276a2b48951dc
Deleted: 41835ac9d16d2a064bdb470c217ef6533a032e9ae5cca723c7be98030cafd50d
Deleted: 8b17eb14ebdb2b431cb1a3e3a32c35be5b209473dc00487642f50164f496d26c
Deleted: a1178b9de7f1991c140ec789a69051668257d559a87c7a4384f2a042ddf564f1
Deleted: 7146a16101740c09a509717165039117407cb60aafb578a449cd7380b790a74b
Deleted: 36e834234f00dd3f6de02b3ffdde5618bade6e7399ea3bf0a55ef063c8c1c125
Deleted: 5a0c1ca6d8a0468751b767b3d187c4bb87f47bb581b607d637fa4ed9a1a091cf
...
```

## Removing containers and volumes the hard way

If you are still low on free disk-space and realize that
Docker is still taking a big chunk of your HD there is a
very [simple python script](https://github.com/dummymael/dotfiles/blob/1859a36afba2252f86a0a1ff8d5fb442e74b7a0e/tools/docker_clean_vfs.py) I found around
that does a great job at removing dangling volumes.

Just download it, run `pip install docker-py` (a dependency
needed by the script) and launch it:

```
~  ᐅ python ~/Downloads/docker-clean.py       
INFO:root:Purging 26 dangling Docker volumes out of 26 total volumes found.
INFO:root:Purging directory: /var/lib/docker/vfs/dir/bc4ef2279968990683780eae0c36109a004683dcdc177b83a8082e5d8bfa16b5
INFO:root:Purging directory: /var/lib/docker/vfs/dir/46febc2cb7062618bb75ea36f23c1e82412300e735ab83bdefb3970809b801b6
INFO:root:Purging directory: /var/lib/docker/vfs/dir/104c873d78215c7029e0b08a1b303d9ea83ffd312e0d4f45794095c1678180b7
INFO:root:Purging directory: /var/lib/docker/vfs/dir/362c9d9c3a4d5121b58bb8270260caa98b8b7cfccb5e44e1ed2e51afc69f5a14
INFO:root:Purging directory: /var/lib/docker/vfs/dir/51a3537373684e253a9724c080afb31bcb2548a669bd2559a69beda605de7fb5
INFO:root:Purging directory: /var/lib/docker/vfs/dir/96e39a779484df8954231464bff79c417a030072fd43e102f821a46ed37a470b
INFO:root:Purging directory: /var/lib/docker/vfs/dir/dcd999b2279bfb681ed2359d29c1e0c06e6068150451df010138a635f9c114bc
INFO:root:Purging directory: /var/lib/docker/vfs/dir/06de438150717d12e8ab8bd91438babf2bcab3eac4213f6dfc75cc517e9656db
INFO:root:Purging directory: /var/lib/docker/vfs/dir/94800c94f4a3262780af89079192f3c7485cf63a7816817d226233a0b09d9b57
INFO:root:Purging directory: /var/lib/docker/vfs/dir/97e9f73c8d0f727ad34af20cb94a62c262956eaccc2f8c30a46660e51ca38179
INFO:root:Purging directory: /var/lib/docker/vfs/dir/8c5a76f831e67e5b01a36b1998d167967f0fc235b7771e25045f68d017589da1
INFO:root:Purging directory: /var/lib/docker/vfs/dir/2a5bb76ef6b0fec010a59412c0e71e9b4ac3976cb3b37125f17137d6e8d609eb
INFO:root:Purging directory: /var/lib/docker/vfs/dir/61185e81b4a16c70c8c826653e4588d10b4a610cb15d7905b491db8b37e7a82e
INFO:root:Purging directory: /var/lib/docker/vfs/dir/ec849b6ff72ad3dd14b126d0634cfc1b7ee0336197a02dd6f366ecc5699af8ef
INFO:root:Purging directory: /var/lib/docker/vfs/dir/e9f33eae896caecbdde0509cdd5d6039300381eb6174f18721f4f6234c5ab4ae
INFO:root:Purging directory: /var/lib/docker/vfs/dir/2997cef8ccd0a28705ecba5ec97f5b2bba5e6e0187a53a27b74a3dc9f790af22
INFO:root:Purging directory: /var/lib/docker/vfs/dir/9a134e05e0b48ede50cfa272fa05c5bd5fe5bd4b46fe95391c8025f5fa85ccf8
INFO:root:Purging directory: /var/lib/docker/vfs/dir/d6022665bd4158ee4f435b96e86ef226167f6def9ba70a33b76da5e005597e68
INFO:root:Purging directory: /var/lib/docker/vfs/dir/4b8bd4cd09b8651845dd1c7323846a49f5a5d745acf2c307242426f94a649ce3
INFO:root:Purging directory: /var/lib/docker/vfs/dir/a2241af35eb6f7a33cd6996b37d5c8227e06b7f5e951000271fdddb9a9fd4a2a
INFO:root:Purging directory: /var/lib/docker/vfs/dir/d2f2f7daad463ff06694b741d55aeb585026f5b521e859b092e8d7f3907fe83a
INFO:root:Purging directory: /var/lib/docker/vfs/dir/1191ada7b82a69dd8126b22280b56c31147242087a2ca5170aa0862017e626f5
INFO:root:Purging directory: /var/lib/docker/vfs/dir/16ff5f9fd98d3c8430556b7f244eebcbe21d4b498ed5bbfc8017f6249dbc079d
INFO:root:Purging directory: /var/lib/docker/vfs/dir/a641376773db93a058302853db5217ac0ea25fc95d32ba3e62aa00231b779a43
INFO:root:Purging directory: /var/lib/docker/vfs/dir/535a31d1a72aa2743837ed334db7a9f3669ea6b0b2409bf98cbf3807b08bdaaf
INFO:root:Purging directory: /var/lib/docker/vfs/dir/e22eb7c75eeedf111a425ae4c99e2d1f32c1b525688ed570a15b2c993c4a32b3
INFO:root:All done.
```

This is it, folks!

I wish there would be **one** way of doing this
instead of having to tackle the issue from different perspectives
(remove containers, remove untagged images, remove dangling volumes),
but I believe there's gotta be something better out there, so feel
free to reach out to suggest the best way of getting this done.

At the same time, the Docker ecosystem is evolving at a very fast pace
so I'm sure the guys are going to come up with a simple, official
solution that will make us forget about all of these bash voodoo very shortly.

Happy containers to everyone!