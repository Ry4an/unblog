+++
title = "OS X Linux Clipboard Sharing"
date = "2012-04-17T20:44:00-0400"
tags = ["software", "ideas-built"]
+++


My primary home machine is a Linux deskop, and my primary work machine is an OSX
laptop.  I do most of my work on the Linux box, ssh-ed into the OS X machine
-- I recognize that's the reverse of usual setups, but I love the
awesome_ window manager and the copy-on-select `X Window selection`_ scheme.

My frustration is in having separate copy and paste buffers across the two
systems.  If I select something in a work email, I often want to paste it into
the Linux machine.  Similarly if I copy an error from a Linux console I need to
paste it into a work email.

There are `a lot of ways to unify clipboards`_ across machines, but they're all
either full-scale mouse and keyboard sharing, single-platform, or GUI tools.

Finding the excellent xsel_ tool, I cooked up some command lines that would let
me shuttle strings between the Linux selection buffer and the OS X system via
ssh.

I put them into the Lua script that is the shortcut configuration for awesome
and now I can move selections back and forth.  I also added some shortcuts for
moving text between the Linux selection (copy-on-select) and clipboard
(copy-on-keypress) clipboard.

.. code:: lua

    -- Used to shuttle selection to/from mac clipboard
    select_to_mac   = "bash -c '/usr/bin/xsel --output | ssh mac pbcopy'"
    mac_to_select   = "bash -c 'ssh mac pbpaste | /usr/bin/xsel --input'"
    -- Used to shuttle between selection and clipboard
    select_to_clip  = "bash -c '/usr/bin/xsel --output | /usr/bin/xsel --input --clipboard'"
    clip_to_select  = "bash -c '/usr/bin/xsel --output --clipboard | /usr/bin/xsel --input'"

    awful.key({ modkey,           }, "c", function () awful.util.spawn(mac_to_select)  end),
    awful.key({ modkey,           }, "v", function () awful.util.spawn(select_to_mac)  end),
    awful.key({ modkey, "Shift"   }, "c", function () awful.util.spawn(clip_to_select) end),
    awful.key({ modkey, "Shift"   }, "v", function () awful.util.spawn(select_to_clip) end),

.. _awesome: http://awesome.naquadah.org/
.. _X Window selection: https://en.wikipedia.org/wiki/X_Window_selection
.. _a lot of ways to unify clipboards: http://gigaom.com/collaboration/7-ways-to-a-unified-clipboard/
.. _xsel: http://www.kfish.org/software/xsel/

.. tags: software,ideas-built
