+++
title = "Traffic Analysis In Perl and Scala"
date = "2011-02-06T12:19:00-0600"
tags = ["scala", "software", "perl"]
+++


I needed to implement the algorithm in `Practical Traffic Analysis Extending and
Resisting Statistical Disclosure`_ in a hurry, so I turned to my old friend
Perl.  Later, when time permitted I re-did it in my new favorite language,
Scala_.  Here's a quick look at how a few different pieces of the implementation
differed in the two languages -- and really how idiomatic Perl and idiomatic
Scala can look pretty similar when one gets past syntax.

.. _Practical Traffic Analysis Extending and Resisting Statistical Disclosure: http://scholar.google.com/scholar?cluster=12277737764453076362
.. _Scala: http://www.scala-lang.org/

.. read_more

Parsing
-------

The input lines for the dataset came in 256 pairs, each looking like this::

    S[  1]: [v3,h2,o9,f7,a0,g0,r9,x3,q2,h9,q0,b5,c4,f5,e6,c5,r3,e2,s0,c2,b9,d4,v2,w4,t2,v4,d4,f0,i9,d8,s9,m4]
    R[  1]: [r0,h5,u6,f5,v7,j6,p3,r3,j6,y0,u0,v8,q9,f0,b4,k9,w1,k3,a2,a8,h2,h6,a0,o5,r7,e0,r7,y2,q0,a2,a2,r3]

Where each pair of lines represents a round of 32 messages sent (S) and received
(R) by the persons indicated.  In the example above we know that out of 32
messages sent and received that person d4 sent two messages, person x3 sent one
message, person a2 received three messages, and person w1 received one message.

Given that set of 32 messages there's no way to know who sent to whom, but
looking at all 256 sets of 32 messages and using the method in the paper one can
make a pretty good guess.

Looking at the method described in the paper, the data that had to be extracted
from those lines in order to answer the "who did *target* send to most?"
question was:
 
- total number of messages sent in each round (always 32 in this sample)
- number of messages sent by *target* in each round that *target* sent any
  message
- number of messages each person received in each round *target* sent a message
- number of messages each person received in each round *target* **didn't**
  send a message

In Perl the code for gathering that data looked like:

.. code:: perl

    my @recipientsRoundsTargetSent = ();
    my @messagesTargetSentPerRound = (); # only rounds where s/he did send
    my @recipientsRoundsTargetNotSent = ();
    my $roundSize; # b  (always 32, but why hardcode)

    my $targetSentCount; # number of messags sent by target this round
    while (<>) {
        my ($role, $who);
        unless (($role, $who) = /^([SR]).* \[(.*)\]/) {
            die "Unparseable line '$_'\n";
        }
        my @people = split ",", $who;
        $roundSize = @people;
        if ($role eq "S") {
            $targetSentCount = grep($_ eq $target, @people);
            next; # move on to the receive
        }
        if ($targetSentCount) {  # target sent a message this round
            push @recipientsRoundsTargetSent, \@people;
            push @messagesTargetSentPerRound, $targetSentCount;
        } else { # target sent no message this round
            push @recipientsRoundsTargetNotSent, \@people;
        }
    }

That's relatively straightforward Perl code.  I use ``grep`` to avoid a
loop and store references to arrays, but otherwise there's nothing you don't
find in the first few chapters of any Perl reference.  The only real shame is
the variable ``$targetSentCount`` which has scope outside of the while loop even
though it's never used outside the loop -- it exists only to carry a number
forward from one iteration to the next.

My best impl of the same data extraction in Scala, assisted by the good folks in
#scala on Freenode looks like:

.. code:: scala

 val RawRow = """^([SR]).* \[(.*)\]""".r
 val (targetSent, targetNotSent) = scala.io.Source.fromFile("rounds.txt")
   .getLines
   .map { case RawRow(_,who) => who.split(",").map(nameToIndex).toList }
   .grouped(2)
   .map { case List(send,recv) => (send.count(_ == target), recv) }
   .partition(_._1 > 0)

That's certainly shorter and some would argue more clear.  In the Perl case we
end up with three arrays with the following structures

- ``@recipientsRoundsTargetSent`` - array of array of recipient names
- ``@recipientsRoundsTargetNotSent`` - array of array of recipient names
- ``@messagesTargetSentPerRound`` - array of integers

Whereas in the Scala implementation we have two Lists:

- ``targetSent`` - List of (Int, List of names) Pairs where Count is > 0
- ``targetNotSent`` - List of (Int, List of names) Pairs where Count is 0

Calculating
-----------

