+++
title = "BoingBoing Posts in Rogue"
date = "2011-03-01T00:55:00-0600"
tags = ["scala", "software", "mongodb", "ideas-built"]
+++


Previously_ I mentioned I was importing the full corpus of BoingBoing_ posts
into MonogoDB, which went off without a hitch.  The import was just to provide a
decent dataset for trying out Rogue_, the Mongo searching DSL from the folks at
Foursquare.  Last weekend I was in New York for the `Northeast Scala
Symposium`_ and the `Foursquare Hackathon`_, so I took the opportunity finish up
the query part while I had their developers around to answer questions.

.. _Previously: https://ry4an.org/unblog/post/boingboing_to_json/
.. _Rogue: https://github.com/foursquare/rogue
.. _BoingBoing: http://boingboing.net
.. _Northeast Scala Symposium: http://www.nescala.org/2011/
.. _Foursquare Hackathon: http://blog.foursquare.com/2011/02/22/stop-hacker-time/

.. read_more

In the end though, there was very little to do.  I just had to define a case
class to represent a Boing Boing post:

.. code:: scala

    class Post extends MongoRecord[Post] with MongoId[Post] {
      def meta = Post
      object comment_count extends LongField(this)
      object venuename extends StringField(this, 255)
      object basename extends StringField(this, 255)
      object author extends StringField(this, 255)
      object title extends StringField(this, 255)
      object body extends StringField(this, 86000)
      object categories extends MongoListField[Post, String](this)
      object created_on extends DateTimeField(this)
    }

and the rest took care of itself.  After a few imports I could query the posts
directly from the Scala repl::

    scala> (Post where (_.author eqs "Cory Doctorow") fetch).length
    res0: Int = 27701

    scala> val z = Post where (_.author eqs "Cory Doctorow") and (_.categories
    contains "History") fetch
    z: List[org.ry4an.boingboingrogue.Post] = ...

    scala> z.map(_.title.toString)
    res1: List[java.lang.String] = List(Bailout costs more than Marshall Plan,
    Louisiana Purchase, moonshot, S&L bailout..

What code there is is up in the `repository at BitBucket`_.  Thanks to
`@jorgeoritz85`_ for on-site help and to the Foursquare folks for a tool that's
as easy to use as it looks.

.. _repository at BitBucket: https://bitbucket.org/Ry4an/boingboing-rogue
.. _@jorgeoritz85: http://twitter.com/#!/jorgeortiz85

.. raw:: html

    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shCore.js"></script>
    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shBrushScala.js/shBrushScala.js"></script>
    <link type="text/css" rel="stylesheet" href="https://ry4an.org/unblog/static/syntaxhighlighter/shCoreDefault.css"/>
    <script type="text/javascript">SyntaxHighlighter.defaults.toolbar=false; SyntaxHighlighter.all();</script>

.. tags: scala,software,mongodb,ideas-built
