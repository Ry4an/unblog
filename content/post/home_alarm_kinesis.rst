+++
title = "Home Alarm Analytics With AWS Kinesis"
date = "2017-01-18T00:19:00-0500"
tags = ["home", "ideas-built", "software", "python", "security"]
+++

Home Alarm Analytics With AWS Kinesis
=====================================

Home security system projects are fun because everything about them screams
"1980s legacy hardware design".  Nowhere else in the modern tech landscape
does one program by typing in a three digit memory address and then entering
byte values on a numeric keypad.  There's no enter-key -- you fill the
memory address.  There's no display -- just eight LEDs that will show you
a byte at a time, and you hope it's the address you think it is.  Arduinos
and the like are great for hobby fun, but these are real working systems
whose core configuration you enter byte by byte.

The feature set reveals 30 years of crazy product requirements.  You can
just picture the well-meaning sales person who sold a non-existent feature
to a huge potential customer, resulting in the boolean setting that lives
at address 017 bit 4 and whose description in the manual is:

.. pull-quote::

    ON: The double hit feature will be enabled. Two violations of the same
    zone within the Cross Zone Timer will be considered a valid Police Code
    or Cross Zone Event. The system will report the event and log it to the
    event buffer. OFF: Two alarms from the same zone is not a valid Police
    Code or Cross Zone Event

I've built out alarm systems for three different homes now, and while
occasionally frustrating it's always a satisfying project.  This most
recent time I wanted an event log larger than the 512 events I can view
a byte at a time.  The central dispatch service I use will sell me back my
event log in a horrid web interface, but I wanted something
programmatically accessible and ideally including constant status.

The hardware side of the solution came in the form of the `Alarm Decoder`_
from Nu Tech.  It translates alarm panel keypad bus events into events on
an RS-232 serial bus.  That I'm feeding into a Raspberry Pi.  From there
the alarmdecoder_ package on PyPI lets me get at decoded events as
Python objects.  But, I wanted those in a real datastore.

.. _Alarm Decoder: http://www.alarmdecoder.com/
.. _alarmdecoder: https://pypi.python.org/pypi/alarmdecoder

.. read_more

The alarmdecoder package provides serial-over-IP support I could have used
to send not-yet-decoded events to a lambda function, but this is the cloud
API era: if your bytes on the wire aren't JSON encoded, you're not wasting
enough of them.  I started out planning to send the events over SNS, but
AWS has doubled down on their Kinesis_ brand with Streams, Firehose, and
Analytics, so I started there.

Kinesis Streams provide real time ingestion, guaranteed ordering, and
capacity auto-scaling, but I have one home not thousands.  Kinesis
Analytics provide event manipulation, filtering, and fan out, but at the
expense of always-running ec2 nodes.  Kinesis Firehose was the right fit.
It takes single or batched events in HTTP POSTs and stashes them in either
elasticsearch, Redshift, or directly into S3.

Relaying the data to Kinesis Firehose took a simple python event handler:

.. code:: python

    def send_message(sender, message):
        """
        Send message events from the AlarmDecoder to Kinesis.
        """
        message_json = json.dumps(message.dict(), sort_keys=True,
                default=datetime_formatter)
        response = firehose.put_record(DeliveryStreamName=STREAM_NAME,
                Record={'Data': message_json + "\n"})
        log.debug("Sent %s => %s", message_json, repr(response))

The real ad2kinesis_ code has actual error checking and stuff.  The only
trick there was getting the trailing newline on the JSON records.  Without
it Kinesis Streams will correctly intepret each object as a separate
event record, however Kinesis Firehose (the cheap one) batches them into
files in S3, and AWS's other tools will only read the first event per file.
I have Firehose configured to flush to file every sixty seconds, which
means I'd only get one event a minute.

And where am I consuming those events?  For now in AWS Athena_, which is
their SaaS Presto_ offering.  I can quickly, and paying per-query run SQL
against the million events I've logged in the last month.  If I want to
start reacting real-time I can change Firehose to Streams and Analytics.
If I want faster queries I can load the S3 data directly into Redshift or
elasticsearch.

I'm doing nothing more than playing with this, but clearly one could set up
a truly modern alarm monitoring company in the cloud without banks of
modems and with a first rate software offering.  The pieces are all there.

.. _Kinesis: https://aws.amazon.com/kinesis/
.. _ad2kinesis: https://bitbucket.org/Ry4an/ad2kinesis/
.. _Athena: https://aws.amazon.com/athena/
.. _Presto: https://prestodb.io/

.. raw:: html

    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shCore.js"></script>
    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shBrushPython.js"></script>
    <link type="text/css" rel="stylesheet" href="https://ry4an.org/unblog/static/syntaxhighlighter/shCoreDefault.css"/>
    <script type="text/javascript">SyntaxHighlighter.defaults.toolbar=false; SyntaxHighlighter.all();</script>

.. tags: python,ideas-built,software,home,security
