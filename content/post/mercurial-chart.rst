Mercurial Chart Extension
=========================

Back in 2008 I wote an extension for Mercurial to render activity charts like
this one:

.. attachment-image:: mercurial-chart.png
   :width: 400px
   :height: 400px
   :alt: Mercurial Change Chart

Yesterday I finally got around to updating it for modern Mercurial builds,
including 2.1.  It's `posted on bitbucket`_ and has a `page on the Mercurial
wiki`_.  It uses pygooglechart_ as a wrapper around the excellent `Google
image chart API`_.  

I really like the google image charts becuse the entire image is encapsulated as
a URL, which means they work great with command line tools.  A script can output
a URL, my terminal can make it a link, and I can bring it up in a browser window
w/o ever really using a GUI tool at all.

If I take any next step on this hg-chart-extension it will be to accept
revsets_ for complex secifications of what changesets one wants graphed, but
given that it took me two years to fix breakage that happened with version 1.4
that seems unlikely.

.. _posted on bitbucket: https://bitbucket.org/Ry4an/hg-chart-extension
.. _page on the Mercurial wiki: http://mercurial.selenic.com/wiki/ChartExtension
.. _pygooglechart: http://pygooglechart.slowchop.com/
.. _Google image chart API: http://code.google.com/apis/chart/image/
.. _revsets: http://selenic.com/hg/help/revsets

.. tags: mercurial,python,ideas-built
