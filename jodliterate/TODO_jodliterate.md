
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

2. `<_41l6qomzdfwpfbn864qdrlu5w_>` Color text nouns defined by direct definition forms like:
  ~~~
    text=: {{)n
    all this stuff is
    text make it the same color
    as other texts
    }}
  ~~~

3. `<_73vgsq4u4yw3ammui15cdeazt_>` Investigate why under-bar characters  `_` in JOD group names break LaTeX processing. For now just
   don't use underbar characters in group names.

4. `<_6tjcxi308slh372manqve7a8a_>` Comments without whitespace, e.g. `NB.no space ehh` may not color properly. Use `NB. space please`.

5. `<_b5swcujvdy4wuyvthwk543fcl_>` Syntax coloring of wrapped boxed heterogeneous arrays may not be correct.
   ~~~
      'quoted string' ; (? 20 20$100) ; ;:'quoted strings with numerics'
   ~~~

6. `<_lh1mo16u2ru3im4mv71jowbv_>` Similarly, wrapping nonnouns with long embedded quoted strings may not color properly:
   ~~~
      NB. ISBN-13 checksum
         _80 ]\ disp 'i13cd'
      i13cd=:'098765432109876543210987654321098765432109876543210
      98765432109876543210987654321098765432109876543210987654321098765432109876543210
      98765432109876543210987654321098765432109876543210987654321098765432109876543210
      987654' { ~ 1 3 1 3 1 3 1 3 1 3 1 3 +/ .* '0123456789' i. ]
   ~~~
   NOTE: Long lines are wrapped before going to pandoc. This can lead to pandoc
   assigning inaccurate tokens that cannot be *easily* patched afterwards. Fix
   these infrequent objects with manual LaTeX edits: see `uwlatexfrwords`.

`[end-todo]`
