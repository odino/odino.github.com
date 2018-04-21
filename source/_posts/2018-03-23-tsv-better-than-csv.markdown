---
layout: post
title: "TSV, better than CSV"
date: 2018-03-23 14:29
comments: true
categories: [tsv. csv, format]
description: "Wondering whether you should use CSV or TSV files? Don't bother, TSV is the answer."
---

Lately I've been getting a few questions on why one should use `.tsv` files
since CSVs are "standard" and virtually everyone knows how they work -- so I wanted
to clarify this once and for all.

<!-- more -->

**CSVs ARE A PAIN IN THE BACK. USE TSVs SINCE THEY LIKELY WON'T SCREW AROUND WITH
YOUR SOURCE DATA.**

To put it differently:

{% blockquote Wikipedia https://en.wikipedia.org/wiki/Tab-separated_values Tab-separated values %}
TSV is an alternative to the common comma-separated values (CSV) format, which often causes difficulties because of the need to escape commas – literal commas are very common in text data, but literal tab stops are infrequent in running text. The IANA standard for TSV achieves simplicity by simply disallowing tabs within fields.
{% endblockquote %}

Do yourself a favor and stop using CSVs, transition over to
TSVs since they're insanely less error-prone -- say goodbye to sleepless nights
trying to figure out why funny data has been uploaded to the DB.

If you're worried about converting old CSV documents, python has the answer:

``` python csv2tsv.sh
#!/usr/bin/env python
import csv, sys
csv.writer(sys.stdout, dialect='excel-tab').writerows(csv.reader(sys.stdin))
```

It's then a matter of pipes: `cat file.csv | csv2tsv.sh` and you're done.