The whole of the calculation gets a little long for a blog entry, but here are
two parts of the process shown in each language.  The full implementations are
linked to below (and include more comments).  Here's the portion of the Perl
implementation where we're figuring out the recipient distribution from the
rounds when the target did send a message:

.. code:: perl

  my @probability = ((0) x (&nameToIndex("z9")+1)); # sum of o sub i (before / b)
  my $messagesTargetSentTotal = 0;
  foreach my $index (0 .. $#messagesTargetSentPerRound) {
      my @recipients = @{$recipientsRoundsTargetSent[$index]};
      my $messagesTargetSentThisRound = $messagesTargetSentPerRound[$index];
      $messagesTargetSentTotal += $messagesTargetSentThisRound;
      map {$probability[&nameToIndex($_)] += $messagesTargetSentThisRound}
          @recipients;
  }
  map {$_ /= ($roundSize * @recipientsRoundsTargetSent)} @probability;

That goes though every round where the target sent a message, and for each
possible recipient creates keeps a running total of the number of times they
*could* have been a recipient of a message from the target.  Next that value for
each possible recipient is divided by the number of messages sent per round
(always 32) and by the number of rounds considered, so as to turn it into a
probability.

The same portion of the code in Scala looks like:

.. code:: scala

  val probability = for (a <- targetSent
      .flatMap { case (n,a) => List.fill(n)(a) }
      .flatten
      .groupBy(identity)) yield
    (a._1, 1.0d * a._2.length / 32 / targetSent.length)

That code also goes through every round, counts how many times each person
could have been a recipient of a message from *target* and then turns it into a
probability by dividing by how many messages were sent.  Thanks to Dibblego from
#scala for the flatMap/fill help.

The biggest difference between those two implementations is the use of an
mutable ``@probability`` arry in the Perl code as compared to the completely
immutable List manipulations and resuling ``probability`` Map.

Later on and finally, the various vectors built-up in previous steps get
combined into an approximate probability:

.. math::

  \vec v\approx{}\frac{1}{\overline{m}}\left[{b\cdot{}\overline{O}-\left({b-\overline{m}}\right)\overline{U}}\right]

You'd have to read the paper to map the Perl and Scala variables to their
symbols in the forums, but the Perl code looks like:

.. code:: perl

  my @result = map {
      ($_ * -1 * ($roundSize - $messagesTargetSentPerSendingRoundAvg)
       + ($roundSize * shift @probability))
      / $messagesTargetSentPerSendingRoundAvg } @background;

In Scala that's nearly identical, differing only because in Perl I was
storing using arrays and in Scala I was using Maps to store the interstitial
results.

.. code:: scala

  val result = Range(nameToIndex("a0"), nameToIndex("z9")).toList
    .map(index => (index, (background.getOrElse(index, 0.0)
      * -1.0d * (32.0d - messagesTargetSentPerSendingRoundAvg)
      + (32.0d * probability.getOrElse(index, 0.0)))
      / messagesTargetSentPerSendingRoundAvg))

Output
------

The output is just the almost-probability value for each possible recipient
which again is nearly identical in idiomatic Perl:

.. code:: perl

  my $index = 0;
  map { printf "%03d %s %1.5f\n", ($index,&indexToName($index++), $_) } @result;

and Scala:

.. code:: scala

  for ((i,r) <- result) {
    println("%03d %s %1.5f".format(i, indexToName(i), r))
  }

Observations
------------

For a simple algorithm like this, which is mostly just counting and arithmetic
the code comes out very similar in both Perl and Scala.  Less idiomatic Perl
would have used more looping, which wouldn't align as closely with the Scala,
but when ``map`` is heavily used in both Perl and Scala the code can't help but
look alike.

The data representations in Perl were all arrays of fixed (26 x 10) length and
values were accumulated in increments.  In Scala the same data were stored as
immutable Maps of index to values, which were, of course, assigned only once and
in total.

I'm able to get a sense of the computationally complexity of the Perl code
pretty easily, but not so for the Scala -- which I imagine is a mixture of
inexperience and lack of knowledge about implementation details.

In all honesty, neither is terribly readable, but this was an exercise in
algorithm implementation not software engineering.  It's worth noting that the
results differ slightly, but within what's expected for different floating point
implementations -- both script find that person r0 predominantly sends messages
to person q0.

Both the `Scala script`_ and the `Perl script`_ can be downloaded along with the
input file in a tarball_.

.. _Scala script: http://paste.pocoo.org/show/333148/
.. _Perl script: http://paste.pocoo.org/show/333145/
.. _tarball: https://ry4an.org/unblog/attachments/perl-scala.tar.gz

.. tags: scala,perl,software
