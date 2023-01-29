![WP to latex logo](wp2latexlogo.png)`TeXfrWpxml` TODO
======================================================

Pending and considered changes for `TeXfrWpxml`.

`TeXfrWpxml` is a [J/JOD](https://analyzethedatanotthedrivel.org/the-jod-page/) class group that
converts WordPress.com export XML to LaTeX and Markdown. See the following for more information:

* https://analyzethedatanotthedrivel.org/2012/02/11/wordpress-to-latex-with-pandoc-and-j-prerequisites-part-1/
* https://github.com/bakerjd99/jacks/tree/master/texfrwpxml
* https://github.com/bakerjd99/jacks/blob/master/texfrwpxml/wordpresstolatexwith2374.pdf

This document tracks pending and considered changes for `TeXfrWpxml`.
The base 36 case insensitive GUID key is stable over the lifetime of a task. It uniquely
labels each task and makes it possible compile detailed change histories
by trolling over the version history of this file.

`[begin-todo]`

1. `<_a7oj485zhjesdbgecyjvtfqvc_>` Add verb to `TeXfrWpxml.ijs` to insert yearly post count in `bm.tex`.

2. `<_1d2ynsw2ozr7a2llcbs824opu_>` Changes to WordPress's *block editor* have invalidated some of
   the assumptions in the code of `TeXfrWpxml`. In particular it no longer
   extracts source code blocks reliably. Update for the block editor.

3. `<_33xb34nbtb2xqf46lit3e6oaq_>` Test graphics downloading. Graphics
   downloading fails to fetch WordPress.com images see `WGETCMD`.

4. `<_e5puo4u676b0tn461z945jm7o_>` Consider swapping `curl` for `wget`.

`[end-todo]`