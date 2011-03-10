Trying Hirelite
===============

Tonight I tried Hirelite_, and I really think they're on to something.  They
arrange online software developer interview speed-dating-style events where N
companies and N software developers each sit in in front of their own webcams
and are connected together for live video chats five minutes at a time.
It's like chatroulette with more hiring talk and less genitalia. 

They pre-screen the developers to make sure they're at least able to solve a
simple programming problem and screen the companies by charging them a little
money.  Each session has a theme, like "backend developers", and a geographic
region associated with it.  After each five minute interview -- there's a
countdown timer at the top -- each party indicates with a click whether or not
they'd like to talk further.  Mutual matches get one another's contact
information immediately afterward.

Observations
------------

I've only tried Hirelite once, which was only nine interviews, but from my
limited experience here are some of my observations:

- No one is ready for an interview-like talk that lasts only five minutes.  One
  party or another launches into a sales pitch and uses up two or three minutes
  right off the bat, leaving little time for a more bidirectional exchange.
- When it's clearly a bad skills/interests match, five minutes is still easy to
  fill.  If two people can't find *something, anything* to talk about for five
  minutes something is wrong with one or both of them.
- With only five minutes it's less like an interview, or even a phone
  pre-screen, and more like a hand-delivery of a resume.
- Race and gender aren't always knowable from a resume, but they immediately are
  when a video chat happens this early in the process.  Conceivably there could
  be some EoE considerations there, be they concious or not.
- The novelty of what everyone is doing was enough to keep things light.  One of
  my interviews started with an interviewer holding up a sheet of paper that
  said "USE TEXT CHAT" where he explained his mic wasn't working.  How everyone
  dealt with the technical glitches is probably as good an indicator of
  personality as anything else -- I did an entire exchange using text-chat and
  pantomime.

Tips for Participants
---------------------

Again, I've only done this once, but here are some tips I intend to employ if I
try this again:

- Make sure to wear headphones -- without them you'll echo.
- If you're using a laptop have an external keyboard plugged in -- you don't
  want to have to hunch forward to use the one on your laptop if it comes to
  text chat.
- Interviewees: Make sure to include a resume link in your pre-interview
  profile.  Most interviewers had looked at mine, and the rest did so during the
  chat.
- Check your lighting before starting.  I looked like I was sitting in a cave.

Technical Issues
----------------

I'm sufficiently enamored with the system that the technical glitches were more
funny than they were frustrating, but I could easily see someone else feeling
otherwise.  Here's what I encountered.

Before the session began I followed Hirelite's advice to test my "video and
audio" with their test interview link.  My camera worked fine -- I could see
myself -- but I couldn't hear myself on audio.  I spoke to Hirelite about that,
and it turns out you're not supposed to hear yourself during the test -- there
is no test for audio.

I tried both Google Chrome on Linux and Firefox on Linux with the test, and both
worked.  It wasn't until my audio stopped working well during an interview that
I realized the text chat wasn't working in Chrome -- the text entry box was
cutoff on my small netbook screen.  A quick switch to Firefox got that going.

The most persistent technical problem I had was the lagging of my outbound
audio.  I could generally see and hear the interviewer with little lag and in
synch, and my interviewer and I could both see my video unlagged, but my audio
was delayed by about 40 seconds starting about the sixth interview.  This made
speaking all but impossible.

My internet connection speed just tested out at 14Mbps downstream and 5Mbps
upstream which is more than sufficient for small video and low bitrate audio, so
I don't think the problems were with my bandwidth.  What's more, since Hirelite
is built in Flash (who does that this decade?!) likely using RTFMP_ (I'm kicking
myself for not running Wireshark_ during the session) audio and video are
multiplexed in the same packet stream -- so any de-synch-ing of the two is
almost certainly a software problem not a network problem.

When things were glitching I was often able to improve them temporarily by
reloading the page.  This kills off the Flash component and reloads it, which
brought the lag down for awhile.  The Hirelite system was able to re-connect me
to my in-progress session with nary a hiccup, which is a nice touch.  I was
afraid it would automatically move me to the next interviewer.

All in all a great idea.  StackExchange_ should buy Hirelite using some the `12
million they just raised`_, hopefully some of the `money from their snack
room`_.

.. _Hirelite: http://www.hirelite.com
.. _Wireshark: http://www.wireshark.org/
.. _RTFMP: http://en.wikipedia.org/wiki/Real_Time_Media_Flow_Protocol
.. _StackExchange: http://stackexchange.com/
.. _12 million they just raised: http://blog.stackoverflow.com/2011/03/a-new-name-for-stack-overflow-with-surprise-ending/
.. _money from their snack room: http://blog.stackoverflow.com/wp-content/uploads/A31.jpg
