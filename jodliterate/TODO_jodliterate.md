
![jod literate lion](inclusions/jodliteratelionlittle.png)`jodliterate` TODO
============================================================================

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

4. `<_b5swcujvdy4wuyvthwk543fcl_>` Syntax coloring of wrapped boxed heterogenous arrays may not be correct.
   ~~~
      'quoted string' ; (? 20 20$100) ; ;:'quoted strings with numerics'
   ~~~

5. `<_lh1mo16u2ru3im4mv71jowbv_>` Similarly, wrapping nonnouns with long embedded quoted strings may not color properly:
   ~~~
      NB. ISBN-13 checksum
         _80 ]\ disp 'i13cd'
      i13cd=:'098765432109876543210987654321098765432109876543210
      98765432109876543210987654321098765432109876543210987654321098765432109876543210
      98765432109876543210987654321098765432109876543210987654321098765432109876543210
      987654' { ~ 1 3 1 3 1 3 1 3 1 3 1 3 +/ .* '0123456789' i. ]
   ~~~
   NOTE: Fixing wrapped nonstring forms with wrapped embedded strings requires a more
   general patch algorithm. Two approaches scan the starts and ends of strings in the form
   and adjust/insert string tokens or give up and color the entire block something else.
   NOTE MORE: Long lines are wrapped before going to pandoc. This can lead to pandoc
   assigning inaccurate tokens that cannot be patched afterwards. Sending such
   lines directly to pandoc gets proper tokens but then would require wrapping
   without breaking the tokens.

`[end-todo]`
