+++
title = "A Gamebook Report with Graphviz, Google Sheets, Python, and Juypter/Colab"
date = "2020-05-02T16:53:00-0400"
tags = ["software", "python", "ideas-built"]
+++


An 11 year old in our house needed to do a book report for school in the form of
a board game and selected a gamebook, apparently the generic name for the
trademarked Choose Your Own Adventure books.  The non-linear narrative made the
choice of board layout easy -- just use the graph of pages-transitions ("Turn to
page 110").

The graphviz_ library is always my first choice when I want to visualize nodes
and edges, and the `python graphviz module`_ provides a convenient way to get
data into a renderable graph structure.

I wanted to work with the 11 year old as much as possible, so I picked
a programming environment that can be used anywhere, jupyter_ notebooks, and we
ran it in Google's free hosted version called colab_.

The data entry was going to be the most time consuming part of the project, and
something we wanted to be able to work on both together and apart.  For that
I picked a Google sheet.  It gave us the right mix of ease of entry,
remote collaboration, and a familiar interface.  Python can read from Google
sheets directly using the gspread_ module, saving a transcription/import step.

It took us a few weeks of evenings to enter the book's info into the `data
spreadsheet`_.  The two types of data we needed were places, essentially nodes,
and decisions, which are edges.  For every place we recorded starting page,
a description of what happens, and the page where you next make a decision or
reach an ending.  For every decision we recorded the page where you were
deciding, a description of the choice, and the page to which you'd go next.  As
you can see in the `data spreadsheet`_ that was 139 places/nodes and 177
decisions/edges.

Once we'd entered all the data we were able to run a `short python program`_ to
load the data from the spreadsheet, transform it into a graph object, and then
render that `graph as a pdf file`_.  That we printed with a large format
printer, and then the 11 year old layered on art, puzzles, rules, and everything
else that turns a digraph into a playable game.  The final game board is shown
below, with a zoomed section in the album_.

One interesting thing about this particular book that was only evident once the
full graph was in front of us was that the very first choice in the book splits
you into one of two trees that never reconnect.  Lots of later choices in the
book loop back and cross over, but that first choice splits you into one of two
separate books.

I've omitted the title and author info from the book to stop this giant spoiler
from showing up on google searches, but the 11 year old assures me it was
a good, fun read and recommends it.

.. image:: /unblog/attachments/gameboard.jpg
   :width: 806px
   :height: 604px
   :alt: hand decorated graph gameboard

.. _graphviz: https://www.graphviz.org/
.. _python graphviz module: https://pypi.org/project/graphviz/
.. _jupyter: https://jupyter.org/
.. _colab: https://colab.research.google.com/
.. _gspread: https://pypi.org/project/gspread/
.. _data spreadsheet: https://docs.google.com/spreadsheets/d/1PW1NVIpVhXvdGsKQ4qgGc6s4h8F_1IIJ9br3dGNKrVg/edit
.. _short python program: https://colab.research.google.com/drive/1S_wQ7yXjPBrDRcFcH56POWNKqAmXxZUs
.. _graph as a pdf file: https://drive.google.com/file/d/1K3QxtjUIV8QGF_lixBvxqzoNZgao144u/view
.. _album: https://photos.app.goo.gl/TiuwGdYdAcfpMAhh6

.. tags: ideas-built,software,python
