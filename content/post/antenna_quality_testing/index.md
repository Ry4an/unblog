+++
date = '2026-03-04T08:31:29-05:00'
title = 'Testing Antenna Quality'
tags = [ "ideas-built", "software" ]
cover = 'snr-table.png'
+++

With a [Meshtastic](https://meshtastic.org/) antenna the advice is to put it as
high as you can with as few obstructions as you can manage.  For my home setup
that meant a few physical iterations as it went from inside my office, to inside
the attic, to outside the attic below the roofline, and finally outside the
attic and higher than the roofline.

As an engineer I want baseline quality data before I make a change, so I know if
my change helped, did nothing, or actually made things worse.  I don't have the
knowledge or the tools to really measure the quality of my antenna setups, and
I want real-world connectivity metrics more than I want a gain measurement.

At first I tried using the [Meshtastic Range Test
module](https://meshtastic.org/docs/configuration/module/range-test/) and
walking around with a handheld unit to find the geographic boundary at which
I lost signal from my home mounted antenna, hypothesizing that with antenna
improvements that range would increase.  Unfortunately I couldn't get decent
data in a reasonable amount of time.  The Range Test module broadcasts
a sequential message every thirty seconds and both nodes are supposed to keep
logs of what's sent and received and where you were standing, but they were
always near blank when I exported them and the GPS location info from my
handheld wasn't great whether I was using the location from the portable node or
my connected phone.  I gave up on this after a few days of long, circular dog
walks.

Once I built [a script to download node database
info](https://github.com/Ry4an/meshtastic-info-to-homeassistant-webhook)
I started running that hourly and dumping the output from my home node to
a growing json file.  Then I was able to use `jq` to parse out only the nodes
that were zero hops away (directly connected) from my home node with this
command line:

```sh
jq -r '.time as $when | .nodes[] | select(.hopsAway == 0) | [ $when, .num, .lastHeard, .snr ] | @csv' repeated_info.json
```

That got me CSV rows containing the time the data was gathered, the remote node
id, when that node was last heard from, and the signal to noise ratio of the
direct connection to that node.  In [a
spreadsheet](https://docs.google.com/spreadsheets/d/e/2PACX-1vTWeuBZEXoB2zlmRRo4suTe7RRqgmqTmMHAvxPX_fmA6aEbGQkImefDL6i4zpJRp3N_f-jGEwiPWY3o/pubhtml)
I was able to look across days of data and compare the quality of my connection,
represented by the signal to noise ratio, of each node I directly connect to.
I'm able to screen out duplicate reads using the `lastHeard` value and can
deduce the antenna position from the time of the read and a list of when I made
the antenna improvements (tab 4).  Since `snr` values are exponential they can't
be averaged, but I take the median value, which might even be statistically
valid?

With a day's worth of reads I see enough of the same nodes that they can be
directly compared, which is what I've done below, but I also think there's also
value looking at the median signal to noise value in aggregate too.  Signal to
noise is a dimensionless ratio with a higher value being better, and anything
above zero meaning the signal exceeds the noise.  The numbers I've got below
skew negative, but the signal *is* getting through.

So far I've found that having the antenna outside the house **is** better than
having it inside the house, and that having it above the roofline helps even
more.  It's probably not what an RF engineer would have done, but it's enough to
feel good about the time I spent leaning out of a third floor window mounting
a not too attractive antenna mast on the side of our house.

{{<figure alt="screenshot of aggregate connection quality data" src="snr-table.png" width="648" height="619">}}


[{{<figure alt="Meshtastic node mounted outside a window" src="window-antenna.jpg" width="324" height="576">}}](window-antenna.jpg)
(caption: Meshtastic node mounted outside a window - click to embiggen)
