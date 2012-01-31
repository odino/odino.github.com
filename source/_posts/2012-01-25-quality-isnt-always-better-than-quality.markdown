---
layout: post
title: "Quality isn't always better than quantity"
date: 2012-01-25 13:43
comments: true
categories: [data, algorithms]
---

Reading about [data processing with MapReduce](http://www.amazon.com/Data-Intensive-Processing-MapReduce-Synthesis-Technologies/dp/1608453421)
I was astonished when I first encountered the *[Stupid backoff](http://books.google.it/books?id=GxFYuVZHG60C&pg=PA134&lpg=PA134&dq=stupid+backoff+algorithm&source=bl&ots=fMzZNlaNaN&sig=mcEdim6-_wZL4aWKebh3s79KMS4&hl=it&sa=X&ei=z_kfT56BG-vP4QSY2N2ODw&ved=0CD0Q6AEwAzgK#v=onepage&q=stupid%20backoff%20algorithm&f=false)*
algorithm's tale.
<!-- more -->

The story is pretty simple: the [Kneser-Ney](diom.ucsd.edu/~rlevy/lign256/winter2008/kneser_ney_mini_example.pdf)
smoothing strategy was a *state-of-the-art* way for processing data, but it
had an heavy computational cost.

{% blockquote Thorsten Brants http://acl.ldc.upenn.edu/D/D07/D07-1090.pdf Large Language Models in Machine Translation %}
We introduce a new smoothing method, dubbed Stupid Backoff, that is inexpensive to train on large data sets and approaches the quality of Kneser-Ney Smoothing as the amount of training data increases.
{% endblockquote %}

In 2007 [Thorsten Brants](http://www.coli.uni-saarland.de/~thorsten/) developed
a new smoothing algorithm, simpler than the Kneser-Ney one, which was very lean
and appliable to large amounts of data.

## The result?

These algorithms were heavily used in machine translations, and you can already
figure out what happened: with small datasets the *backoff* was generating
less-accurate translations but, as the amount of data analized growed, it was
able to extract more valid translations, eventually beating Kneser-Ney's score{% fn_ref 1 %}.

I'd like you to read a few notes about the *stupid backoff*'s introductory paper:

<iframe src="http://docs.google.com/viewer?url=http%3A%2F%2Facl.ldc.upenn.edu%2FD%2FD07%2FD07-1090.pdf&embedded=true" width="100%" height="780" style="border: none;"></iframe>

{% footnotes %}
  {% fn This was possible, in the machine-translation scenario, thanks to the fact that the algorithm could be "trained" to perform better translations as the dataset grew %}
{% endfootnotes %}
