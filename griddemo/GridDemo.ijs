NB.*GridDemo s-- use DHTMLX grid with JHS.
NB.
NB. This  script shows how to use the JavaScript grid DHTMLX with
NB. JHS.
NB.
NB. To run this demo follow the instructions outlined here - verbatim:
NB.
NB. http://bakerjd99.wordpress.com/2012/12/03/jhs-with-the-dhtmlx-grid/
NB. http://bakerjd99.wordpress.com/2012/12/04/more-about-jhs-with-dhtmlx-the-grid/
NB. http://dhtmlx.com/docs/products/dhtmlxGrid/
NB.
NB. author:  John Baker (bakerd99@gmail.com)
NB. created: 2012nov27
NB. -----------------------------------------------------------------------
NB. 13dec22 added to (jacks) GitHub repo

coclass  'GridDemo'
coinsert 'jhs'

NB.*dependents

NB. distinguish scopes of GridDemo & JHS words
NB. override (*)=: HBS CSSCORE CSS JS hrtemplate navul

NB. context  (*)=. jpath jhrajax jhr getvs griddatfrtd datfrjsongrid
NB.          (*)=. griddaterr NV seebox smoutput writetd

NB. location of GridDemo files
PATH=: jpath '~GridDemo/'

NB. use ~root in HPATH (html path) for JS/CSS
HPATH=: '~root' , (}.~[:<./i.&'\/') PATH

NB. browser get request
jev_get=: create

NB. create page and send to browser
create=: 3 : 0
'GridDemo'jhr''
)

navul=:3 : 0

NB.*navul v-- generate GridDemo header navigation links.
NB.
NB. monad:  clHtml5 =. navul uuIgnore

NB. jhs !(*)=. jhref

s=. '<li>' [ e=. '</li>'

t=. '<header><nav><ul>'
t=. t,s,'<img src="',y,'jodoval.png" alt="Logo" height="50" width="50">',e
t=. t,s,(jhref~ 'jijx'),e
t=. t,s,(jhref~ 'jdemo'),e
t=. t,s,('http://www.dhtmlx.com/docs/products/dhtmlxGrid/index.shtml' jhref 'DHTMLX'),e
t=. t,s,('http://bakerjd99.wordpress.com/' jhref 'Blog'),e

t,'</ul></nav></header><br/>'
)


NB. DHTMLX grids need unique row Ids
ROWID=: 0

