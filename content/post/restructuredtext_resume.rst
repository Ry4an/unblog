reStructuredText Resume
=======================

I've had a resume in active maintenance since the mid 90s, and it's gone through
many iterations.  I started with a Word document (I didn't know any better).  In
the late 90s I moved to parallel Word, text, and HTML versions, all maintained
separately, which drifted out of sync horribly.  In 2010 I redid it in Google
Docs using a template I found whose HTML hinted at a previous life in Word for
OS X.  That template had all sorts of class and style stuff in it that Google
Docs couldn't actually edit/create, so I was back to hand-editing HTML and then
using Google Docs to create a PDF version.  I still had to keep the text version
current separately, but at least I'd decided I didn't want any job that wanted a
Word version.

When I decided to finally add my current job to my resume, even months after
starting, I went for another overhaul.  The goal was to have a single input file
whose output provided HTML, text, and PDF representations.  As I saw it that
made the options: LaTeX_, reStructuredText_, or HTML.

.. _LaTeX: http://en.wikipedia.org/wiki/LaTeX
.. _reStructuredText: http://docutils.sourceforge.net/rst.html

I started down the road with LaTeX, and found some_ great_ templates_,
articles_, and_ prior_ examples_, but it felt like I was fighting with the tool
to get acceptable output, and nothing was coming together on the plain text
renderer front.

.. _some: http://rpi.edu/dept/arc/training/latex/resumes/
.. _great: http://www.mcnabbs.org/andrew/linux/latexres/
.. _templates: https://bitbucket.org/duplico/tucv/overview
.. _articles: http://www.thelinuxdaily.com/2008/10/latex-resume-examples/
.. _and: http://www.davidgrant.ca/latex_resume_template
.. _prior: http://www.yisongyue.com/resume/
.. _examples: http://matthewm.boedicker.org/doc/resume/

Next I turned to reStructuredText, and found it yielded a workable system.  I
started with `Guillaume ChéreAu's blog post`_ and template and used the regular
docutils_ tool rst2html_ to generate the HTML versions.  The normal route for
turning reStructuredText into PDF using doctools passes through LaTeX, but I
didn't want to go that route, so I used rst2pdf_, which gets there directrly.  I
counted the reStructuredText version as close-enough to text for that format.

.. _Guillaume ChéreAu's blog post: http://charlie137-2.blogspot.com/2010/02/writing-resume-using-restructuredtext.html
.. _docutils: http://docutils.sourceforge.net/
.. _rst2html: http://docutils.sourceforge.net/docs/user/tools.html#rst2html-py
.. _rst2pdf: http://code.google.com/p/rst2pdf/

Since now I was dealing entirely with a source file that compiled to generated
outputs it only made sense to use a Makefile_ and keep everything in a
`Mercurial repository`_.  That gives me the ability to easily track changes and
to merge across multiple version (different objectives) should the need arise.
Since I've always used a source control repository for the HTML version it's
possible to compare revisions back to 2001, which get pretty silly.

.. _Makefile: http://ry4an.org/hg/resume/file/tip/Makefile
.. _Mercurial repository: http://ry4an.org/hg/resume/

I'm also proud to say that the URL for my resume hasn't changed since 1996, so
any printed version ever includes a link to the most current one.  Here are
links to each of those formats: HTML_, PDF_, text_, and repository_, where the
text version is the one from which the others are created.

.. _text: http://ry4an.org/resume/resume.txt
.. _HTML: http://ry4an.org/resume/resume.html
.. _PDF: http://ry4an.org/resume/resume.pdf
.. _repository: http://ry4an.org/hg/resume/

.. tags: ideas-built,software
