NB.*RescaleHilbertGraphics s-- replaces fixed width \includegraphics with relative widths.
NB.
NB. verbatim:
NB.
NB. http://bakerjd99.wordpress.com/2011/07/12/open-source-hilbert-for-the-kindle/
NB. http://www.gutenberg.org/ebooks/17384
NB.                                                                                     
NB. author:  John Baker 
NB. created: 2013dec20
NB. ------------------------------------------------------------------------------ 
NB. 13dec20 saved in (jacks) GitHub repo
NB.*end-header

NB. dimensions of letter paper page in TeX points
SourcePageTeXPts=:426.39256 607.06754999999998

NB. TeX points per inch
TeXPtIn=:72.269999999999996


RescaleHilbertGraphics=:3 : 0

NB.*RescaleHilbertGraphics   v--   replaces   all   fixed   width
NB. \includegraphics dimensions with relative widths.
NB.
NB. This  verb  replaces  all the  fixed  width  \includegraphics
NB. commands in the LaTeX source  of David Hilbert's  Foundations
NB. of Geometry with  relative \textwidth  based  commands.  This
NB. transformation  makes  it  possible   to  generate  a  Kindle
NB. oriented PDF of this famous little book.
NB.
NB. The LaTeX  source of an English translation of Hilbert's book
NB. is  available   at  the  Project  Gutenberg   web   site  at:
NB. http://www.gutenberg.org/ebooks/17384
NB.
NB. monad:  cl =. RescaleHilbertGraphics clTex

NB. extract unique list of graphics dimensions
uw=. graphdims y

NB. insure all dimensions are width=W.Din units
wid=. 'width=' [ msg =. 'graphics dimensions invalid'
msg assert wid -:"1 (#wid)&{. &> uw
msg assert 'in' -:"1 (-#'in')&{. &> uw

NB. inch character units to numeric
msg assert 0 < udin =. _1&".&> uw #&.>~ uw e.&.> <'.0123456789'

NB. rounded page fractions assuming standard letterpaper page
NB. the actual text area will vary depending depending
NB. on a host of style and over page settings.
pgfr=. 0.0001 round udin % (0{SourcePageTeXPts) % TeXPtIn

NB. make width= replacements
nwid=. uw ,. (<wid) ,&.> (":&.> <"0 pgfr) ,&.> <'\textwidth'
msg assert -.'#' e. ; ,nwid
(;,'#',&.>nwid) changestr y
)

NB. retains string after first occurrence of (x)
afterstr=:] }.~ #@[ + 1&(i.~)@([ E. ])

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))

NB. retains string before first occurrence of (x)
beforestr=:] {.~ 1&(i.~)@([ E. ])


changestr=:4 : 0

NB.*changestr v-- replaces substrings - see long documentation.
NB.
NB. dyad:  clReps changestr cl
NB.
NB.   NB. first character delimits replacements
NB.   '/change/becomes/me/ehh' changestr 'blah blah ...'

pairs=. 2 {."(1) _2 [\ <;._1 x      NB. change table
cnt=._1 [ lim=. # pairs
while. lim > cnt=.>:cnt do.         NB. process each change pair
  't c'=. cnt { pairs               NB. /target/change
  if. +./b=. t E. y do.             NB. next if no target
    r=. I. b                        NB. target starts
    'l q'=. #&> cnt { pairs         NB. lengths
    p=. r + 0,+/\(<:# r)$ d=. q - l NB. change starts
    s=. * d                         NB. reduce < and > to =
    if. s = _1 do.
      b=. 1 #~ # b
      b=. ((l * # r)$ 1 0 #~ q,l-q) (,r +/ i. l)} b
      y=. b # y
      if. q = 0 do. continue. end.  NB. next for deletions
    elseif. s = 1 do.
      y=. y #~ >: d r} b            NB. first target char replicated
    end.
    y=.(c $~ q *# r) (,p +/i. q)} y  NB. insert replacements
  end.
end. y                              NB. altered string
)

NB. extract unique list of graphics dimensions from latex
graphdims=:[: ~. [: '['&afterstr@:(']'&beforestr)&.> ] <;.1~ '\includegraphics' E. ]

NB. round y to nearest x (e.g. 1000 round 12345)
round=:[ * [: <. 0.5 + %~