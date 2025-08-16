+++
title = "Low Flow Shower Delay"
date = "2012-05-23T11:35:00-0400"
tags = ["funny", "ideas-built"]
+++

Low Flow Shower Delay
=====================

When I start up the shower it's the wrong temperature and adjusting it to the
right temperature takes longer in this apartment than it has in any home in
which I've previously lived.  I wanted to blame the problem on the `low flow
shower head`_, but I'm having a hard time doing it.  My thinking was that the
time delay from when I adjust the shower to when I actually feel the change is
unusually high due to the shower head's reduced flow rate.

In setting out to measure that delay I first found the flow rate in liters per
second for the shower.  I did this three times using a bucket and a stopwatch
finding the shower filled 1.5 qt in 12 s, or 1.875 gpm, or 0.118 liters per
second.  A low flow shower head, according to the US EPA's WaterSense program,
is under 2.0 gpm, so that's right on target.

That let me know how quickly the "wrong temperature" water leaves the pipe, so
next to see how much of it there is.  From the hot-cold mixer to the shower head
there's 65 inches of nominal 1/2" pipe, which has an inner diameter of 0.545
inches.  The volume of a cylinder (I'm ignoring the curve of the shower arm) is
just pi times radius squared times length:

.. math::

  V_{cylinder} = \pi r^{2} L

Converting to normal units gives 1.3843 centimeters diameter and 165.1
centimeters length, which yeilds 248 |cubic-centimeters|, or 0.248 liters, of
wrong temperature water to wait through until I get to sample the new mix.

With a flow rate of 0.118 liters per second and 0.248 liters of unpleasant water
I should be feeling the new mix in 2.1 seconds.  I recognize that time drags
when you're being scalded, but it still feels like longer than that.

I've done some casual reading about linear shift time delays in feedback-based
control systems and the oscillating converge they show certainly aligns with the
too-hot then too-cold feel of getting this shower right.  This graph is `swiped
from MathWorks`_ and shows a closed loop step response with a 2.5 second delay:

.. image:: /unblog/attachments/delayed-control.png
   :width: 560px
   :height: 420px
   :target: http://www.mathworks.com/products/control/demos.html?file=/products/demos/shipping/control/MADelayResponse.html
   :alt: Closed loop step response with 2.5 second delay.

That shows about 40 seconds to finally home-in on the right temperature and
doesn't include a failure-prone, over-correcting human.  I'm still not convinced
the delay is the entirety of the problem, but it does seem to be a contributing
factor.  Some other factors that may affect perception of how show this shower
is to get right are:

- non-linearity in the mixer
- water in the shower head itself
- water already "in flight" having left the head but not yet having hit me

Mercifully, the water temperature is consistent -- once you get it dialed in
correctly it stays correct, even though a long shower.

I guess the next step is to get out a thermometer and both try to characterize
the linearity of the mixing control and to try to measure rate of change in the
temperature as related to the magnitude of the adjustment.

**Update**: I `got a ChemE friend to weigh in`_ with some help.

.. _low flow shower head: https://en.wikipedia.org/wiki/Shower#Shower_heads
.. _swiped from MathWorks: http://www.mathworks.com/products/control/demos.html?file=/products/demos/shipping/control/MADelayResponse.html
.. |cubic-centimeters| replace:: cm\ :sup:`2`
.. _got a ChemE friend to weigh in: https://plus.google.com/108862848685444874954/posts/EgpCNbYFMjT

.. tags: funny, ideas-built
