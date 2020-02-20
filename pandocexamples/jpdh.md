More J Pandoc Syntax HighLighting
=================================

Syntax highlighting is essential for blogging program code. Many
blog hosts recognize this and provide tools for highlighting 
programming languages. [WordPress.com](https://wordpress.com/) (this host) has
a [nifty highlighting  tool](https://en.support.wordpress.com/wordpress-editor/blocks/syntax-highlighter-code-block/) that 
handles dozens of mainstream programming languages.
Unfortunately, one of my favorite programming languages, [J](www.jsoftware.com), (yes it's a single letter name),
is way out of the mainstream and is not supported.

There are a few ways to deal with this *problem.*

1. Eschew J highlighting.

2. Upgrade[^paymore] your *WordPress.com* subscription and 
   install custom syntax highlighters that can handle arbitrary language definitions. 

3. Find another blog host that freely supports custom highlighters.

4. Roll your own or customize an existing highlighter.

A few years ago I went with the fourth option and hacked the superb open-source tool [pandoc](https://pandoc.org/).
The grim details are described in [this blog post](https://analyzethedatanotthedrivel.org/2012/09/20/pandoc-based-j-syntax-highlighting/).
My hack produced a customized version of pandoc with J highlighting. I still  use my
hacked version and I'd probably stick with it if current pandoc versions had not
introduced *must-have features like converting [Jupyter](https://jupyter.org/) notebooks to Markdown, PDF, LaTeX and HTML.*
Jupyter is my default *thinking-things-through* programming environment. I've even taken to
[blogging with Jupyter notebooks](https://github.com/bakerjd99/smugpyter/blob/master/notebooks/Unified%20XKCD%20Colors.ipynb). If 
you write and explain code you owe it to yourself to give Jupyter a try.

Unwilling to eschew J highlighting or forgo Jupyter I was on the verge of re-hacking
pandoc when I read the current pandoc (version 2.9.1.1) documentation and saw that ***J is now
officially supported by pandoc.*** You can verify this with the shell commands.

~~~~ {.bash}
pandoc --version
pandoc --list-highlight-languages
~~~~

The pandoc developers made my day! I felt like [Wayne meeting a rock star](https://www.youtube.com/watch?v=lBEn3a4TIUw).

Highlighting J is now a simple matter of placing J code in markdown  blocks like:

      ~~~~ { .j }
          ... code code code ...
      ~~~~

and issuing shell commands like:

~~~~ {.bash}
pandoc --highlight-style tango --metadata title="J test" -s jpdh.md -o jpdh.html
~~~~

The previous command generated the HTML of this post which I then pasted into the WordPress.com *Classic Editor.*
Not only do I get J code highlighting on the cheap I also get footnotes which, *for god freaking sakes*,[^footno] 
are not supported by the new block editor for low budget blogs.

***The source markdown used for this post is available here - enjoy!***

~~~~ {.j}

NB. Some J code I am currently using to test TAB
NB. delimited text files before loading them with SSIS.

NB. read TAB delimited table files as symbols - see long document
readtd2s=:[: s:@<;._2&> (9{a.) ,&.>~ [: <;._2 [: (] , ((10{a.)"_ = {:) }. (10{a.)"_) (13{a.) -.~ 1!:1&(]`<@.(32&>@(3!:0)))

tdkeytest=:4 : 0

NB.*tdkeytest v-- test natural key columns  of TAB delimited text
NB. files.
NB.
NB. Many of the raw tables of the ETL process depend on  compound
NB. primary keys. This verb applies a basic  test of primary  key
NB. columns. Passing this test  makes it very  likely  the  table
NB. will load  without key constraint  violations.  Failures  are
NB. still possible depending  on how  text  data is converted  to
NB. other  datatypes. Failure of this test indicates  a very high
NB. chance of key constraint violations.
NB.
NB. dyad:  il =. blclColnames tdkeytest clFile
NB.
NB.   f0=. 'C:\temp\dailytsv\raw_ST_BU.txt'
NB.   k0=. ;:'BuId XMLFileDate'
NB.   k0 tdkeytest f0
NB.
NB.   f1=. 'C:\temp\dailytsv\raw_ST_Item.txt'
NB.   k1=. ;:'BuId ItemId XMLFileDate'
NB.   k1 tdkeytest f1

NB. first row is header
h=. 0{d=. readtd2s y

NB. key column positions
'header key column(s) missing' assert -.(#h) e. p=. h i. s: x

c=. #d=. }. d
b=. ~:p {"1 d

NB. columns unique, rowcnt, nonunique rowcnt
if. r=. c = +/b do.
  r , c , 0
else.
  NB. there are duplicates show some sorted duplicate keys
  k=. p {"1 d
  d=. d {~ I. k e. k #~ -.b
  d=. (/: p {"1 d) { d
  b=. ~:p {"1 d
  m=. +/b
  smoutput (":m),' duplicate key blocks'
  n=. DUPSHOW <. m
  smoutput 'first ',(":n),' duplicate row key blocks'
  smoutput (<p { h) ,&.> n {. ,. b <;.1 p {"1 d
  r , c , #d
end.
)
~~~~


[^paymore]: The pay more option is always available.

[^footno]: WordPress.com is beginning to remind me of Adobe. Stop taking
           away longstanding features when upgrading!