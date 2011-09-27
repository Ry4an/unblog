Asynchronous Python Logging
===========================

The Python logging module has some nice built-in LogHandlers that do network IO,
but I couldn't square with having HTTP POSTs and SMTP sends in web response
threads.  I didn't find an asynchronous logging wrapper, so I wrote a decorator
of sorts using the really nifty monkey patching availble in python:

.. code:: python

    def patchAsyncEmit(handler):
        base_emit = handler.emit
        queue = Queue.Queue()   
        def loop():
            while True:
                record = queue.get(True) # blocks
                try :
                    base_emit(record)
                except: # not much you can do when your logger is broken
                    print sys.exc_info(
        thread = threading.Thread(target=loop)
        thread.daemon = True
        thread.start(
        def asyncEmit(record):
            queue.put(record)
        handler.emit = asyncEmit
        return handler

In a more traditional OO language I'd do that with extension or a dynamic proxy,
and in Scala I'd do it as a trait, but this saved me having to write delegates
for all the other methods in LogHandler.

Did I miss this in the standard logging stuff, does everyone roll their own, or
is everyone else okay doing remote logging in a web thread?

.. raw:: html

    <script type="text/javascript" src="http://ry4an.org/unblog/static/syntaxhighlighter/shCore.js"></script>
    <script type="text/javascript" src="http://ry4an.org/unblog/static/syntaxhighlighter/shBrushPython.js"></script>
    <link type="text/css" rel="stylesheet" href="http://ry4an.org/unblog/static/syntaxhighlighter/shCoreDefault.css"/>
    <script type="text/javascript">SyntaxHighlighter.defaults.toolbar=false; SyntaxHighlighter.all();</script>

.. tags: python,ideas-built,software
