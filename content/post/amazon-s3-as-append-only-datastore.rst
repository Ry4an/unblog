+++
title = "Amazon S3 as Append Only Datastore"
date = "2013-02-03T10:10:00-0500"
tags = ["software", "ideas-built"]
+++

Amazon S3 as Append Only Datastore
==================================

As a hack, when I need an append-only datastore with no authentication
or validation, I use Amazon S3.  S3 is usually a read-only service from
the unauthenticated web client's point of view, but if you enable access
logging to a bucket you get full-query-parameter URLs recorded in a text
file for GETs that can come from a form's action or via XHR.

There aren't a lot of internet-safe append-only datastores out there.
All my favorite noSQL solutions divide permissions into read and/or
write, where write includes delete.  SQL databases let you grant an
account ``insert`` without ``update`` or ``delete``, but still none
suggest letting them listen on a port that's open to the world.

This is a bummer because there are plenty of use cases when you want
unauthenticated client-side code to add entries to a datastore, but not
read or modify them: analytics gathering, polls, guest books, etc.
Instead you end up with a bit of server side code that does little more
than relay the insert to the datastore using over-privileged
authentication credentials that you couldn't put in the client.

To play with this, first, create a file named ``vote.json`` in a bucket
with contents like ``{"recorded": true}``, make it world readable, set
``Cache-Control`` to ``max-age=0,no-cache`` and ``Content-Type`` to
``application/json``.  Now when a browser does a GET to that file's
https URL, which looks like a real API endpoint, there's a record in the
bucket's log that looks something like::

    aaceee29e646cc912a0c2052aaceee29e646cc912a0c2052aaceee29e646cc91
    bucketname [31/Jan/2013:18:37:13 +0000] 96.126.104.189
    - 289335FAF3AD11B1 REST.GET.OBJECT vote.json "GET
      /bucketname/vote.json?arg=val&arg2=val2 HTTP/1.1" 200 - 12 12
    9 8 "-" "lwp-request/6.03 libwww-perl/6.03" -

The `full format is described by Amazon`_, but with client IP and user
agent you have enough data for basic ballot box stuffing detection, and
you can parse and tally the query arguments with two lines of your
favorite scripting language.

This scheme is especially great for analytics gathering because and one
never has to worry about full log on disks, load balancers, backed up
queues, or unresponsive data collection servers.  When you're ready to
process the data it's already on S3 near EC2, AWS Data Pipeline or
Elastic MapReduce.  Plus, S3 has better uptime than anything else Amazon
offers, so even if your app is down you're probably recording the failed
usage attempts.

.. _full format is described by Amazon: http://docs.aws.amazon.com/AmazonS3/latest/dev/LogFormat.html

.. tags: software,ideas-built
