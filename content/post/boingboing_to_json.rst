+++
title = "Loading BoingBoing into MongoDB with Scala"
date = "2011-02-15T00:54:00-0600"
tags = ["scala", "software", "mongodb", "ideas-built"]
+++


I want to play around with Rogue_ by the Foursquare folks, but first I needed a
decent sized collections of items in a MongoDB_.  I recalled that BoingBoing_
had just released `all their posts in a single file`_, so I downloaded that and
put together a little Scala to convert from XML to JSON_.  The built-in XML
support in Scala and the excellent lift-json_ DSL turned the whole thing into no
work at all:

.. _Rogue: http://engineering.foursquare.com/2011/01/21/rogue-a-type-safe-scala-dsl-for-querying-mongodb/
.. _MongoDB: http://www.mongodb.org/
.. _BoingBoing: http://boingboing.net
.. _all their posts in a single file: http://www.boingboing.net/2011/01/25/eleven-years-worth-o.html
.. _JSON: http://www.json.org/
.. _lift-json: https://github.com/lift/lift/tree/master/framework/lift-base/lift-json/

.. read_more

.. code:: scala

  val dateFmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
  val xml = scala.xml.XML.loadFile("/home/ry4an/bbpostsdump.xml")
  for (postXml <- (xml \ "row")) {
    val created_on = dateFmt.parse((postXml \ "created_on").text).getTime
    val body_more = (postXml \ "body_more").text.trim match {
      case "NULL" => ""
      case something => " " + something
    }
    val postJson =
      ("_id" -> (postXml \ "permalink").text) ~
      ("basename" -> (postXml \ "basename").text) ~
      ("author" -> (postXml \ "author").text) ~
      ("title" -> (postXml \ "title").text) ~
      ("comment_count" -> (postXml \ "comment_count").text) ~
      ("categories" -> (postXml \ "categories").text.split(',')
        .toList.filterNot(_ == "NULL")) ~
      ("body" -> ((postXml \ "body").text + body_more)) ~
      ("created_on" -> ("$date" -> created_on))
    println(compact(JsonAST.render(postJson)))
  }

Certainly nothing earth shattering, but pleasantly readable and certainly quick.
In the real world you'd want to use the scala.xml.pull_ package to avoid
pulling all the XML into memory, but all eleven years fit in a gig of ram.  The
output lines loaded up directly with ``mongoimport``.

All in all it took an evening, including spinning up a micro instance at Amazon
EC2 to host the DB and provide tomcat for the next steps.  The code, along with
the sbt_ project can be found in a `repository at BitBucket`_.  Next: Rogue.

.. _scala.xml.pull: http://www.scala-lang.org/api/current/scala/xml/pull/package.html
.. _sbt: http://code.google.com/p/simple-build-tool/
.. _repository at BitBucket: https://bitbucket.org/Ry4an/boingboing-json-mongo

.. raw:: html

    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shCore.js"></script>
    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shBrushScala.js"></script>
    <link type="text/css" rel="stylesheet" href="https://ry4an.org/unblog/static/syntaxhighlighter/shCoreDefault.css"/>
    <script type="text/javascript">SyntaxHighlighter.defaults.toolbar=false; SyntaxHighlighter.all();</script>

.. tags: scala,software,mongodb,ideas-built
