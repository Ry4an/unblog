Kindle Highlights and Ratings
=============================

When reading I've always underlined sentences that make me happy.  Once the kids
got old enough to understand there's no email or fun on a Kindle I switched from
dead tree books, and now the underlining is stored in Amazon's datacenters.

After a few years of highlighting on Kindle I started to wonder if the number of
sentences that made me happy and the eventual five-star rating I gave abook had
any correlation.  Amazon owns Goodreads_ and Kindle services sync data into
Goodreads, but unfortunately highlight data isn't available through any API.

I was able to put together a little Python to scrape the highlight counts per
book (yay, BeautifulSoup_) and combine it with page count and rating info from
the goodreads APIs.  Our `family scientist`_ explained "the statistical tests to
compare values of a continuous variable across levels of an ordinal variable",
and there's no meaningful relationship.  Still it makes a nice picture:

.. attachment-image:: highlight-chart.png
   :width: 591px
   :height: 443px
   :alt: Highlights Per Page vs. Rating

.. _family scientist: https://twitter.com/katewbauer/status/1117580683415834626
.. _Goodreads: https://www.goodreads.com/
.. _BeautifulSoup: https://www.crummy.com/software/BeautifulSoup/

.. read_more

The data_ I pulled only covered books I'd made highlights in, which seems to be
about 2/3rds of them.  I was happy to see that more than 40% of the books I'd
read and highlighted on a kindle were written by women, and better than that
over the last two years.  That probably comes from following good people on
Twitter.

.. _data: https://docs.google.com/spreadsheets/d/1G2Fqs3zYlbWX5EaDTWyGiHnzvI-Jdu1ixMn3dXu0Dm4/edit?usp=sharing

.. tags: ideas-built,software
