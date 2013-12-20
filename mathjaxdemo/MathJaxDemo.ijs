NB.*MathJaxDemo s-- use MathJax with JHS.
NB. 
NB. This script shows how to use [MathJax](http://www.mathjax.org/) with
NB. JHS. To run this demo do:
NB.
NB. verbatim:
NB.
NB.  1. Place all the demo files in a directory then edit J's (~config/folders.cfg)
NB.     and point to this directory. (jpath '~MathJaxDemo') must return the directory. 
NB.
NB.  2. Copy (startup_mathjaxdemo_jhs.ijs) to (~config) and rename it to (startup_jhs.ijs)
NB.
NB.  3. Restart JHS and browse to: http://127.0.0.1:65001/MathJaxDemo
NB.
NB. for more details see:
NB.
NB. http://bakerjd99.wordpress.com/2012/11/25/jhs-meets-mathjax/
NB.                 
NB. author:  John Baker (bakerjd99@gmail.com)  
NB. created: 2012nov24
NB. ------------------------------------------------------------------------------
NB. 13dec20 added to (jacks) GitHub repository


NB. format J arrays as HTML tables
require '~MathJaxDemo/htmthorn.ijs'

coclass  'MathJaxDemo'
coinsert 'jhs'


NB.*dependents

NB. distinguish scopes of MathJaxDemo & JHS words
NB. override (*)=: HBS CSSCORE CSS JS hrtemplate configjax tabledesc
NB.          (*)=: MAXWELLEQTEX QUADRATICSOLTEX RAMANUJANTEX CROSSPRODUCTTEX

NB. context  (*)=. jpath jhrajax jhr djaxmath tmjx

NB. location of MathJaxDemo files
PATHPREFIX=: jpath '~MathJaxDemo/'

NB. browser get request
jev_get=: create 

NB. create page and send to browser
create=: 3 : 0
'MathJaxDemo'jhr''
)


NB. J event handlers
ev_ttable_click=:  3 : 0
tex=.QUADRATICSOLTEX;MAXWELLEQTEX;RAMANUJANTEX;CROSSPRODUCTTEX 
jhrajax tmjx (1 1 >. ?5 5)$djaxmath&.> tex
)

ev_tquad_click=: 3 : 0
jhrajax tmjx ,. <djaxmath QUADRATICSOLTEX
)

ev_tmaxwell_click=: 3 : 0
jhrajax tmjx ,. <djaxmath MAXWELLEQTEX
)

ev_tramaujan_click=: 3 : 0
jhrajax tmjx ,. <djaxmath RAMANUJANTEX
)

ev_tcrossprod_click=: 3 : 0
jhrajax tmjx ,. <djaxmath CROSSPRODUCTTEX
)

