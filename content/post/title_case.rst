+++
title = "Ry4an in Title Case"
date = "2019-05-02T15:39:00-0400"
tags = ["funny", "software"]
+++

Ry4an in Title Case
===================

Python has a uniquely bad title case function which turns my already silly name
into Ry4An, capitalizing the 'a' because it follows a non-letter character.
I can't be sure that all the bulk email I get that's sent to Ry4An Brase has
passed through Python's .title() function, but I've not found another language
or framework with so bad an implementation.

At least Python warns you that their version is terrible right in `the docstring
for title`_ and provides a slightly better one they suggest you paste directly
into your code.  There are, of course, better versions available in libraries
like titlecase_ which handle things like not capitalizing articles.

Other languages seem to avoid the fussiness of title case requirements by
omitting it from the core language entirely (ruby, java), leaving it to third
party implementors like rails and apache commons.

.. image:: /unblog/attachments/ry4an-titlecase.png
   :width: 859px
   :height: 156px
   :alt: Four emails with my name in bad titlecase

.. _the docstring for title: https://docs.python.org/3/library/stdtypes.html#str.title
.. _titlecase: https://pypi.org/project/titlecase/

.. tags: software,funny
