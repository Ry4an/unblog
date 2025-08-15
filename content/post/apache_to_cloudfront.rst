+++
title = "Apache To CloudFront With Lambda At Edge"
date = "2019-05-02T22:45:00-0400"
tags = ["meta", "software"]
+++

Apache To CloudFront With Lambda At Edge
========================================

I've been running my (this) vanity website and mail server on Linux machines
I administer myself since 1998 or so, but it's time to rebuild the machine and
hosting static HTTPS no longer makes sense in a world where GitHub or AWS can
handle it flexibly and reliably for effectively free.  I did want to keep
running my own mail server, but centralization in email has made delivery iffy
and everyone I'm communicating with is on gmail, so the data is going there
anyway.

Because I've redone the ry4an.org website so many times and because
`cool URLs don't change`_  I have *a lot* of redirects from old locations to new
locations.  With apache I grossly abused mod_rewrite_ to pattern match old URLs
and transform them into new ones.  No modern hosting provider is going to run
apache, especially with mod_rewrite enabled, so I needed to rebuild the rules
for whatever hosting option I picked.

Github.io won't do real redirects (only meta refresh tags), so that was right
out.  AWS's S3 lets you configure redirects using either a custom
x-amz-website-redirect-location header on a placeholder object in the S3 bucket
or some hoary XML `routing rules`_ at the bucket level, but neither of those
allow anything more complicated than key prefix matching.

AWS's content delivery edge network, CloudFront, doesn't host content or
generate redirects -- it's just a caching proxy --, but it lets you deploy
javascript functions directly to the edge nodes which can modify requests and
responses on their way in and out.  With this `Lambda at Edge`_ capability
you're restricted to specific releases of only the javascript runtime, but
that's enough to get full regular expression matching with group extraction.

.. _cool URLs don't change: https://www.w3.org/Provider/Style/URI.html
.. _mod_rewrite: https://httpd.apache.org/docs/2.4/mod/mod_rewrite.html
.. _routing rules: https://docs.aws.amazon.com/AmazonS3/latest/dev/how-to-page-redirect.html
.. _Lambda at Edge: https://aws.amazon.com/lambda/edge/

.. read_more

I was able to turn twenty years of apache mod_rewrite rules into a hundred-line,
almost-readable `javascript function`_, which adds only half a millisecond to
request processing.  CloudFront doesn't support IndexDocuments (except at the
very top level), but I was able to handle that as a request rewrite, rather than
as a redirect, in the same function.  Using CloudFront and Lambda at Edge to
generate the redirects rather than relying on S3 to create them also allowed me
to disable static website hosting on the bucket and enforce a "no public
objects" policy for all buckets in the AWS account, which is always a good idea
when possible.

I was happy to be able to keep using the same Mercurial based static
`site generator`_ I switched to back in 2011.  Sticking with plain old HTML made
rehosting without retooling possible.  In making sure none of the 1,820 distinct
redirects I'd served over the last year broke I ended up rewriting the same bash
for loops to check every URL that I'd used back in 2011, and finally put them in
a repository_ where maybe I'll remember they exist in a decade when I do this
all over again.

I'm still running personal Linux servers, but they no longer listen on ports 80,
443, or 25.  It feels like the end of an era, but not nearly as sad as when the
server went `from basement to cloud`_ back in 2011.

.. attachment-image:: shutting-down-services.png
   :width: 782px
   :height: 252px
   :alt: Super old System V init stopping services

.. _javascript function: https://github.com/Ry4an/s3-cloudfront-redirect-lambda/blob/master/index.js
.. _site generator: https://ry4an.org/unblog/post/switch_to_blohg/
.. _repository: https://github.com/Ry4an/s3-cloudfront-redirect-lambda
.. _from basement to cloud: https://ry4an.org/unblog/post/eulogy-for-a-good-server/

.. tags: software,meta
