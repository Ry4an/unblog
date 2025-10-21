+++
date = '2025-10-21T13:58:26-04:00'
title = 'Home Automation Part 1'
tags = [ "home", "ideas-built", "software" ]
cover = 'climate-history.png'
+++

I've been futzing with home automation projects for longer than I've had a home,
but it sure has gotten easier lately.  Twenty years ago I was cobbling together
individual hardware sensor and actuator pairs for automations with no central
coordinating system and no logging.  Ten years ago I was buying third party
automation sets where everything was controlled by a cloud service and
everything worked well until that company lost interest in the product they'd
sold you and then everything stopped working suddenly.  Now there are great
local control options, with open sensors, open acutators, open controller
software, and great history keeping.  I'm buying parts from many companies, but
the continued working of my setup doesn't require any of them being around next
year.

Best yet a lot of the cloud-required stuff I've bought in the past (those whose
companies are still in business) can be made to work with my local set up until
I can replace the cloud-based components I've already installed.  It's all local
going forward, with a good backward compatibility path.

I'm using [Home Assistant](https://www.home-assistant.io/) as my central
coordinator, and so far I've been very pleased with what it has to offer.  I'm
particularly impressed with it statistical history system.  It's doing
prometheus/borgmon style numerical value retention with reduced frequency as
data ages.  All that data is in a local sqllite database and easily extracted
and backed up.  I've been able to pull in all of my existing cloud-based devices
and have been rolling out z-wave and zigbee local devices as I go.

[{{<figure alt="A week of temperature and humidity history" src="climate-history.png" width="677" height="651">}}](climate-history.png)  1354 x 1302
(caption: a week's worth of temperature and humidity history - click to
embiggen)

Some of my favorite simple automations so far are:
 * [Turn off the TV after it's been paused for 15 minutes](https://github.com/Ry4an/homeassistant-config/blob/2ac1904b631c6f22ae1919317cf44eae1765ba78/automations.yaml#L301-L341)
 * [Display when the dog was last walked](https://github.com/Ry4an/homeassistant-config/blob/2ac1904b631c6f22ae1919317cf44eae1765ba78/automations.yaml#L130-L153) on the [family dashboard](https://dakboard.com/)
 * [Send a "Cats Escaping!" alert if a door is open 5 minutes](https://github.com/Ry4an/homeassistant-config/blob/2ac1904b631c6f22ae1919317cf44eae1765ba78/automations.yaml#L446-L476)
 * [Reboot the router if the internet is unavailable](https://github.com/Ry4an/homeassistant-config/blob/2ac1904b631c6f22ae1919317cf44eae1765ba78/automations.yaml#L581-L606)

It's a terrible shame that Home Assistant uses YAML files which don't support
 durable comments, but at least the history can be tracked in a [git
 repo](https://github.com/Ry4an/homeassistant-config) with commented history.

So far when purchasing parts I've found the [Innovelli](https://inovelli.com/)
stuff to be incredibly high quality.  The [Sonoff](https://sonoff.tech/) stuff
a good quality to price trade off.  The Moe's and Tuya zigbee stuff is pretty
hit or miss.
