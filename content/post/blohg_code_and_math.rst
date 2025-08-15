+++
title = "Syntax Highlighting and Formulas for Blohg"
date = "2011-02-05T01:51:00-0600"
tags = ["meta", "software", "python", "ideas-built"]
+++

Syntax Highlighting and Formulas for Blohg
==========================================

I'm thus far thrilled with blohg_ as a blogging platform.  I've got a large post
I'm finishing up now with quite a few snippets of source code in two different
programming languages.  I was hoping to use the excellent SyntaxHighlighter_
javascript library to prettify those snippets, and was surprised to find that
docutils reStructuredText doesn't yet do that (though some other implementations
do).

Fortunately, adding new rendering directives to reStructuredText is incredibly
easy.  I was able to add support for a ``.. code`` mode with just this little
bit of Python:

.. _blohg: http://hg.rafaelmartins.eng.br/blohg/
.. _SyntaxHighlighter: http://alexgorbatchev.com/SyntaxHighlighter/

.. read_more

.. code:: python

    class Code(Directive):
        
        required_arguments = 1
        optional_arguments = 0
        has_content = True

        def run(self):
            self.options['brush'] = self.arguments[0]
            html = '''\

    <pre class="brush: %s">
    %s
    </pre>
    '''
            return [nodes.raw('', html % (self.options['brush'],
                "\n".join(self.content).replace('<', '&lt;')),
                format='html')]

In a non-javascript environment (like your RSS reader) that should look like a
standard <pre> tag, but at ry4an.org it should be colorful and tricked out.

I also wanted a good way to render mathematical formula's and saw that `Rafael
Martins`_ had already included one in blohg.  It, however, used a private
(defunct?) mimetex_ server.  Recalling Google provides a `formula API`_ I was
able to cut over to that, allowing for turning things like this::

  .. math::

     x = \frac{-b \pm \sqrt {b^2-4ac}}{2a}

into this:

.. math::

  x = \frac{-b \pm \sqrt {b^2-4ac}}{2a}

Neither of those are at all earth shattering, but maybe I'll be able to get
Rafael to pull them anyway.  Meanwhile they should merge cleanly into the blohg.


- 162ee0d101e7_ - Add ``.. code`` code for syntax highlighting
- 34726b209d67_ - Point ``.. math`` directive at Google Charts API

.. _mimetex: http://www.forkosh.dreamhost.com/source_mimetex.html
.. _formula api: http://code.google.com/apis/chart/docs/gallery/formulas.html
.. _Rafael Martins: http://blog.rafaelmartins.org/
.. _162ee0d101e7: https://ry4an.org/hg/blohg/rev/162ee0d101e7
.. _34726b209d67: https://ry4an.org/hg/blohg/rev/34726b209d67

.. raw:: html

    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shCore.js"></script>
    <script type="text/javascript" src="https://ry4an.org/unblog/static/syntaxhighlighter/shBrushPython.js"></script>
    <link type="text/css" rel="stylesheet" href="https://ry4an.org/unblog/static/syntaxhighlighter/shCoreDefault.css"/>
    <script type="text/javascript">SyntaxHighlighter.defaults.toolbar=false; SyntaxHighlighter.all();</script>

.. tags: python,ideas-built,software,meta
