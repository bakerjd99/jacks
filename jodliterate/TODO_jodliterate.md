
![](inclusions/jodliteratelionlittle.png)`jodliterate` TODO
==========================================================

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

2. `<_25mbz8vnu3mx3i55ox97flbuf_>` Consider improving line break markers - match what Jupyter does when breaking code lines.

3. `<_4ctj1kp0o2mh4lhrpx231esg9_>` Line breaking character lists are not colored. Consider improving.

4. `<_aecwwj3odj2v8xxoktw6vlj25_>` 0 : 0 literal text is not colored , e.g.
    ```J
    0 : 0
    this is literal text but
    it is not literally colored
    consider improving
    )
    ```

`[end-todo]`