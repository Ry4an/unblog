+++
date = '2026-02-11T22:25:06-05:00'
title = 'Home Automation Part 2'
tags = [ "home", "ideas-built", "software" ]
cover = ''
+++

[Back in October](/unblog/post/homeautomation_part1/) I talked about my growing,
local Home Assistant setup, including some of my favorite custom automations.
Three months on I'm still having fun with it.  Recent automations include:

 - [Turning off the whole home's water supply if a flood sensor
   triggers](https://github.com/Ry4an/homeassistant-config/commit/9de4bd9af5f2201211eac46e8633e2b0d7f61996#diff-438c5c6c1d1096474c5df4d59ddcb12d5cccf934daa5ee7583351457f7385b44)
 - [Turning on the north kitchen undercabinet lights when the south undercabinet
   lights are turned
   on](https://github.com/Ry4an/homeassistant-config/blob/95fc244bb442b3ce84f8ebefd909cf377f2a7363/automations.yaml#L676)
 - [Automatically turning off the christmas tree at
   1am](https://github.com/Ry4an/homeassistant-config/commit/e2e4f9f121e5c8774df9b2f186296626ea26e000#diff-438c5c6c1d1096474c5df4d59ddcb12d5cccf934daa5ee7583351457f7385b44R738)
 - [Polling a meshtastic
   node](https://github.com/Ry4an/homeassistant-config/commit/60e756c8fe87e8437d29fea023fbc5b83c4b6884#diff-4100aa6a34f3a2817e9b70eaf2efca531092a33868910e6cb46d1327a4277029R31-R37) and [alerting if it's not](https://github.com/Ry4an/homeassistant-config/commit/df7e0f6ebca87e7cf3c4d6f7dfb2ee9a80a88303#diff-438c5c6c1d1096474c5df4d59ddcb12d5cccf934daa5ee7583351457f7385b44R751-R772)
 - [Relaying meshtasting (LoRa) messages to my phone if I'm not
   home](https://github.com/Ry4an/homeassistant-config/blob/d2b578436c8d199f868d47708e6136c83c1e628b/automations.yaml#L773)

I'm particularly happy with how that undercabinet lighting synchronization
worked out.  We have a galley kitchen and wall-switched undercabinet lights on
both sides.  We always use the ones on the south side with a conveniently
located switch and seldom use the ones on the north side with the awkwardly
placed switch.  Now when we turn on one, the other turns on.  That could have
been done when it was wired 20 years ago, but now one Sonoff switch module in
each switch, and it's done over radio in a way no one has to think about.

More on those last two in an upcoming [Meshtastic](https://meshtastic.org/)
post, but all the nerds are playing with it now.

