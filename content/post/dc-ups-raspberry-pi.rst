+++
title = "Raspberry Pi UPS"
date = "2016-03-13T23:12:00-0400"
tags = ["home", "ideas-built"]
+++

Raspberry Pi UPS
================

I'm starting to do more on a raspberry pi I've got in the house, and I wanted it
to survive short power outages.  I looked at buying an off the shelf
Uninteruptable Power Supply (UPS), but it just struck me as silly that I'd be
using my house's 120V AC to power to fill a 12V DC battery to be run through an
inverter into 120V AC again to be run through a transformer into DC yet again.
When the house is out of power that seemed like a lot of waste.

A little searching turned up the `PicoUPS-100`_ UPS controller.  It seems like
it's mostly used in car applications, but it has two DC inputs and one DC output
and handles the charging and fast switching.  The non-battery input needs to be
greater than the desired 12 volts, so I ebayed a 15v power supply from an old
laptop.  I added a `voltage regulator`_ and `buck converter`_ to get solid 12v
(router) and 5v (rpi) outputs.  Then it caught on fire:


.. attachment-image:: burned.jpg
   :width: 361px
   :height: 242px
   :alt: Scorched UPS controller

But I re-bought the charred parts, and the second time it worked just fine:

.. attachment-image:: ups.jpg
   :width: 432px
   :height: 243px
   :alt: Working UPS setup

.. _PicoUPS-100: http://www.mini-box.com/picoUPS-100-12V-DC-micro-UPS-system-battery-backup-system
.. _voltage regulator: http://www.amazon.com/gp/product/B00OZGVL4O
.. _buck converter: https://www.adafruit.com/products/1385

.. read_more

The rpi and router draw 0.69 amps when running from the battery, so the 12Ah
sealed lead acid battery I have in place should get me a good 17 hours or so.

.. tags: ideas-built,home
