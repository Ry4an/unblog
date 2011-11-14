Miscellaneous Open Source Contributions
=======================================

I'll take Mercurial over git any day for all the reasons obvious to anyone who's
*really* used both of them, but geeyah github sure makes contributing to
projects easy.  At work we had a ten minute MongoDB upgrade downtime turn into
two hours, and when we finally figured out what deprecated option was causing
the daemon launch to abort, rather than grouse about it on Twitter (okay, I did
that too) I was able to submit a `one line patch`_ without even cloning down the
repository that got merged in.

On the more-substantial side I fixed some crash bugs in `dircproxy`_.  It had
been running rock solid for me for a few years, but a recent libc upgrade that
added some memory checking had it crashing a few times a day.  Now (with the
help of Nick Wormley) I was able to `fix`_ some (rather egregious) memory gaffs.
I guess this is the oft trumpeted advantage of open source software in the first
place -- I had software I counted on that stopped working and I was able to fix.
Really though it was just fun to fire up gdb for the first time in ages.

Finally, I was able to take some hours at work and contribute a `cookbook`_ for
`chef`_ to add the `New Relic`_ monitoring agent to our many ec2 instances.
It may never see a single download, but it's nice to know that if someone wants
to use chef to add their systems to the New Relic monitoring display they don't
have to start from scratch.

I've been living in a largely open source computing environment for fifteen
years, but the barrier to entry as minor contributor has never been so low.

.. _one line patch: https://github.com/Ry4an/mongo/commit/cc3de60beb95eebd1e414c50fdbc7a6c8b370a6e
.. _dircproxy: http://code.google.com/p/dircproxy/
.. _fix: https://github.com/w8tvi/dircproxy/pull/1
.. _cookbook: http://community.opscode.com/cookbooks/newrelic_monitoring
.. _chef: http://www.opscode.com/chef/
.. _New Relic: http://newrelic.com/

.. tags: ideas-built,mongodb
