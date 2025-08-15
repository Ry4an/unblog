+++
title = "Bitcoin Conversion In Google Spreadsheets"
date = "2013-11-11T23:00:00-0500"
tags = ["software", "ideas-built"]
+++

Bitcoin Conversion In Google Spreadsheets
=========================================

I've been using `Charlie Lee`_'s excellent `Google Spreadsheet Bitcoin`_ tracker
sheet for awhile but it pulls data from a single exchange at a time and relies
on the ordering of those exchanges on the bitcoinwatch.com site, which vary with
volume.

I figured out I could get better numbers more reliably from bitcoinaverage.com_,
which (predictably) averages multiple exchanges over various time periods.  They
offer a great JSON API, but unfortunately Google spreadsheets only export JSON
-- they don't have a function for importing it.

None the less I was able to fake it using a regex.  You can pull the 24 hour
average price in with this forumla::

    =regexextract(index(importdata("https://api.bitcoinaverage.com/ticker/USD"),2,1), ": (.*),")+0

If you want that to update live (not just when you open the spreadsheet) you
need to use Charlie's hack to get the sheet to think the formula depends on live
stock data::

    =regexextract(index(importdata("https://api.bitcoinaverage.com/ticker/USD?workaround="&INT(
        NOW()*1E3)&REPT(GoogleFinance("GOOG");0)),2,1), ": (.*),")+0

I've put together a `sample spreadsheet`_ based on Charlie's.

.. _Charlie Lee: https://plus.google.com/u/0/108380884935330936839/about
.. _Google Spreadsheet Bitcoin: https://spreadsheets.google.com/spreadsheet/ccc?key=0Amu2Hoiel5SYdFJMVV95cG5pbFppSHc4YnVwUzZwanc&hl=en_US&authkey=CIa_g-AM
.. _bitcoinaverage.com: http://bitcoinaverage.com
.. _sample spreadsheet: https://docs.google.com/spreadsheet/ccc?key=0Al9QwmOcaI8fdGNNdzgzaGRYUnVtdkpmUmJJTkthZXc&usp=sharing


.. tags: ideas-built,software
