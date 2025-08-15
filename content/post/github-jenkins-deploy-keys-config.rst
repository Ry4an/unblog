+++
title = "GitHub Jenkins Deploy Keys Config"
date = "2012-11-06T14:37:00-0500"
tags = ["software", "security", "ideas-built"]
+++

GitHub Jenkins Deploy Keys Config
=================================

GitHub_ doesn't let you use the same deploy key for multiple repositories within
a single organziation, so you have to either (a) manage multiple keys, (b)
create a non-human user (boo!), or (c) use their not-yet-ready for primetime
HTTP OAUTH deploy access, which can't create read-only permissions.

In the past to managee the multiple keys I've either (a) used ssh-agent or (b)
specified which private key to use for each request using ``-i`` on the command
line, but neither of those are convenient with Jenkins_.

Today I finally thought about it a little harder and figured out I could use
fake hostnames that map to the right keys within the ``.ssh/config`` file for the
Jenkins user.  To make it work I put stanzas like this in the config file::

    Host repo_name.github.com
        Hostname github.com
        HostKeyAlias github.com
        IdentityFile ~jenkins/keys/repo_name_deploy

Then in the `Jenkins GitHub Plugin`_  config I set the repository URL as::

    git@repo_name.github.com:ry4an/repo_name.git

There is no host ``repo_name.github.com`` and it wouldn't resolve in DNS, but
that's okay because the ``.ssh/config`` tells ssh to actually go to ``github.com``,
but we do get the right key.

Maybe this is obvious and everyone's doing it, but I found it the least-hassle
way to maintain the accounts-for-people-only rule along with the
separate-keys-for-separate-repos rule and without running the ssh-agent daemon
for a non-login shell.

.. _GitHub: http://github.com
.. _Jenkins: http://jenkins-ci.org/
.. _Jenkins GitHub Plugin: https://wiki.jenkins-ci.org/display/JENKINS/GitHub+Plugin


.. tags: software,ideas-built,security
