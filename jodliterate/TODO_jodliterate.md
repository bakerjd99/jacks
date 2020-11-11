
![jodliteratelion](inclusions/jodliteratelionlittle.png)`jodliterate` TODO
==========================================================================

Pending and considered changes for `jodliterate`.

`jodliterate` is a [J/JOD](https://analyzethedatanotthedrivel.org/the-jod-page/) class group that provides
[literate programming](http://literateprogramming.com/index.html) support
for J code stored in JOD dictionaries.

This document tracks pending and considered changes for `jodliterate`.
The base 36 case insensitive GUID key is stable over the lifetime of a task. It uniquely
labels each task and makes it possible compile detailed change histories
by trolling over the version history of this file.

`[begin-todo]`

1. `<_5y5lb5gvigvz7xvtv2b0u3003_>` Revise and test for direct definition. J 9.02 introduced direct definitions
   that are delimited by `{{` `}}`. The digraphs are an exception to J's
   inflection scheme and will ripple through all J code parsing tools including
   `jodliterate`.

2. `<_73vgsq4u4yw3ammui15cdeazt_>` Investigate why underbar characters  `_` in JOD group names break LaTeX processing. For now just
   don't use underbar characters in group names.

3. `<_25mbz8vnu3mx3i55ox97flbuf_>` Consider improving line break markers - match what Jupyter does when breaking code lines.

4. `<_3cr9eik0lqvj2zqaq6kiywsmm_>` Adjacent wrapped quoted strings and comments may not color properly. Inserting a blank line
   between such lines fixes the coloring for now.

`[end-todo]`
