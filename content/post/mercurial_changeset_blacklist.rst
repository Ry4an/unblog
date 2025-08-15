+++
title = "Blacklisting Changesets in Mercurial"
date = "2011-01-29T00:34:00-0600"
tags = ["software", "mercurial", "ideas-built"]
+++

Blacklisting Changesets in Mercurial
====================================

Distributed version control systems have revolutionized how software teams work,
by making merges no longer scary.  Developers can work on a feature in relative
isolation, pulling in new changes on their schedule, and providing results back
on their (manager's) timeline.

Sometimes, however, a developer working in their own branch can do something
really silly, like commit a *huge* file without realizing it.  Only after they
push to the central repository does the giant size of the changeset become
known.  If one catches it quickly, one just removes the changeset and all is
will.

If other developers have pulled that giant changeset you're in a slightly harder
spot.  You can remote it from your repository and ask other developers to do the
same, but you can't force them to do so.  Unwanted changesets let loose in a
development group have a way of getting pushed back into a shared repository
again and again.

To ban the pushing of a specific changeset to a Mercurial repository one can use
this terse hook in the repository's ``.hg/hgrc`` file::

  [hooks]
  pretxnchangegroup.ban1 = ! hg id -r d2cfe91d2837+ /dev/null 2>&1

Where ``d2cfe91d2837`` is the node id of the forbidden changeset.

That's fine for a single changeset, but if you more than a few to ban this form
avoids having a hook per changeset::

  [hooks]
  pretxnchangegroup.ban = ! hg log --template '{node|short}\n' \
    -r $HG_NODE:tip | grep -q -x -F -f /path/to/banned

where banned ``/path/to/banned`` is a file of disallowed changesets like::

    acd69df118ab
    417f3c27983b
    cc4e13c92dfa
    6747d4a5c45d

It's probably prohibitively hard to ban changesets in everyone's repositories,
but at least you can set up a filter on shared repositories and publicly shame
anyone who pushes them.

.. tags: mercurial,ideas-built,software
