+++
title = "A Few Quick EC2 Security Group Migration Tools"
date = "2011-04-25T23:50:00-0500"
tags = ["software", "security", "ideas-built"]
+++


Like half the internet I'm working on duplicating a setup from one Amazon EC2
availability zone to another.  I couldn't find a quick way to do that if my
stuff wasn't already described in Cloud Formation templates, so I put together a
script that queries the security groups using ``ec2-describe-group`` and
produces a shell script that re-creates them in a different region.

If all your ec2 command line tools and environment variables are set you can
mirror us-east-1 to us-west-1 using::

    ec2-describe-group | ./create-firewall-script.pl > create-firewall.sh
    ./create-firewall.sh

With non-demo security group data I ran into some group-to-group access grants
whose purpose wasn't immediately obvious, so I put together a second script
using graphviz to show the ALLOWs.  A directed edge can be read as "can access".

.. image:: https://ry4an.org/unblog/attachments/demo-security-groups.png
   :width: 572px
   :height: 299px
   :alt: Security group access grants

That script can also be invoked as::

    ec2-describe-group | ./visualize-security-groups.pl > groups.png

The labels on the edges can be made more detailed, but having each of tcp, udp, and icmp shown started to get excessive.

Both scripts and sample input and output are in the `provided tarball`_.

.. _provided tarball: https://ry4an.org/unblog/attachments/ec2-security-group-tools.tar.gz

.. tags: security,ideas-built,software