ev_treset_click=: 3 : 'jhrajax '''''

NB.*enddependents


NB. css, html and javascript code do not apply J code compression (-.)=:

HBS=: 0 : 0

navul''

'<hr>','treset' jhb 'Reset'

'<hr>',jhh1 'Typeset with MathJax and J'
configjax
oltypeset''

'<hr>',jhh1 'Typeset Random Expression Tables'
tabledesc
'<br/>','ttable' jhb'Typeset Random Expression Array' 
'<br/>','restable' jhspan''                   
)


NB. redefine template for HTML5 - use MathJax favicon 
hrtemplate=: 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Connection: close

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><TITLE></title>
<link rel="shortcut icon" href="http://www.mathjax.org/wp-content/themes/mathjax/images/favicon.ico">
<script type="text/javascript"
  src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<CSS>
<JS>
</head>
<BODY>
</html>
)


configjax=: 0 : 0
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>
)


tabledesc=: 0 : 0
Generate random arrays of mathematical expressions and typeset them. This is an extreme use of
MathJax and is intended to guage the system's performance.
)


NB. MathJax LaTex examples
MAXWELLEQTEX=: 0 : 0
\begin{aligned}
\nabla \times \vec{\mathbf{B}} -\, \frac1c\, \frac{\partial\vec{\mathbf{E}}}{\partial t} & = \frac{4\pi}{c}\vec{\mathbf{j}} \\   \nabla \cdot \vec{\mathbf{E}} & = 4 \pi \rho \\
\nabla \times \vec{\mathbf{E}}\, +\, \frac1c\, \frac{\partial\vec{\mathbf{B}}}{\partial t} & = \vec{\mathbf{0}} \\
\nabla \cdot \vec{\mathbf{B}} & = 0 \end{aligned}
)

QUADRATICSOLTEX=: 'x = {-b \pm \sqrt{b^2-4ac} \over 2a}'

RAMANUJANTEX=: 0 : 0
\frac{1}{\Bigl(\sqrt{\phi \sqrt{5}}-\phi\Bigr) e^{\frac25 \pi}} =
1+\frac{e^{-2\pi}} {1+\frac{e^{-4\pi}} {1+\frac{e^{-6\pi}}
{1+\frac{e^{-8\pi}} {1+\ldots} } } }
)

CROSSPRODUCTTEX=: 0 : 0
\mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}
\mathbf{i} & \mathbf{j} & \mathbf{k} \\
\frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\
\frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0
\end{vmatrix}
)


NB. override jhs styles
CSSCORE=: ''

CSS=: 0 : 0
 
header{
  background-color: DarkKhaki; 
  width: 300px;
  padding: 5px;
  border: 5px solid;
  border-radius: 10px;  /* round corners */
  margin: left;
  font-family: "Helvetica Neue", helvetica, arial, sans-serif;
  font-size: 15px;
  line-height: 10px;
  color: DarkGreen;      
  overflow: hidden;     /* prepare for float clearing */
}
 
nav ul{
  overflow: hidden;
  padding: 0;
  float: left;
}
 
nav ul li:before {  
  content: '\2022 ';    /* Unicode bullet symbol */
  color: DarkKhaki;     /* bullet color */
  padding-right: 0em;
}
 
nav li{
  float: left;
  list style: none;
  color: black; 
  list-style-type: none;
  background-color: DarkKhaki ;
}
 
nav a{
  display: block;          /* required for paddding */
  padding: 8px;
  margin-right: 5px; 
  border-radius: 10px;     /* round corners */ 
  background-color: Beige; 
  color: DarkGreen;            
  text-decoration: none;   /* no underline on links */
}
  
nav a:hover{
  background-color: Gold; 
  color: Indigo;            
}

nav a:active{margin-top; 1px;} /* nudge down when pressed */

 
/* default (thh) style - used by (thh) monad */
.jarray {font-family:monospace; color: blue}

table.jarray {border-collapse:collapse;}
table.jarray td {border:solid black thin; vertical-align:top; padding:0.4em;}
table.jarray tr.spacer td {border:none;}
 
)


NB. javascript event handlers
JS=: 0 : 0 

function ev_ttable_click(){jdoajax([],"");}
function ev_tquad_click(){jdoajax([],"");}
function ev_tmaxwell_click(){jdoajax([],"");}
function ev_tramaujan_click(){jdoajax([],"");}
function ev_tcrossprod_click(){jdoajax([],"");}
function ev_treset_click(){jdoajax([],"");}

function ev_ttable_click_ajax(ts){jbyid("restable").innerHTML=ts[0]; MathJax.Hub.Typeset();}
function ev_tquad_click_ajax(ts){jbyid("resquad").innerHTML=ts[0]; MathJax.Hub.Typeset();}
function ev_tmaxwell_click_ajax(ts){jbyid("resmaxwell").innerHTML=ts[0]; MathJax.Hub.Typeset();}
function ev_tramaujan_click_ajax(ts){jbyid("resramaujan").innerHTML=ts[0]; MathJax.Hub.Typeset();}
function ev_tcrossprod_click_ajax(ts){jbyid("rescrossprod").innerHTML=ts[0]; MathJax.Hub.Typeset();}

function ev_treset_click_ajax(ts){
  jbyid("restable").innerHTML=ts[0];
  jbyid("resquad").innerHTML=ts[0]; 
  jbyid("resmaxwell").innerHTML=ts[0]; 
  jbyid("resramaujan").innerHTML=ts[0];
  jbyid("rescrossprod").innerHTML=ts[0];
}

)
NB.*end-header

NB. MathJax LaTeX display math
djaxmath=:'$$' , '$$' ,~ ]

NB. generate MathJaxDemo header navigation links
navul=:3 : '''page navigation links - override in header'''


oltypeset=:3 : 0

NB.*oltypeset v-- generate ordered list of typeset buttons.
NB.
NB. monad:  clHTML5 =. oltypeset uuIgnore

NB. jhs !(*)=. jhb

t=. '<ol><li>',('tquad' jhb 'Quadratic Solution'),'<span id="resquad"></span></li>'
t=. t,'<li>',('tmaxwell' jhb 'Maxwell''s Equations'),'<span id="resmaxwell"></span></li>'
t=. t,'<li>',('tramaujan' jhb 'Ramaujan Identity'),'<span id="resramaujan"></span></li>'
t,'<li>',('tcrossprod' jhb 'Cross Product'),'<span id="rescrossprod"></span></li></ol>'
)

NB. suppress default (thh) style
tmjx=:0&thh_htmthorn_