+++
title = "Occuped: Twine + Go + App Engine"
date = "2013-08-11T01:08:00-0400"
tags = ["software", "ideas-built"]
+++

Occuped: Twine + Go + App Engine
================================

In our NY office We've got 40 people working in a space with two
bathrooms.  Walking to the bathrooms, finding them both occupied, and
grabbing a snack instead is a regular occurrence.  For a lark I took
a Twine_ with the breakout board and a few magnetic switches and
connected them to the over taxed bathroom doors.

The good folks at Twine will invoke a web hook on state change, so
I created a `tiny webapp in Go`_ that takes the GET from Twine and
stashes it in the App Engine datastore.  I wrote a `cheesy web front
end`_ to show the current state based on the most recent change.  It
also exposes a JSON API, allowing my excellent_ coworkers_ to build
a native OS X menulet and a `much nicer web version`_.

.. attachment-image:: occupied.jpg
   :width: 408px
   :height: 325px
   :alt: Occupied light


.. _Twine: http://supermechanical.com/
.. _tiny webapp in Go: https://github.com/ry4an/occupied
.. _cheesy web front end: http://dfoccupied.appspot.com/
.. _excellent: https://github.com/chltjdgh86
.. _coworkers: https://github.com/Minasokoni/
.. _much nicer web version: http://lab.robertismy.name/bio/
.. _source: https://github.com/Minasokoni/df-occupy-extended

.. tags: software,ideas-built
