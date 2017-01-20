---
layout: post
title: "Using Terraform in AWS Mumbai"
date: 2016-07-05 16:04
comments: true
categories: [terraform, devops, AWS]
description: "Terraform's AWS regions are hardcoded: we need to re-build it from scratch from a PR that adds support for Mumbai."
---

Terraform is a fantastic tool to manage your infrastructure
with simple and declarative templates; you simply describe
your infrastructure in a template file  that looks like:

```
resource "digitalocean_droplet" "web" {
    name = "tf-web"
    size = "512mb"
    image = "centos-5-8-x32"
    region = "sfo1"
}

resource "dnsimple_record" "hello" {
    domain = "example.com"
    name = "test"
    value = "${digitalocean_droplet.web.ipv4_address}"
    type = "A"
}
```

run `terraform apply` and you're set: Terraform will boot
the infrastructure for you.

AWS recently launched their `ap-south-1` region (Mumbai, India)
and, due to the fact that's much closer to our customer and EC2
there seems to be ~10% cheaper than in AWS Singapore (where we're currently
hosted), we wanted to start experiment moving part of our
infrastructure to this region.

[Terraform, though, has an hardcoded list of AWS regions](https://github.com/hashicorp/terraform/pull/7383#issuecomment-229169574) and,
since Mumbai is a recent addition, it will throw an error saying that
the region isn't supported.

<!-- more -->

The guys have already [added the new region in master](https://github.com/hashicorp/terraform/pull/7383/files), so
we could just wait for the next stable release to be rolled out and we'll be
able to rock it in Mumbai but, since we're troublemakers, let's just not wait
and figure a way to boot our machines in Mumbai **now** :)

Since the changes are already in `master`, we just need to clone the terraform
repo and build it locally:

```
git clone git@github.com:hashicorp/terraform.git
cd terraform
TF_DEV=1 ./scripts/build.sh
```

That's it -- a new `terraform` executable will be created with the latest code
from master (if you're wondering, the `TF_DEV` variable makes it so we
[build terraform only for our architecture](https://github.com/hashicorp/terraform/blob/master/scripts/build.sh#L27-L31), else the `build.sh` script will also
build for bsd, darwin, etc).

Nothing more, nothing less :) Have fun booting your infrastucture with
Terraform: it's an amazing tool built by a [great company](https://www.hashicorp.com/#products) in the DevOps
landscape.
