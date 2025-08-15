+++
title = "Pylint To Github"
date = "2014-09-14T23:16:00-0400"
tags = ["software", "python", "ideas-built"]
+++

Pylint To Github
================

I spent a few hours trying to get the Jenkins_ Git & Github plugins to:

 - run pylint_ on **all** remote branch heads that:

   - arent' too old
   - haven't already had pylint run on them

 - send the repo status back to GitHub

I'm sure it's possible, but the Jenkins Git plugin doesn't like a single build
to operate on multiple revisions.  The repo statuses weren't posting, the wrong
branches were getting built, and it was easier to write `a quick script`_.

Now whenever someone pushes code at DramaFever_ pylint does its thing, and their
most recent commit gets a green checkmark or a red cross.  If/when they open a PR
the status is already ready on the PR and warns folks not to merge it if pylint
is going to fail the build.  They can keep heaping on commits until the PR goes
green.

I run it from Jenkins triggerd by a GitHub push hook, but it's setup so that
even running it from cron on the minute is safe for those without a CI server
yet.

.. attachment-image:: green-checks.png
   :width: 925px
   :height: 262px
   :alt: Branches with green checks

.. _Jenkins: http://jenkins-ci.org/
.. _pylint: http://www.pylint.org/
.. _DramaFever: http://www.dramafever.com
.. _a quick script: https://github.com/Ry4an/pylint-to-github

.. tags: ideas-built,software,python
