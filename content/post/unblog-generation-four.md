+++
date = '2025-08-17T08:15:48-04:00'
title = 'Unblog Generation Four'
tags = [ "meta", "software", "python" ]
+++

I've been blogging, unreliably, at ry4an.org since 2003, and just changed the
software powering it for the third time.  Up until today I was using
[blohg](https://app.readthedocs.org/projects/blohg/), worked great, but hadn't
had a release in seven year and still required python 2.7, which is annoying
to install cleanly these days.

A quick look around showed that the static site generator space has exploded
since last I checked.  [Hugo](https://gohugo.io/) is mature and doesn't
require a javascript runtime, which was good enough for me.

Because my blog content has always been in plain text the migration was pretty
painless, and I'm able to keep full history in [source
control](https://github.com/Ry4an/unblog).  Along the way I created a few
[scripts and notes](https://github.com/Ry4an/blohg2hugo) I needed to remove
some blohg-specific stuff from the reStructuredText.  I'll use markdown for
the hugo-native posts, like this one, but it was great to be able to bring the
.rst files across mostly unmodified.

Because every software transition has headaches, here was the most "fun" to
figure out: hugo launches rst2html, a python script, to convert .rst files,
which was a pleasant surprise.  That invocation of rst2html, kept giving
warnings that it couldn't format my `.. code` blocks saying: `(WARNING/2)
Cannot analyze code. Pygments package not found.`

I've worked in python environments for 15 years, and I'm pretty practiced at
figuring out import issues whether they're from multiple installs, virtual
environments, bad python path settings, or duelling package managers.  This
one I couldn't crack.  Finally I ran hugo under `strace` and looked at the
system calls only to figure out that because it was installed via `snap` it
was running in an apparmor profile that prevented it from accessing the system
python where I was making sure pygments was available.  Uninstalling the hugo
snap and just snagging the release binary (the apt package is too old) got
everything working.  **When software's behavior isn't making sense looking at
the system calls with `strace` is so often the right clue.**

Here are the matching announcements for the previous generations:

 - [Generation 1](https://ry4an.org/unblog/post/2003-04-13/) - using mailing
   list software
 - [Generation 2](https://ry4an.org/unblog/post/2005-01-16/) - using a wiki
 - [Generation 3](https://ry4an.org/unblog/post/switch_to_blohg/) - using
   blohg

