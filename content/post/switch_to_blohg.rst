Switching Blogging Software
===========================

This blog started out called the unblog back when blog was a new-ish term and I
thought it was silly.  I'd been on mailing lists like fork_ and Kragan Sitaker's
tol_ for years and couldn't see a difference between those and blogs.  I set up
some `mailing list archive software to look like a blog`_ and called it a day.

Years later that platform was aging, and wikis were still a new and exciting
concept, so I `built a blog around a wiki`_.  The ease of online editing was
nice, though readers never took to wiki-as-comments like I hoped.  It worked
well enough for a good many years, but I kept having a hard time finding my own
posts in Google.  Various SEO-blocking strategies Google employs that I hope
never to have to understand were pushing my entries below total crap.  

Now, I've switched to blohg_ as a blogging platform.  It's based on Mercurial_
my version control system of choice and has a great local-test and push to
publish setup.  It uses ReStructured-Text which is what wiki text became and
reads great as source_ or renders to HTML.  Thanks to `Rafael Martins`_ for the
great software, templates, and help.

The hardest part of the whole setup was keeping every URL I've ever used
internally for this blog still valid.  URLs that "go dead" are a huge pet peeve
of mine.  Major, should-know-better sites do this all the time.  The new web
team brings up brand new site, and every URL you'd bookmarked either goes to a
404 page or to the main page.  URLs are supposed to be durable, and while it's
sometimes a lot of work to keep that promise it's worth it.

In migrating this site I took a couple of steps to make sure URLs stayed valid.
I wrote a quick script to go through the HTTP access logs site for the last few
months, looked for every URL that got a non-404 response, and turned them into
web requests and made sure that I had all the redirects in place to make sure
the old URLs yielded the same content on the staging site.  I did the same
essential procedure when I switched from mailing list to wiki so I had to re-aim
all those redirects too.  Finally, I ran a web spider against the staging site
to make sure it had no broken internal links.  Which is all to say, if you're
careful you can totally redo your site without breaking people's bookmarks and
search results -- please let me know if you find a broken one.

.. _fork: http://www.xent.com/FoRK-archive/spring96/0000.html
.. _tol: http://lists.canonical.org/pipermail/kragen-tol/
.. _mailing list archive software to look like a blog: /unblog/post/2003-04-13/
.. _built a blog around a wiki: /unblog/post/2005-01-16/
.. _blohg: http://hg.rafaelmartins.eng.br/blohg/
.. _mercurial: http://mercurial.selenic.com/
.. _source: /unblog/source/post/switch_to_blohg.txt
.. _Rafael Martins: http://blog.rafaelmartins.org/

.. tags: mercurial,ideas-built,software,meta
