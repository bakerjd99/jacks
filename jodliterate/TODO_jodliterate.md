
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

1. `<_b9g7eajovtfz49saualwur8ym_>` Generalize `setifacetargs` to set hyperlink targets for lists of hint words. Hint words will
   come from JOD group associated lists like `IFACEWORDS*` and `ROOTWORDS*`. The idea is to point
   out words in long source code listings that require special attention. Such hinted words will
   appear in blocks like:
   ~~~~
      AlbumImageCount_sql    CreateMirror_sql       LocalFile_sql
      UnClickHereImages_sql  UpdateLocalPresent_sql UploadRateCount_sql
   ~~~~

2. `<_2r3hv91c891s7n1qqjajqdqak_>` Consider allowing original word order for `wordlit`. Currently the words
   are sorted by JODs `wttext` conventions.

3. `<_73vgsq4u4yw3ammui15cdeazt_>` Investigate why underbar characters  `_` in JOD group names break LaTeX processing. For now just
   don't use underbar characters in group names.

4. `<_6tjcxi308slh372manqve7a8a_>` Comments without whitespace, e.g. `NB.no space ehh` may not color properly. User `NB. space please`.

5. `<_b5swcujvdy4wuyvthwk543fcl_>` Syntax coloring of wrapped boxed heterogenous arrays may not be correct.
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