NB. J event handlers
ev_checkbr_click=: 3 : 'jhrajax '''''

ev_saveme_click=: 3 : 0
try.
  ts=. (6!:1)''
  'gridchgs tout'=. getvs 'gridchgs tout'
  (datfrjsongrid gridchgs) writetd tout
  ts =. ": >. 1000 * (6!:1 '') - ts
  jhrajax 'ok',JASEP,ts
catch.
  jhrajax griddaterr 'error saving grid'
end.
jhrajax ''
)

ev_clearme_click=: 3 :  0
ROWID=:0
jhrajax ''
)

NB. grid appends records with each click
ev_gridme_click=: 3 : 0
try.
  NB. smoutput seebox NV
  ts=. (6!:1)''
  'tin tout'=. getvs 'tin tout'
  'newid gstr'=. ROWID griddatfrtd tin
  ROWID=: newid
  ts =. ": >. 1000 * (6!:1 '') - ts
  jhrajax gstr,JASEP,ts
catch.
  jhrajax griddaterr 'error loading grid'
end.
)

NB.*enddependents

NB. css, html and javascript code do not apply J code compression (-.)=:

HBS=: 0 : 0
navul HPATH
'checkbr' jhb 'Check Browser'
'rebrchk' jhspan''
'<hr>'
'Input:  ','tin'  jhtext (jpath '~GridDemo/t100rows.txt');80
'<br/>'
'Output: ','tout' jhtext (jpath '~GridDemo/tout.txt');80
'<hr>','gridme' jhb 'Edit Grid'
'saveme' jhb 'Save Grid'
'clearme' jhb 'Clear Grid'
'rerowcnt' jhspan''
'<hr><div id="gridbox" style="width:700px;height:400px"></div>'
'<textarea id="gridchgs" style="display:none;"></textarea>'
)

NB. redefine template for HTML5
hrtemplate=: ('{{HPATH}}';HPATH) rplc~ 0 : 0
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-
Connection: close

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><TITLE></title>
<link rel="shortcut icon" href="{{HPATH}}favicon.ico">
<link rel="STYLESHEET" type="text/css" href="{{HPATH}}dhtmlxgrid.css">
<script src="{{HPATH}}dhtmlxcommon.js"></script>
<script src="{{HPATH}}dhtmlxgrid.js"></script>
<script src="{{HPATH}}dhtmlxgridcell.js"></script>
<CSS>
<JS>
</head>
<BODY>
</html>
)

NB. override jhs styles
CSSCORE=: ''

CSS=: 0 : 0

header{
  background-color: DarkKhaki;
  width: 290px;
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
  padding-rigth: 0em;
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

nav img {
  border-radius: 10px;
  background-color: DarkKhaki;
}

nav a:active{margin-top; 1px;} /* nudge down when pressed */

)

NB. The standard edition of the grid makes you jump
NB. through clunky loops to extract changes to the grid.
NB. You have to scan all the cells in the grid and store
NB. serialized text for jdoajax to pickup. A smarter
NB. process would mark each row as it's edited and
NB. only scan changes. The professional version
NB. already does this out of the box.

NB. javascript event handlers
JS=: ('{{HPATH}}';HPATH) rplc~ 0 : 0

// global grid object
var grid0;

function ev_gridme_click(){jdoajax(["tin","tout"],"");}
function ev_checkbr_click(){jdoajax([],"");}
function ev_clearme_click(){jdoajax([],"");}

function ev_saveme_click(){

  if ('undefined' != typeof grid0){

    if (0 == grid0.getRowsNum()){
      jbyid("rerowcnt").innerHTML = "No rows to save";
      return;
    }

    var st = new Date().getTime(),  // start time
        ids = grid0.getAllRowIds(","),
        ccnt = 1 + grid0.getColumnsNum();  // includes id

    ids = ids.split(",");
    var rcnt = ids.length,
        tab = new Array(rcnt);

    // header row - tab[0][0] cell ignored
    tab[0] = new Array(ccnt);
    for (var i = 1; i < ccnt; i++) {
      tab[0][i] = grid0.getColumnLabel(i-1,0);
    }

    // cells with leading row id
    for (var i = 0 , si = 1 ; i < rcnt; i++ , si++) {
      tab[si] = new Array(ccnt);
      for (var j = 1; j < ccnt; j++) {
        tab[si][j] = grid0.cells((+ids[i]),j-1).getValue();
      }
      tab[si][0] = ids[i];
    }

    // prefix row column counts
    var pfx = (rcnt+1) + " " + ccnt + "*";
    jbyid("gridchgs").innerHTML = pfx + JSON.stringify(tab);
    jdoajax(["gridchgs","tout"],"");

    var et = new Date().getTime() - st;  // end time
    jbyid("rerowcnt").innerHTML= " row count= " + grid0.getRowsNum() +
        ",  JavaScript ms= " + et;

  } else {

    jbyid("rerowcnt").innerHTML= "Nothing to save";
  }
}

function ev_checkbr_click_ajax(){
  if (!(window.File && window.FileReader && window.FileList && window.Blob)) {
    jbyid("rebrchk").innerHTML= "File APIs are not supported by this browser.";
  } else {
    jbyid("rebrchk").innerHTML= "File APIs are supported - you can run the demo"; ;
  }
}

function ev_clearme_click_ajax(ts){
  jbyid("gridchgs").innerHTML = "";
  if('undefined' != typeof grid0) {
    grid0.clearAll();
    jbyid("rerowcnt").innerHTML= " row count= " + grid0.getRowsNum();
  } else {
    jbyid("rerowcnt").innerHTML= "";
  }
}

function ev_gridme_click_ajax(ts){

  if("ok" == ts[0]){

    var st = new Date().getTime();  // start time

    if ('undefined' == typeof grid0) {
      grid0 = new dhtmlXGridObject('gridbox');

      //path to images required by grid
      grid0.setImagePath("{{HPATH}}imgs/");

      grid0.setHeader(ts[2]);      //set column names
      grid0.setInitWidths(ts[3]);  //set column width in px
      grid0.setColAlign(ts[4]);    //set column values align
      grid0.setColTypes(ts[5]);    //set column types
      grid0.setColSorting(ts[6]);  //set sorting

      grid0.init();
      grid0.setSkin("light");
    }

    var js=JSON.parse(ts[1]);
    grid0.parse(js,"json");

    var et = new Date().getTime() - st;  // end time
    jbyid("rerowcnt").innerHTML= " row count= " + grid0.getRowsNum() +
      ",  JavaScript ms= " + et + ",  J ms= " + ts[7];

  } else {

    jbyid("rerowcnt").innerHTML= ts[1]; // JHS error message
  }
}

function ev_saveme_click_ajax(ts){
  if("ok" == ts[0]){
    jbyid("rerowcnt").innerHTML += ", J ms= " + ts[1] + " grid saved";
  } else {
    jbyid("rerowcnt").innerHTML = ts[1];
  }
}

)
NB.*end-header

NB. carriage return line feed character pair
CRLF=:13 10{a.

NB. row/col count prefix delimiter
PFXDEL=:'*'

NB. tab character
TAB=:9{a.

NB. trims all leading and trailing blanks
alltrim=:] #~ [: -. [: (*./\. +. *./\) ' '&=

NB. boxes open nouns
boxopen=:<^:(L. = 0:)


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


charsub=:4 : 0

NB.*charsub v-- single character pair replacements.
NB.
NB. dyad:  clPairs charsub cu
NB.
NB.   '-_$ ' charsub '$123 -456 -789'

'f t'=. ((#x)$0 1)<@,&a./.x
t {~ f i. y
)


cutjsongriddat=:3 : 0

NB.*cutjsongriddat v-- parses valid JSON grid data.
NB.
NB. This  verb  processes  the  JSON  strings  generated  by  the
NB. JavaScript (ev_saveme_click) function. JSON must be valid and
NB. free of JASEP characters.
NB.
NB. monad:  btcl =. ilShp cutjsongriddat clJsonGrid

NB. leading grid shape 
p=. y i. PFXDEL
s=. _1 ". p {. y 

NB. mask any escaped " chars !(*)=. JASEP
d=. ('/\"/',JASEP) changestr ',',(>:p)}.y
a=. ~:/\'"'=d
a=. -. a +. _1 (|.!.0) a

NB. reduce and cut on chars outside "..." runs 
b=. -. a *. d e. '[] '
d=. b#d [ a=. b#a
d=. (a *. d e. ',') <@(}.@}:);._1 d

NB. restore any escaped "
if. 1 e. b=. JASEP_jhs_&e.&> d do.
  b=. I. b
  d=. ((JASEP,'"')&charsub&.> b{d) b} d
end.

s $ d
)


datfrjsongrid=:3 : 0

NB.*datfrjsongrid v-- btcl from json grid data.
NB.
NB. monad:  btcl =. datfrjsongrid clJson

h=. 0{d=. cutjsongriddat y
d=. }.d 

NB. remove any rows without DHTMLX ids
d=. d #~ 0 < #&> (0 {"1 d) -.&.> <' ',CRLF,TAB

NB. sort by ids then drop them
}."1 h , (/: _1&".&> 0 {"1 d) { d
)

NB. enclose all character lists in blcl in " quotes
dblquote=:'"'&,@:(,&'"')&.>


dhjsonfrbtcl=:3 : 0

NB.*dhjsonfrbtcl v-- DHTMLX json from btcl.
NB.
NB. monad:  clJson =. dhjsonfrbtcl btcl
NB. dyad:   clJson =. iaIc dhjsonfrbtcl btcl
NB.
NB.   NB. start row count at 0
NB.   0 dhjsonfrbtcl readtd2 '/home/john/pd/books/BOOKS.txt'

0 dhjsonfrbtcl y
:
NB. json table data
d=. }."1 ;"1  (<',"') ,&.> y ,&.> '"'
d=. (<', "data":[') ,&.>  (alltrim&.> <"1 d) ,&.> <']},'

NB. DHTMLX grid requires unique row ids
r=. ('{"id":'&,@":)&.> <"0 x + i.#d
'{"rows":[',(}: ; ,r ,. d) ,']}'
)


dhjsonfrnt2=:4 : 0

NB.*dhjsonfrnt2 v-- DHTMLX json from numeric table.
NB.
NB. Converts a numeric J table to the JSON string format expected
NB. by the DHTMLX JavaScript (grid.parse) function.
NB.
NB. dyad:  iaRowId dhjsonfrnt2 nt
NB.
NB.   0 dhjsonfrnt2 7 %~ ?13 7$1000

rows=. ', "data":[' ,"1 (}."1 'm<">p<,">n<">q<">' 8!:2 y) ,"1 ']},'
rows=. ('{"id":' ,"1 ": ,. x + i.#y) ,. rows
rebc '{"rows":[' , (}:,rows) , ']}'
)

NB. boxes UTF8 names
fboxname=:([: < 8 u: >) ::]

NB. 1 if file exists 0 otherwise
fexist=:1:@(1!:4) ::0:@(fboxname&>)@boxopen


griddaterr=:3 : 0

NB.*griddaterr v-- form error JASEP result.
NB.
NB. monad:  cl =. griddaterr clMsg

'er',JASEP,y, ;6#<JASEP,'' NB. jhs !(*)=. JASEP
)


griddatfrtd=:4 : 0

NB.*griddatfrcsv v-- format grid data from TAB delimited text file for JHS & DHTMLX.
NB.
NB. dyad:  (ia ; cl) =. iaId griddatfrtd clFile
NB.
NB.   'ROWID jasepstr'=. 0 griddatfrtd jpath '~GridDemo/t100rows.txt'

try.

if. fexist y do.

  NB. escape any " chars
  d=. parsetd ('/"/\"') changestr read y
  
  d=. }. d [ h=. 0{d   NB. first row has column names
  nc=. x + #d          NB. new row id count

  json=. x dhjsonfrbtcl d  NB. json table data

  names=.   }. ; ',' ,&.> h -.&.> ','
  widths=.  }. , d # ,: ',100'  [ d=. #h
  aligns=.  }. , d # ,: ',left'
  edtypes=. }. , d # ,: ',ed'
  sorts=.   }. , d # ,: ',str'

  NB. jhs !(*)=. JASEP
  nc;'ok',JASEP,json,JASEP,names,JASEP,widths,JASEP,aligns,JASEP,edtypes,JASEP,sorts  
  
else.
  x;griddaterr 'input file does not exist'
end.
  
catch.
  x;griddaterr 'cannot read/parse file'
end.
)

NB. hours, minutes, seconds.ddd from decimal day seconds: y < 86400
hmsfrdds=:24 60 60&#:


isotimestamp=:3 : 0

NB.*isotimestamp v-- format time as: YYYY-MM-DD HR:MN:SC.ddd
NB.
NB. Yet another timestamp formart. (y) is one or more time stamps
NB. in 6!:0 format.
NB.
NB. monad: cl =. isotimestamp nlTime
NB.        ct =. isotimestamp ntTime
NB.
NB.   isotimestamp 6!:0 ''
NB.
NB.   isotimestamp 10 # ,: 6!:0 ''  NB. table

r=. }: $y
t=. _6 [\ , 6 {."1 y
d=. '--b::' 4 7 10 13 16 }"1 [ 4 3 3 3 3 3 ": <.t
d=. d ,. }."1 [ 0j3 ": ,. 1 | {:"1 t
c=. {: $d
d=. ,d
d=. '0' (I. d=' ')} d
d=. ' ' (I. d='b')} d
(r,c) $ d
)


makeGridDemoTestFiles=:3 : 0

NB.*makeGridDemoTestFiles v-- generate test TAB delimited files for GridDemo.
NB.
NB. monad:  blclMsg =. makeGridDemoTestFiles uuIgnore

NB. names data from z locale 
cnt=. #names=. 100 $ nl_z_ i. 4  
dates=. <"1 randomtstamps cnt
ints=. (8!:0) ?cnt#100000
floats=. (8!:0)(?cnt#100000) % 573

dat=. names ,. dates ,. ints ,. floats
colheads=. <;._1 '/These/Column Names/Were/Randomly Hacked/Together/For Test/Purposes/EHHH'
dat=. |: ;(>.(#colheads) % {:$dat) # < |: dat

NB. 100, 1000, 5000 rows !(*)=. jpath
path=. jpath '~GridDemo/'
(colheads , 100 {. dat) writetd path,'t100rows.txt'
(colheads , (1000?1000){10#dat) writetd path,'t1000rows.txt'
(colheads , (5000?5000){50#dat) writetd path,'t5000rows.txt'

'test files written to -> ',path
)

NB. parse TAB delimited table text - see (readtd2) long document
parsetd=:[: <;._2&> (9{a.) ,&.>~ [: <;._2 [: (] , ((10{a.)"_ = {:) }. (10{a.)"_) (13{a.) -.~ ]


randomtstamps=:3 : 0

NB.*randomtstamps v-- valid random time stamps.
NB.
NB. monad:  ctStamps =. randomtstamps iaCnt
NB. dyad:   ctStamps =. iaYear randomtstamps iaCnt

NB. start year must be Gregorian > 1582
1899 randomtstamps y
:
NB. (y) valid random dates from a year in a two century
NB. span from start year if (y > 365) days will repeat
yrep=. 1 >. >.y % 365
days=. (y?yrep*365) { yeardates (yrep$x) + ?200
hms=.  hmsfrdds (?y#86400) + (?y#1000)%999
isotimestamp days ,. hms
)

NB. reads a file as a list of bytes
read=:1!:1&(]`<@.(32&>@(3!:0)))

NB. removes multiple blanks (char only)
rebc=:] #~ [: -. '  '&E.


valdate=:3 : 0

NB.*valdate v-- validates lists or tables of YYYY MM DD Gregorian
NB. calendar dates.
NB.
NB. monad:  valdate il|it
NB.
NB.   valdate 1953 7 2
NB.   valdate 1953 2 29 ,: 1953 2 28  NB. not a leap year

s=. }:$y
'w m d'=. t=. |:((*/s),3)$,y
b=. *./(t=<.t),(_1 0 0<t),12>:m
day=. (13|m){0 31 28 31 30 31 30 31 31 30 31 30 31
day=. day+(m=2)*-/0=4 100 400|/w
s$b*d<:day
)

NB. format and write TAB delimited table files
writetd=:] (1!:2 ]`<@.(32&>@(3!:0)))~ [: 2&}.@:;@:((13{a.)&,&.>@<;.1@((10{a.)&,)@(((10{a.) I.@(e.&(13{a.))@]} ])@:(#~ -.@((13 10{a.)&E.@,)))) [: }.@(,@(1&(,"1)@(-.@(*./\."1@(=&' '@])))) # ,@((10{a.)&(,"1)@])) [: }."1 [: ;"1 (9{a.) ,&.> [


yeardates=:3 : 0

NB.*yeardates v-- returns all valid dates for n calendar years.
NB.
NB. The monad returns an integer table with YYYY MM DD rows.  The
NB. dyad returns dates as a list of YYYYMMDD integers.
NB.
NB. This algorithm  uses  a  series of outer-products  and  ravel
NB. reductions to form a cross  product rather  than  the  direct
NB. catalog verb ({).
NB.
NB. monad:  itYYYYMMDD =. yeardates ilYears
NB.
NB.   yeardates 2000
NB.
NB.   yeardates 2001 + i. 100  NB. all dates in 21st century
NB.
NB.
NB. dyad:  ilYYYYMMDD =. uu yeardates ilYears
NB.
NB.   0 yeardates 2001
NB.
NB.   yeardates~  1999 2000 2001   NB. useful idiom

NB. generate all possible dates in years
days =. ,/ (,y) ,"0 1/ ,/ (>: i. 12) ,"0/ >: i. 31

NB. remove invalid dates
days #~ valdate days
:
NB. convert to yyyy mm dd format
0 100 100 #. yeardates y
)