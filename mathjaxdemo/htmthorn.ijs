NB.*htmthorn s--  j array formatting (thorn) that generates
NB. HTML.
NB.
NB. This elegant script by Roger Hui implements a model  of the j
NB. array formatting primitive  thorn (":)  that  generates  HTML
NB. output. See the J wiki:
NB.
NB. verbatim:
NB.
NB.   http://www.jsoftware.com/jwiki/Essays/Boxed%20Array%20Display
NB.
NB. examples:
NB.
NB.   thh i.2 2 3 4
NB.   thh <"0 i.2 2 3 4
NB.   thh 5!:2 <'assert'
NB.   thh 2 3 4 $ i.&.> i.7
NB.   thh 2 2 3 $ (i.&.>i.6),<<2 5$'a   efghij'
NB.
NB. interface word(s):
NB. ------------------------------------------------------------------------------
NB.   thh - j array format in HTML
NB.
NB. author:  Roger Hui
NB. created: 2010Mar31
NB. ------------------------------------------------------------------------------

coclass 'htmthorn'

boxed  =: 32 = 3!:0
mt     =: 0 e. $
boxc   =: 9!:6 ''
tcorn  =: 2  0{boxc
tint   =: 1 10{boxc
bcorn  =: 8  6{boxc
bint   =: 7 10{boxc

sh     =: (*/@}: , {:)@(1&,)@$ ($,) ]
rows   =: */\.@}:@$
bl     =: }.@(,&0)@(+/)@(0&=)@(|/ i.@{.@(,&1))
mask   =: 1&,. #&, ,.&0@>:@i.@#
mat    =: mask@bl@rows { ' ' , sh

edge   =: ,@(1&,.)@[ }.@# +:@#@[ $ ]
left   =: edge&(3 9{boxc)@>@(0&{)@[ , "0 1"2 ]
right  =: edge&(5 9{boxc)@>@(0&{)@[ ,~"0 1"2 ]
top    =: 1&|.@(tcorn&,)@(edge&tint)@>@(1&{)@[ ,"2  ]
bot    =: 1&|.@(bcorn&,)@(edge&bint)@>@(1&{)@[ ,"2~ ]
perim  =: [ top [ bot [ left right

topleft=: (4{boxc)&((<0 0)}) @ ((_2{boxc)&,.) @ ((_1{boxc)&,)
inside =: 1 1&}. @: ; @: (,.&.>/"1) @: (topleft&.>)
take   =: {. ' '"_^:mt
frame  =: [ perim {@[ inside@:(take&.>)"2 ,:^:(1=#@$)@]
rc     =: (>./@sh&.>) @: (,.@|:"2@:(0&{"1);1&{"1) @: ($&>)

thorn1 =: ":`thbox @. boxed
thbox  =: (rc frame ]) @: (mat@thorn1&.>)

thboxcheck=: 3 : 0
 z=. thbox y
 assert. (#$z) = 2 >. #$y
 assert. z -:&(_2&}.)&$ y
 t=. (<0$~_2+#$z){z
 p=. ({."1 t) e. 0 3 6{boxc
 q=. ({.   t) e. 0 1 2{boxc
 assert. z -:&((,p+./q)#,)"2 t
 z
)

nbsp    =: [: ; ((<'&nbsp;') 32}<"0 a.) {~ a. i. ]  NB. replace space by &nbsp;
pad     =: '<br>' $~ 4 * *@[ * -

BOXCHARS=: 9!:6 ''     NB. box drawing characters
SPACER  =: '<tr class=spacer><td>&nbsp;</td></tr>',CRLF

JARRAYSTYLE=: 0 : 0
<style type="text/css">
.jarray {font-family:monospace;}
table.jarray {border-collapse:collapse;}
table.jarray td {border:solid black thin; vertical-align:top; padding:0.4em;}
table.jarray tr.spacer td {border:none;}
</style>
)

thh=: 3 : 0  NB. "thorn" (array formatting) producing HTML output
 JARRAYSTYLE,'<div class=jarray>',(0 thh y),'</div>'
:
 if. (0 e. $y) >: 32=3!:0 y do.                 NB. y is empty or not boxed
  nbsp _4}.(,z),x pad #z=. (mat ":y),"1 '<br>'
 else.                                          NB. y is boxed
  s=. {."1 (_2{.$t) ($,) t=. ":y                NB. s is 1st column in 1st plane in ":y
  h=. <: 2 -~/\ I. s e. 0 3 6{BOXCHARS          NB. height (# lines) in each row
  z=. h thh&.>"2 ,:^:(0>.2-#$y) y               NB. format each atom
  z=. ('<td>','</td>',~])&.> z                  NB. bracket each atom
  z=. <@('<tr>','</tr>',~;)"1 z                 NB. bracket each row
  '<table class=jarray>',(;(mask bl rows y){SPACER;,z),'</table>',(_4}.x pad #mat t),CRLF
 end.
)
NB.*end-header

NB. interface words (IFACEWORDShtmthorn) group
IFACEWORDShtmthorn=:,<'thh'

NB. root words (ROOTWORDShtmthorn) group      
ROOTWORDShtmthorn=:<;._1 ' ROOTWORDShtmthorn IFACEWORDShtmthorn'

NB.POST_htmthorn post processor.

smoutput 0 : 0
NB. interface word(s):
NB.   thh  NB. j array format in HTML
)

cocurrent 'base'
coinsert  'htmthorn'