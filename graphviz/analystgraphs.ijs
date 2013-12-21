NB.*analystgraphs s--  analystgraphs class - analyzes analyst csv
NB. and prepares dot digraph code.
NB.
NB. This class analyzes metadata in analyst  *.csv and  generates
NB. dot  digraph code that  can be  used by the graphviz addon to
NB. produce structure diagrams for analyst models.
NB.
NB. verbatim:
NB.
NB. http://www.graphviz.org/
NB. http://www.jsoftware.com/jwiki/Addons/graphics/graphviz
NB. http://bakerjd99.wordpress.com/2009/09/09/fake-progamming/
NB.
NB. created: 2008apr23
NB. author:  bakerjd99@gmail.com
NB. ---------------------------------------------------------
NB. 09aug19 fixed bug to allow models with no links
NB. 09aug26 graphviz loaded
NB. 13dec21 saved in (jacks) GitHub repo

require 'graphics/graphviz'

coclass 'analystgraphs'
NB.*end-header

NB. path to analyst csv print files
AnalystCsvPath=:'\\fe10data\user$\bakej01\modelcsv'

NB. carriage return character
CR=:13{a.

NB. carriage return line feed character pair
CRLF=:13 10{a.

NB. csv file extension
CSVEXT=:'.csv'

NB. header text that delimits objects in analyst print csvs
CSVHEADER=:61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 13 10 32 13 10{a.

NB. color or nodes with 0 in and out degree
DISCONNECTCOLOR=:'lightblue'

NB. analyst "." character
DOT=:'.'

NB. D-Cube, D-List or D-Link prefix
DTYPES=:2 3$<;._1 ' D-Cube D-List D-Link cube list link'

NB. dot main graph name
DotGraphName=:'franklin'

NB. color of box edges enclosing analytgraph
EDGECOLOR=:'blue'

NB. elist name in standard nld format - if nonnull length is forced to 1
ElistNameNLD=:''

NB. interface words for class group
IFACEWORDSanalystgraphs=:<;._1 ' loadanalystmodel loadcontributormodel'

NB. indent spaces in DOT generated code
INDENT=:'  '

NB. input node color
INPUTCOLOR=:'green'

NB. color of nodes that have in and out degree
INTERIORCOLOR=:'lightgoldenrod'

NB. DOT label word wrap limit
LABELWIDTH=:15

NB. line feed character
LF=:10{a.

NB. used to filter possible links - MUST BE COMPLETE
LINKFILTERTYPES=:<;._1 '|Name:,|Library:,|Source:,|ODBC Datasource:,|Target:,|Table:,|SQL Statement:,'

NB. name library datatype delimiter character
NLDSEP=:'|'

NB. basic node style of analystgraph - usually 'filled'
NODESTYLE=:'filled'

NB. output node color
OUTPUTCOLOR=:'yellow'

NB. root words for class group
ROOTWORDSanalystgraphs=:<;._1 ' ROOTWORDSanalystgraphs appendCFlts atfrdlist dlistnldobjs epsfrps filterlinks loadanalystmodel loadcontributormodel loadhrd pcdigraph uniquesql'

NB. link source text
SOURCE=:'Source'

NB. all supported sources/targets - MUST BE COMPLETE
SOURCETARGETTYPES=:'/D-Cube /.cube./File Map /.fmap/Contributor Cube: /.contributor. /ODBC-Input /.ODBC '

NB. tab character
TAB=:9{a.

NB. link target text
TARGET=:'Target'

NB. maximum line length of dlink plaintext nodes
TEXTDLINKLABELWIDTH=:100

NB. maximum line length of dlist plaintext nodes
TEXTDLISTLABELWIDTH=:80

NB. color of arcs connecting plaintext nodes in analystgraph - white works best
TEXTNODEARROWCOLOR=:'white'

NB. color of plaintext nodes
TEXTNODECOLOR=:'lightgray'

NB. font size in points of analystgraph main title text
TITLEFONTSIZE=:24

NB. length of leading type prefix text in analyst csv
TYPEWIDTH=:6

NB. text used for links with unknown sources
UNKNOWNSOURCECUBES=:'UNKNOWN LINK SOURCE(S)'

NB. text used for links with unknown targets
UNKNOWNTARGETCUBES=:'UNKNOWN LINK TARGET(S)'

NB. adjacency matrix from source target connection table
adjfrct=:([: { 2 # [: < [: ~. ,) e. <"1

NB. retains string (y) after last occurrence of (x)
afterlaststr=:] }.~ #@[ + 1&(i:~)@([ E. ])

NB. retains string after first occurrence of (x)
afterstr=:] }.~ #@[ + 1&(i.~)@([ E. ])

NB. trims all leading and trailing blanks
alltrim=:] #~ [: -. [: (*./\. +. *./\) ' '&=

NB. trims all leading and trailing white space
allwhitetrim=:] #~ [: -. [: (*./\. +. *./\) ] e. (9 10 13 32{a.)"_


antimode=:3 : 0

NB.*antimode v-- finds the least frequently occurring  item(s) in
NB. a list.
NB.
NB. monad:  ul =. antimode ul
NB.
NB.   antimode ?.500#100
NB.   antimode ;:'blah blah blah yada yada wisdom'


if. 0 < # y =. ,y do.    NB. no antimodes for null lists
  f =. #/.~ y            NB. nub frequency
  (~. y) #~ f e. <./ f   NB. lowest frequency items
else. y
end.
)


appendCFlts=:4 : 0

NB.*appendCFlts  v--  kludge  to  work  around  analyst  CF  link
NB. printing bug.
NB.
NB. Printing  an analyst link that references a CF  source/target
NB. crashes analyst 8.3 (08sep15). This verb appends in a list of
NB. known links to the (lts) table so these sources and sinks can
NB. be included in digraphs.
NB.
NB. dyad:  clCFlinks appendCFlts (stSrm;<stLts)
NB.
NB.   StagingCFLinks appendCFlts (srm;<lts)

'srm lts'=. y

if. 0=#x do. lts return. end.

NB. known CF links
cfl=. s: x

NB. rumfeldian known unknowns
unsource=. s:<UNKNOWNSOURCECUBES
untarget=. s:<UNKNOWNTARGETCUBES

lc=. {:"1 >0{srm
cb=. {."1 >0{srm

NB. test link names - a link does not have to
NB. reference known sources and targets
b=. cfl e.{."1;lc

if. 0 e. b do.

  NB. pass through links - unknown sources and targets
  ptl=. (-.b)#cfl
  lts=. lts , (ptl ,. unsource) ,. untarget
end.

if. -.+./b do. lts return. end.

cfl=. b#cfl

NB. blpl of masks of cubes in library that reference known CF links
m=. ({."1&.> lc) e.&.> <cfl
b=. +./&> m

NB. cubes with CF links
lc=. b#m #&.> lc
cb=. (#&> lc)#b#;cb
cb=. cb ,. ;lc

NB. links to first column
cb=. 1 2 0 {"1 cb

NB. we cannot see CF sources/targets - replace any target symbols with UNKNOWNS
pt=. I. (1 {"1 cb) = s:<TARGET
cb=. unsource (<pt;1)} cb

NB. rotate any remaining sources to proper column
ps=. (1 {"1 cb) = s:<SOURCE
cb=. (0 {"1 cb) ,. ps (|."0 1) 1 2 {"1 cb
cb=. untarget (<(I. ps);2)} cb

NB. append to link source target table
lts , cb
)

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))


atfrdlist=:3 : 0

NB.*atfrdlist v-- generate TAB delimited access table text from dlist csv text.
NB.
NB. monad:  atfrdlist clDlistCsv
NB.
NB.   di=. dlistnldobjs read '\\fe10data\user$\bakej01\modelcsv\dev common dlists.csv'
NB.   pos=. (;0{di) i. s: <'2 - Products SRP2 and SRP3|Common|list'
NB.   atfrdlist ;pos{1{di
NB.     
NB. dyad:  clAccess atfrdlist clDlistCsv
NB.
NB.   'HIDDEN' atfrdlist dltxt

'WRITE' atfrdlist y
:
'dlist items'=. 1 dlistitems y
head=. (NLDSEP&beforestr dlist),TAB,'AccessLevel',CRLF
head, ;items ,&.> <TAB,(alltrim x),CRLF 
)

NB. retains string (y) before last occurrence of (x)
beforelaststr=:] {.~ 1&(i:~)@([ E. ])

NB. retains string before first occurrence of (x)
beforestr=:] {.~ 1&(i.~)@([ E. ])


betweenstrs=:4 : 0

NB.*betweenstrs v-- select sublists between  nonnested delimiters
NB. discarding delimiters.
NB.
NB. dyad:  blcl =. (clStart;clEnd) betweenstrs cl
NB.        blnl =. (nlStart;nlEnd) betweenstrs nl
NB.
NB.   ('start';'end') betweenstrs 'start yada yada end boo hoo start ahh end'
NB.
NB.   NB. also applies to numeric delimiters
NB.   (1 1;2 2) betweenstrs 1 1 66 666 2 2 7 87 1 1 0 2 2

's e'=. x
llst=. ((-#s) (|.!.0) s E. y) +. e E. y
mask=. ~:/\ llst
(mask#llst) <;.1 mask#y
)

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


classifyobjs=:3 : 0

NB.*classifyobjs v-- collects cubes, lists and links from general
NB. analyst model csv.
NB.
NB. monad:  blcl =. classifyobjs clCsv
NB.
NB.   csv=. read 'g:\modelcsv\dev sales forecast model.csv'
NB.   classifyobjs csv
NB.
NB. dyad:  blcl=. blcl classifyobjs clCsv
NB.
NB.   NB. get only dlists
NB.   common=. read 'g:\modelcsv\dev common.csv'
NB.   (1{0{DTYPES) classifyobjs common
NB.
NB.   NB. dcubes and dlinks
NB.   (0 2{0{DTYPES) classifyobjs common

(0{DTYPES) classifyobjs y
:
NB. check types
dtypes=. ~. x
'invalid object types' assert dtypes e. 0{DTYPES

csv=. labelfirstcsvobj y

NB. cut on header
'invalid first object header' assert 0{mask=. CSVHEADER E. csv
csv=. mask <;.1 csv

NB. collect objects
otype=. allwhitetrim&.> 'Name:,'&beforestr&.> 'Type of object:,'&afterstr&.> csv
order=. /: otype=. dtypes i. otype

;&.> (#dtypes){.(order{otype) </. order{csv
)


colorinputs=:4 : 0

NB.*colorinputs v-- generate DOT node coloring code.
NB.
NB. dyad:  (stShortlongxref;clNodeattr) colorinputs slNodes

'st na'=. x
ctl INDENT ,"1 ;"1 [ 5 s: (((1{"1 st) i. y) { 0 {"1 st) ,. s:<' [',na,'];'
)


coloroutputs=:4 : 0

NB.*coloroutputs v-- generate DOT output node coloring code.
NB.
NB. dyad:  (stShortlongxref;clNodeattr) colorinputs slNodes

'st na'=. x
ctl INDENT ,"1 ;"1 [ 5 s: (((1 {"1 st) i. y) { 0 {"1 st) ,. s:<' [',na,'];'
)


countsql=:3 : 0

NB.*countsql v-- sql syntax match test.
NB.
NB. Given  a  list of SQL statements this verb attempts  to count
NB. the number of distinct statements. The test is  based  on SQL
NB. syntax and should ignore  all white space and identifier case
NB. differences.
NB.
NB. The best algorithm uses J's word parsing to cut away  all the
NB. white  space  and to isolate single  quote delimited strings.
NB. Double  quote  delimited  strings  are  not  handled. J  word
NB. formation  is not ideal for SQL  and a better algorithm would
NB. use a finite state machine to tokenize SQL.
NB.
NB. monad:  btcl =. countsql blclSql

NB. attempt to tokenize sql
tsql=. (;: :: _1:) &.> y

if. +./_1 e.&> tsql do.
  NB. sql will not cut with J word formation use naive algorithm
  tsql=. >y ,&.> y
  tsql=. toupper reb"1 ljust tsql
  usql=. ~. tsql
  usql=. usql #~ -. *./"1 ' ' = usql
else.
  tsql=. > tsql
  qp=. I. ,''''&e.&> tsql
  str=. qp { ,tsql

  NB. upper case for all non-empty tokens - the empty
  NB. test is marginally faster than: toupper L: 0 tsql
  tsql=. (]`toupper@.(0 < #)) L: 0 tsql

  NB. reinsert quoted text
  tsql=. ($tsql) $ str qp} ,tsql

  NB. unique nonempty rows
  usql=. ~.tsql
  usql=. usql #~ -. *./"1 ] 0=#&> usql
end.

NB. label unique sql
selst=. (<"1 'select #' ,"1 ljust ": ,.>:i.#usql),<''
usql=. ((usql i. tsql) {selst) ,. y
)

NB. character table to newline delimited list
ctl=:}.@(,@(1&(,"1)@(-.@(*./\."1@(=&' '@])))) # ,@((10{a.)&(,"1)@]))

NB. enclose all character lists in blcl in " quotes
dblquote=:'"'&,@:(,&'"')&.>


dcubelistsizes=:3 : 0

NB.*dcubelistsizes v-- computes cube list sizes table
NB.
NB. monad:  bt =. dcubelistsizes stSrm
NB.
NB.   srm=: modelstruc hrm
NB.   dcubelistsizes srm

cubes=.  ;{."1 >0{ y
lists=. 1 {"1 >1{ y
ld=. lists #&.>~ ({."1&.> lists) e.&.> <cubes
ld=. (0 2 {"1 >1{y) ,. ld
ld=. ld #~ 0 < #&> {:"1 ld
ld=. (( #&.> {:"1 ld) ,.@#&.> 2 {."1 ld) ,. {:"1 ld
ld=. (; 0{"1 ld);(; 1 {"1 ld); ;2 {"1 ld
ld=. (</: >{:"1 ld) {&.> ld

NB. if a nonempty elist name has been set - replace
NB. whatever length the elist has with 1 - this better
NB. reflects actual node size in contributor models
if. #ElistNameNLD do.
  el=. s:<ElistNameNLD
  ld=. (<1(I.,el=;0{ld)};1{ld) (1)}"1 ld
end.

ld=. |:(<~: >{:"1 ld) <;.1&> ld
((1&{.)@:,&.> ~.&.> 2 {"1 ld) ,. 2 {."1 ld
)


dcubesizes=:3 : 0

NB.*dcubesizes v-- computes cube sizes from cube list sizes
NB.
NB. monad:  bt =, dcubesizes btDcubelistsizes
NB.
NB.   dcs=. dcubelistsizes srm
NB.   dcubesizes dcs

(5 s: ;0 {"1 y) ,. <"1 (#&> 1 {"1 y) ,. */&> 2 {"1 y
)


dcubestat=:3 : 0

NB.*dcubestat v-- descriptive statistics for dcubes
NB.
NB. monad: ct =. dcubestal nl
NB.
NB.   dcubestat  ?.1000#100
NB.
NB. dyad:  ct =.  faRound dcubestat nl
NB.
NB.   0.1 dcubestat  ?.1000#100

0.0001 dcubestat y
:
t=. '/sample size/minimum/maximum/1st quartile/2nd quartile/3rd quartile/first mode'
t=. t , '/first antimode/mean/std devn'
min=. <./ 
max=. >./
t=. ,&':  ' ;._1 t
v=. $,min,max,q1,median,q3,({.@mode2),({.@antimode),mean,stddev
s=. x round ,. v , y

NB. split to properly format nondecimals
t ,. rjust ('c' (8!:2) <. 0 1 2 { s) , ('c' (8!:2) (3 4 5 6 7){s) , ('c' (8!:2) 8 9{s)
)

NB. deviation about mean
dev=:-"_1 _ mean


dimxref=:3 : 0

NB.*dimxref v-- dlist/dimension xref 
NB.
NB. monad:  dimxref stDlist
NB.
NB.   dls=. dcubelistsizes srm
NB.   dimxref dls

un=. /:~ ~. ; ,&.>  1 {"1 y  NB. unique dlists 

NB. short name full xref 
(s: 'd' ,"1 ljust ": ,. >:i. #un) ,. un
)


dlistitems=:3 : 0

NB.*dlistitems v-- extract dlist item table from dlist object.
NB.
NB. monad:  dlistitems clDistcCsv
NB.
NB.   do=. objlist read '\\fe10data\user$\bakej01\modelcsv\dev common dlists.csv'
NB.   dlistitems 0 pick do

0 dlistitems y
:
th=. 'No.,IID,Item name,Format,Calc,Calc Options'

NB. following code assumes current *.csv dlist format
NB. will break if ',' character appears after dlist item section
items=. ',' ,~ ','&beforelaststr (th,LF)&afterstr y -. CR

NB. replace quoted ,'s and parse
rep=. 1{a.
'replacement character in dlist text' assert ~: rep e. items
items=. ('",',rep) requoted items
items=. items -. '"' 
items=. (<;._1 ',', th) , <;._1&> ',' ,&.> <;._2 tlf items

NB. restore ,'s in parsed text
if. #rows=. I. +./"1 rep&e.&> items do.
  items=. ((rep,',')&charsub&.> rows{items) rows} items
end.

NB. remove items without item numbers & iids
if. x-:1 do.
  itiid=. _1&".&.> (0 1 {"1 items) -.&.> ' '
  items=. items #~ (*./"1 ] 0 < ;"1 itiid) *. *./"1 #&> itiid
  items=. 2 {"1 items
end.

NB. extract dlist name and library
name=. allwhitetrim ;('Name:,';'Library:,') betweenstrs y
lib=.  allwhitetrim& ;('Library:,';'Created:,') betweenstrs y
(name,NLDSEP,lib);<items
)


dlistnldobjs=:3 : 0

NB.*dlistnldobjs v-- returns a bt of dlist nlds and cut object text.
NB.
NB. monad:  dlistnlds clDistCsv
NB.
NB.   dlistnldobjs read '\\Fe10sql-cp-dev\f$\Planning Data Loads\Expenses Support Files\prd common dlists.csv'

do=. objlist y
('list'&nld&.> do) ,: do
)

NB. extracts length of dlist from analyst csv
dlistsize=:[: _1&".&> (<13 10 9{a.) -.&.>~ [: 'Timescale:,'&beforestr&.> 'Number of items:,'&afterstr&.>

NB. bit mask of ct rows starting with 'D-'
dlmask=:[: , 1 {."1 (,:'D-') E. ]


dotdigraph=:4 : 0

NB.*dotdigraph v-- generates dot digraph code.
NB.
NB. This verb  takes  a directed  graph  represented  as a  three
NB. column table of name source and target (parent child) symbols
NB. and generates DOT code that can be used by the graphviz addon
NB. to draw the graph.
NB.
NB. Long labels are mapped to short forms  and formatted so  they
NB. will wrap  within the graph nodes.  This handles long analyst
NB. object names.
NB.
NB. dyad: clDot =. btHrm dotdigraph stNameSourcetarget
NB.
NB.   lts=. hrm linktargets hrd  NB. see: linktargets
NB.   dot=. (hrm;'dotname') dotdigraph lts
NB.   dotflt=. ((<hrm),'dotname';'\n(filtered)') dotdigraph lts

'hrm dotname filter'=. 3{.x

NB. parsed model to symbol
srm=. modelstruc hrm

NB. formatted dcube sizes
dls=. dcubelistsizes srm
dcs=. dcubesizes dls

NB. extract library model name
lb=. NLDSEP&beforestr NLDSEP&afterstr ,>0{0{dcs

dcsfmt=. (<"1 'lp<\n>q<d>6.0,cq<c>' 8!:2 >{:"1 dcs) (<a:;1)} dcs
dcsfmt=. dcsfmt fmtdimlists dls

NB. topological link source target
lts=. sortlts y

NB. source/target cubes
st=. 1 2 {"1 lts

NB. link names
ln=. 0 {"1 lts

NB. short labels long name xref
nxf=. nodexref st

NB. cubes without any links
ncn=. ~.(;{."1 >0{srm) -. {:"1 nxf
ncxf=. (#nxf) nodexref ncn

NB. map nodes to short forms
dg=. ((1 {"1 nxf) i.st) { 0 {"1 nxf

NB. link labels
ll=. s: (<' "]') ,&.>~  (<' [label=" ') ,&.> ":&.> <"0 >: i. # dg

NB. dot node connection syntax
dg=. (0 3 1 2 4) {"1 (dg ,. ll) ,"1  s: '->';'; //L: '
dg=. dg ,. ln
dg=. ctl ;"1 (<'  ') ,. (5 s: dg) ,&.> ' '

NB. graph header and trailer - cluster 1
hdr=. 'digraph ',dotname,' {',LF,'subgraph cluster1 {',LF,'  ordering=out;',LF
if. #NODESTYLE do.
  hdr=. hdr,'  node [style=',NODESTYLE,', color=',INTERIORCOLOR,'];',LF
  dccolor=.  ', color=',DISCONNECTCOLOR
  edcolor=.  ' color=',EDGECOLOR
  incolor=.  ' color=',INPUTCOLOR
  outcolor=. ' color=',OUTPUTCOLOR
else.
  NB. with no nodestyle a plain uncolored graph is generated
  NB. this form is more readable when printed on bw printers
  dccolor=. edcolor=. ''
  NB. replace colors with peripheries
  incolor=. outcolor=. 'peripheries=3'
end.
tr=. LF,'}'

NB. node labels
ndl=. (dcsfmt;'') labelsfrnld nxf

NB. disconnected labels
dcnodes=. (dcsfmt;dccolor) labelsfrnld ncxf

NB. color input and output nodes
innodes=.  (nxf;incolor) colorinputs ~.(1 {"1 st) -. 0 {"1 st
outnodes=. (nxf;outcolor) coloroutputs ~.(0 {"1 st) -. 1 {"1 st

NB. statistic text nodes
lsg=.LF,(dcs;<dls) fmtlinklabels ln
tail=. LF,INDENT,'label="',lb,'\n',(timestamp ''),filter,'" fontsize=',(":TITLEFONTSIZE),';',LF,edcolor,LF,'}'
lsg=. lsg,tail

NB. dot code
hdr,dg,LF,ndl,LF,innodes,LF,outnodes,LF,dcnodes,lsg,tr
)


epsfrps=:3 : 0

NB.*epsfrps   v--  convert  postscript   (ps)   to   encapsulated
NB. postscript (eps).
NB.
NB. Many simple postscript files can be converted to encapsulated
NB. postscript with this simple hack. The postscript generated by
NB. the graphviz addon can be  converted with this verb. WARNING:
NB. this type of hack will not work for most postscript files and
NB. may stop working for graphviz outputs in the future.
NB.
NB. monad:  clPathfileEPS =. epsfrps clPathfilePs

'missing .ps file extension' assert  1 e. '.ps' E. y

ps=. read y                                 NB. get postscript PS
eps=. '%!PS-Adobe-3.0 EPSF-3.0',CRLF,ps     NB. instant EPS
epsfile=. ('.eps' ,~ '.'&beforelaststr) y   NB. eps file
eps write epsfile                           NB. save eps data
epsfile                                     NB. file name result
)


filterlinks=:4 : 0

NB.*filterlinks v-- filter analyst model link table.
NB.
NB. The  internal  links  within  a  contributor  model  must  be
NB. confined to a single analyst library. Links that target items
NB. outside a library are seldom included in a contributor model.
NB. This verb removes all such links from a source target table.
NB.
NB. dyad:  st =. clLibName filterlinks stSourcetarget

NB. (n*2) source target st to (n*6) btcl
elts=. ;"1 (<;._1)&.> NLDSEP ,&.>  5 s: 1 2 {"1 y

NB. mask matching (x) library name
mask=. *./"1 (<allwhitetrim x) -:&> allwhitetrim&.> 1 4 {"1 elts

NB. contributor links
mask # y
)


fmtdimlists=:4 : 0

NB.*fmtdimlists v-- format dlist label xref lists.
NB.
NB. Appends a column of xrefed dlists to cube sizes table (x).
NB.
NB. dyad:  bt =. dcs fmtdimlists dls

NB. dlist short name long name xref
s=. dimxref y

NB. short names replacing long dlist names
d=. ((<1 {"1 s) i.&.> 1 {"1 y) {&.> <0 {"1 s

NB. short names to char lists
d=. ,&.> (rjust&.> 4&s:@,&.> d) ,"1&.> '-'
d=. }:&.> d -.&.> ' '

NB. we need only one d
d=. (<'d= ') ,&.> d -.&.> 'd'

NB. append to cube sizes
x ,. (<'\n') ,&.> d
)


fmtdlistsizesxref=:3 : 0

NB.*fmtdlistsizesxref v-- formats dlist lengths xref.
NB.
NB. monad:  fmtdlistsizesxref btDls

dxf=. dimxref y
udls=. uniquedlistsizes y

NB. attach dlist lengths to xref symbol
dlens=. <"1 'p<[>q<]>' (8!:2) > ((; 0 {"1 udls) i. 1 {"1 dxf) { 1 {"1 udls
dsx=. s: (5 s: 0 {"1 dxf) ,&.> ' ' ,&.> dlens

NB. return xref bt
(dsx) (<a:;0)} dxf
)


fmtlinklabels=:4 : 0

NB.*fmtlinklabels v-- formats a single node subgraph that contains left justified link names.
NB.
NB. dyad:  clNode =. (btDcs;<btDls) fmtlinklabels slLinknames

NB. dcube and dlist size tables & contributor flag
'dcs dls'=. x
ctr=. 1

NB. dlist names with index prefix
dln=. allwhitetrim&.> <"1 ] 2 }."1 ;"1  (<': ') ,&.> 5 s: fmtdlistsizesxref dls

ll=. 5 s: y      NB. link names

NB. extract library model name
lb=. NLDSEP&beforestr NLDSEP&afterstr ,>0{0{dcs

NB. node suffix
sfx=. ',shape=plaintext, color=',TEXTNODECOLOR,', fontname=courier];'

NB. model summary
ms=. INDENT,'l0 [label="',lb,(modelsummary dcs;<dls),'"',sfx,LF

NB. dcube size statistics
dcs=. INDENT,'l1 [label="',lb,' DCube Sizes',(,'\n' ,"1 ] 0.1 dcubestat {:&> {:"1 dcs),'"',sfx,LF

NB. dlist length statistics
dls=.  ;&.> <"1 |: 1 2 {"1 dls
dls=. ,(~:>{."1 dls) # >{:"1 dls
dls=. INDENT,'l2 [label="',lb,' DList Lengths',(,'\n' ,"1 ] 0.1 dcubestat dls),'"',sfx,LF

NB. head=. 'subgraph cluster2 {',LF,'  node [style=filled, color=white];',LF
head=.''
NB. tail=. LF,INDENT,'label="',lb,' Model\n',(timestamp ''),'" fontsize=24;',LF,'  color=',EDGECOLOR,LF,'}'

NB. dlink names
ll=. 5 s: y

if. ctr do. 
  NB. all contributor model links should exists in one library 
  NB. if this is not the case do not peel library names
  lbcn=. NLDSEP&afterlaststr&.> NLDSEP&beforelaststr&.> ll
  lbcn=. ~.lbcn -. <lb 
  ctr=. ctr - 0<#lbcn
end.

NB. standard utility !(*)=. list
fl=. (,'\n' ,"1 ,. TEXTDLINKLABELWIDTH list (ljust ': ' ,"1~ ": ,. >:i.#ll) ,. >(NLDSEP&beforelaststr^:(1+ctr))&.> ll) ,'"'
fl=. INDENT,'l3 [label="',lb,' DLink Names',fl,sfx

NB. dlist names
if. ctr do.
  NB. determine common library name if it exists
  lbcn=. NLDSEP&afterlaststr&.> NLDSEP&beforelaststr&.> ,dln
  lbcn=. lbcn -. <lb
  if. 1=#~. lbcn do.
    lbc=. ;{.~.lbcn -. <lb
    lbc=. ''"_ `('\n Common Library: '&,)@.(0<#lbc) lbc
  else.
    NB. proper contributor models have lists from at most two libraries
    NB. if more are detected do not peal library names on dlists
    lbc=. '' [ ctr=. 0
  end.
  dl=. (lbc,,'\n' ,"1 TEXTDLISTLABELWIDTH list >  (NLDSEP&beforelaststr^:(1+ctr))&.> ,dln) , '"' 
else.
  dl=. (,'\n' ,"1 TEXTDLISTLABELWIDTH list > NLDSEP&beforelaststr&.> ,dln) , '"'  
end.
dl=. LF,INDENT,'l4 [label="',lb,' Dlist Names',dl,sfx

rn=. LF,INDENT,'{rank=same; l1; l2}'
head,ms,dcs,dls,fl,dl,rn,LF,INDENT,'l0 -> l1 -> l2 -> l3 -> l4 [color=',TEXTNODEARROWCOLOR,'];' NB. ,tail
)


labelfirstcsvobj=:3 : 0

NB.*labelfirstcsvobj  v--  labels the the first dcube,  dlist  or
NB. dlink in model csv.
NB.
NB. Analyst  8.4  print  CSVs have an annoying feature. The first
NB. object is  not  labeled  with a header  like  all  subsequent
NB. objects. I am sure there is some lame ass reason for this but
NB. it  complicates parsing. This verb  inspects the first object
NB. and labels it. The only valid labels applied are dcube, dlist
NB. and dlink.  Other types are not labeled but a header break is
NB. inserted so whatever it is can be parsed.
NB.
NB. monad:  cl =. labelfirstcsvobj clCsv

NB. extract any nonblank text before the first header
if. #fo=. alltrim CSVHEADER&beforestr y do.

  NB. inspect file type to determine what the object is
  fo=.  '.'&afterlaststr CRLF&beforestr 'Name of DOS file:,'&afterstr fo
  select. fo
    case. 'H1' do. CSVHEADER,'Type of object:,D-List',CRLF,y
    case. 'H2' do. CSVHEADER,'Type of object:,D-Cube',CRLF,y
    case. 'H8' do. CSVHEADER,'Type of object:,D-Link',CRLF,y
    case.      do. CSVHEADER,'Type of object:,NOTLABLED',CRLF,y
  end.

else.
  y
end.
)


labelsfrnld=:3 : 0

NB.*labelsfrnld v-- format DOT labels from nld symbols.
NB.
NB. monad:  cl =. labelsfrnld stNxf
NB. dyad:   cl =. (btCubesizes;clLabelmodifiers) labelsfrnld stNxf
NB.
NB.
NB.   NB. dcube size table
NB.   dcs=. dcubesizes dcubelistsizes srm
NB.
NB.   NB. append node modifier string to formatted labels
NB.   (dcs;' ,color=paleblue') labelsfrnld ncxf NB. see (dotdigraph)

('';'') labelsfrnld y
:
NB. cube size table and label modifier string
'dcs lbm'=. x

NB. extract only names from nld
names=. {."1 <;._1"1 NLDSEP ,. 4 s: 1 {"1 y

NB. full names more useful for pure analyst data flows
NB. names=. 5 s: 1 {"1 y

NB. NIMP check no quotes no \ chars 

NB. analyst object names are often long - insert breaks
wrp=. LABELWIDTH&wrapwords
names=. wrp&.> names
names=. (TAB,LF,TAB,'\n')&changestr&.> names

NB. append any matching cube dimension/sizes
if. #dcs do.

  NB. match cubes and reorder
  dcs=. ((s: 0 {"1 dcs) i. 1 {"1 y) { dcs , '';''

  NB. append dimension cell counts and dim lists
  dims=. allwhitetrim&.> <"1 ;"1 ] allwhitetrim &.> 1 2{"1 dcs
  names=. allwhitetrim&.> names ,&.> dims
end.

NB. label syntax with short xref node names
names=. dblquote names
labels=. (<' [label=') ,&.> names ,&.> <lbm,'];'
ctl >(<'  ') ,&.> (5 s: 0 {"1 y) ,&.> labels
)


linktargets=:4 : 0

NB.*linktargets v-- link source and target cubes.
NB.
NB. dyad:  bt linktargets blclCsv
NB.
NB.   lts=. hrm linktargets hrd  NB. see: parsemodelstruc

NB. link table
if. 0 e.$lnks=. 2 pick y do.
  0 3$s:<''  NB.  no dlinks 
else.
  tab=. ];._1 LF,lnks -. CR

  NB. filter table
  mask=. +./ ,&> (,:&.> LINKFILTERTYPES) (1&{."1)@:E.&.> <tab
  'invalid model data' assert +./mask
  tab=. rebtbcol mask#tab

  NB. link symbol name
  names=. (allwhitetrim&.> <"1 'Name:,'&afterstr"1 tab) -. a: 
  librs=. (allwhitetrim&.> <"1 'Library:,'&afterstr"1 tab) -. a: 
  names=. s: }."1 ;"1 NLDSEP ,&.>  names ,. librs ,. <'link'

  NB. check link names
  modellinks=. ; 0 {"1 [ 2 pick x
  'link name references invalid' assert names e. modellinks

  NB. targets and sources
  targets=. (allwhitetrim&.> <"1 'Target:,'&afterstr"1 tab) -. a: 

  NB. relabel any ODBC sources - ODBC sources
  NB. do not follow analyst naming conventions
  if. +./odbcmask=. 0 {"1 (,:'ODBC Datasource:,') E. tab do.  
    NB. DANGER WILL ROBINSON - using an offset to pull dsn,sql 
    dsn=. rebtbcol tab #~ _1 |.!.0 odbcmask

    NB. Count distinct sql statements - this count is only
    NB. an estimate of how many "different" sources as 
    NB. different sql could return the same result and
    NB. my test for sql syntax equivalence is naive.

    NB. A GOOD ANALYST MODEL SHOULD HAVE STANDARDIZED SQL
    NB. STATEMENTS IN LINKS - people should give up 
    NB. smoking as well.

    NB. WARNING: Cognos Analyst mangles the SQL in *.csv
    NB. files so even if this was a perfect sql equivalence 
    NB. it will still be misleading. (Feb 12, 2009)
    sql=. countsql <"1 (#'SQL Statement:,') }."1 tab #~ _2 |.!.0 odbcmask 
    
    odbctab=. '/Table:,/ODBC Datasource:,ODBC-Input 'changestr ctl dsn,.' ',. >0{"1 sql
    odbctab=. ('/',DOT,'/-/',NLDSEP,'/ ') changestr odbctab
    odbctab=. <;._2 tlf odbctab
    tab=. >odbctab (I. odbcmask) } <"1 tab
  end.
 
  NB. NIMP picks up standard Source: and ODBC Datasource:
  NB. NIMP look out for additional link sources (packages)
  sources=. (allwhitetrim&.> <"1 'ource:,'&afterstr"1 tab) -. a:

  NB. sources and targets must match
  'link sources and targets do not match' assert (#sources)=#targets

  modelcubes=. ; 0 {"1 [ 0 pick x

  NB. source and target to symbol form
  stt=. NLDSEP (I. DOT=SOURCETARGETTYPES)} SOURCETARGETTYPES
  targets=. (DOT,NLDSEP) refirstinrow >targets
  targets=. trimlibblanks targets
  targets=. <;.1"1 ];._1 LF, stt changestr ctl targets
  targets=. s: }."1 ;"1 |."1 allwhitetrim&.> targets
  NB. 'not all targets cubes in model' assert targets e. modelcubes

  sources=. (DOT,NLDSEP) refirstinrow >sources
  sources=. trimlibblanks sources
  sources=. <;.1"1 ];._1 LF, stt changestr ctl sources
  sources=. s: }."1 ;"1 |."1 allwhitetrim&.> sources
  NB. 'not all sources cubes in model' assert sources e. modelcubes

  names ,. sources ,. targets
end.
)

NB. left justify table
ljust=:' '&$: :(] |."_1~ i."1&0@(] e. [))


loadanalystmodel=:3 : 0

NB.*loadanalystmodel v-- gets/sets data for analyst models.
NB.
NB. monad:  loadanalystmodel blclCsvfiles
NB.
NB.   loadanalystmodel Expenses2009
NB.   loadanalystmodel Expenses2009prd
NB.   loadanalystmodel ExpensesDatamanagement
NB.
NB.   NB. graph from global noun
NB.   graphview dot
NB.
NB. dyad:  clPath loadanalystmodel blclCsvfiles

AnalystCsvPath loadanalystmodel y
:
path=. tslash x

NB. CSV data !(*)=. hrd hrm srm lts dot dotflt cst
hrd=: path loadmodelcsvs y

NB. set unknown sources and targets
UNKNOWNSOURCECUBES_analystgraphs_ =: ' UNKNOWN source cubes(s)'
UNKNOWNTARGETCUBES_analystgraphs_ =: ' UNKNOWN target cubes(s)'

NB. parsed model
hrm=: parsemodelstruc hrd
srm=: modelstruc hrm

NB. cube sizes table
cst=: dcubesizes dcubelistsizes srm

NB. DOT graph code
lts=: hrm linktargets hrd

NB. append in known CF links 
NB. lts=: BudgetCFLinks appendCFlts (srm;<lts)

NB. generate DOT code
NB. dotflt=: ((<hrm),'directed';'\n(filtered)') dotdigraph FRANKLIN_BUDGET_LIBNAME filterlinks lts
dot=: (hrm;DotGraphName) dotdigraph lts

'model loaded, see:'; ;:'hrd hrm srm lts dot cst'
)


loadcontributormodel=:3 : 0

NB.*loadcontributormodel   v--  gets/sets  data  for  contributor
NB. analyst models.
NB.
NB. Contributor models  are represented  by  at most two  analyst
NB. libraries: a  main library  and  an optional  common  objects
NB. library.  For diagram  generation  only  dlists are collected
NB. from the optional common library.
NB.
NB. monad:  loadcontributormodel blclCsvfiles
NB.
NB.   loadcontributormodel 'dev sales forecast model';'dev common'
NB.
NB.   NB. graph from global noun
NB.   graphview dot
NB.
NB. dyad:  clPath loadcontributormodel blclCsvfiles

AnalystCsvPath loadcontributormodel y
:
path=. tslash x

NB. CSV data !(*)=. hrd hrm srm lst dot dotflt cst
hrd=: (path;1) loadmodelcsvs y

NB. set unknown sources and targets
UNKNOWNSOURCECUBES_analystgraphs_ =: ' UNKNOWN source cubes(s)'
UNKNOWNTARGETCUBES_analystgraphs_ =: ' UNKNOWN target cubes(s)'

NB. parsed model
hrm=: parsemodelstruc hrd
srm=: modelstruc hrm

NB. cube sizes table
cst=: dcubesizes dcubelistsizes srm

NB. link source target table
lst=: hrm linktargets hrd

NB. remove link sources that are not in the main contributor library
lst=: lst #~ +./"1 (,:NLDSEP&beforestr NLDSEP&afterstr ,>0{0{cst) E. 4 s: 1 {"1 lst

NB. generate dot digraph code
dot=: (hrm;DotGraphName) dotdigraph lst

'model loaded, see:'; ;:'hrd hrm srm lst dot cst'
)


loadhrd=:[: ;&.> [: <"1 [: |: classifyobjs@:read&>


loadmodelcsvs=:4 : 0

NB.*loadmodelcsvs v-- loads analyst model csv.
NB.
NB. This verb  reads  CSV files  generated  by  printing all  the
NB. objects in a Cognos planning Analyst library.  Currently only
NB. dcubes, dlists and dlinks are used.
NB.
NB. dyad:  bt =. clPath loadmodelcsvs clLibcsv
NB.        bt =. clPath loadmodelcsvs blclLibcsvs
NB.        bt =. (clPath;paCtr) loadmodelcsvs clLibcsvs
NB.        bt =. (clPath;paCtr) loadmodelcsvs blclLibcsvs
NB.
NB.   NB. contributor with common library
NB.   (AnalystCsvPath;1) loadmodelcsvs 'dev sales forecast model';'dev common'

NB. set path and contributor flag
'path ctr'=. 2 {.!.(<0) boxopen x
path=. tslash path

NB. prefix path/ext to file names
y=. (<tslash path) ,&.> (boxopen y) ,&.> <CSVEXT

if. ctr do.
  NB. contributor models
  'cubes lists links'=. classifyobjs read ;0{y
  if. 2=#y do.
    NB. get only dlists
    comlists=. (1{0{DTYPES) classifyobjs read ;1{y
    lists=. lists, ;comlists
  end.
else.
  NB. general analyst libraries
  NB. NIMP dot diagram name should be set to first library
  'cubes lists links'=. classifyobjs ;labelfirstcsvobj@:read&.> y 
end.

NB. basic data sniff - require lists and cubes 
'no cubes or dlists' assert 0<(#cubes),#lists
'cube data suspect' assert 1 e. 'Type of object:,D-Cube' E. cubes
'list data suspect' assert 1 e. 'Type of object:,D-List' E. lists
if. #links do.
  'link data suspect' assert 1 e. 'Type of object:,D-Link' E. links
end.

NB. read csv data (cubes;lists;links)
cubes;lists;links
)

NB. mean value of a list
mean=:+/ % #

NB. median value of a list
median=:-:@(+/)@((<. , >.)@midpt { /:~)

NB. mid-point
midpt=:-:@<:@#


mode2=:3 : 0

NB.*mode2 v-- finds  the  most frequently occurring item(s) in  a
NB. list.
NB.
NB. monad:  ul =. mode2 ul
NB.
NB.   mode2 ?.500#100
NB.   mode2 ;:'I do what I do because I am what I am'

if. 0 < # y =. ,y do.     NB. null lists have no modes
  f =. #/.~ y             NB. nub frequency
  (~. y) #~ f e. >./ f    NB. highest frequency items
else. y
end.
)


modelstruc=:3 : 0

NB.*modelstruc v-- parsed model to full symbol representation.
NB.
NB. monad:  blSrm =. modelstruc blHrm
NB.
NB.    hrm=. parsemodelstruc hrd  
NB.    srm=. modelstruc hrm

'cubes lists links'=. y
if. #cubes do. cubes=. (nlduses&.> 1 {"1 cubes) (<a:;1)} cubes end.
if. #lists do. lists=. (nlduses&.> 1 {"1 lists) (<a:;1)} lists end.
if. #links do. links=. (nlduses&.> 1 {"1 links) (<a:;1)} links end.
cubes;lists;<links
)


modelsummary=:3 : 0

NB.*modelsummary v-- model summary statistics.
NB.
NB. monad:  cl=. modelsummary (btDcs;<btDls)

'dcs dls'=. y
cb=. ":#dcs
cc=. ,'c' (8!:2) +/ {:&> {:"1 dcs
ms=. ,(>'\nCubes      ';'\nTotal Cells') ,. '  ' ,"1 rjust >cb;cc
' Summary',ms
)


nld=:4 : 0

NB.*nld -- parse analyst name library data type.
NB.
NB. Every  object in the Analyst universe is  uniquely identified
NB. by the combination of Name, Libary and Datatype.
NB.
NB. dyad:  sl =. clType nld clCsv
NB.
NB.   NB. read Cognos Blueprint HR model data
NB.   hrd=. 'c:\temp' loadmodelcsvs 'hr planning cubes';'hr planning lists';'hr planning links'
NB.   cubes=. 'cube' nld 0 pick hrd

NB. extract names and libraries
names=. allwhitetrim&.> ('Name:,';'Library:,') betweenstrs y
libs=.  allwhitetrim&.> ('Library:,';'Created:,') betweenstrs y
'name and library list lengths not equal' assert (#names)=#libs
msg=. '"',NLDSEP,'" characters embedded in names or libraries'
msg assert -. NLDSEP e. (;names),;libs

NB. datatype suffix
s: names ,&.> NLDSEP ,&.> libs ,&.> NLDSEP ,&.> <x
)


nlduses=:3 : 0

NB.*nlduses v-- convert (hrm) tables to standard (nld) names.
NB.
NB. monad:  nldformat ctHrm

NB. cube, link or list
if. 0 e. $y do. y 
else.
  types=. TYPEWIDTH {."1 y
  types=. <"1 types
  'invalid DTYPES' assert types e. 0{DTYPES
  types=. ((0{DTYPES) i. types){1{DTYPES
  types=. NLDSEP ,&.> types

  NB. drop types and use suffix
  libnames=. ljust TYPEWIDTH }."1 y
  nlds=. ','&beforestr"1 libnames
  uses=. s: ','&afterlaststr"1 libnames

  NB. nld order - "." embedded in analyst ouputs
  NB. there should be a leading "." on each row
  'leading "." missing in some names' assert 1 <: +/"1 nlds=DOT

  NB. replace leading "." with (NLDSEP)
  nlds=. (DOT,NLDSEP) refirstinrow nlds

  NB. cut on (NLDSEP)
  cn=. |."1 <;.1"1 NLDSEP ,. nlds
  nlds=. allwhitetrim&.> cn ,. types
  nlds=. s: }."1 ;"1 nlds
  nlds ,. uses
end.
)


nodexref=:3 : 0

NB.*nodexref v-- labels source-target digraphs.
NB.
NB. monad:  nodexref stSourcetarget
NB.         nodexref su
NB.
NB.   lts=. hrm linktargets hrd 
NB.   nxf=. nodexref 1 2 {"1 lts
NB.
NB. dyad:  iaStart nodexref slCubes
NB. 
NB.   10 nodexref s:' cube0 cube1 cube2'
 
0 nodexref y 
:
un=. ~. ,y   NB. unique nodes

NB. short name full xref 
(s: 'n_' ,"1 ljust ": ,. x + i. #un) ,. un
)

NB. cut analyst csv data into object lists
objlist=:] <;.1~ 'Type of object:,' E. ]

NB. extract object users from analyst csv
objusers=:[: allwhitetrim&.> [: 'No.,IID'&beforestr&.> 'User object,Usage'&afterstr&.>

NB. returns bt of nld objects names that use given objects
objusertab=:([: <"0 [ nld [: ; ]) ,. [: userstab&.> [: objusers ]


parsemodelstruc=:3 : 0

NB.*parsemodelstruc v-- parse analyst csv data and extract model structure.
NB.
NB. monad:  bt =. parsemodelstruc (clCubes ; clLists ; clLinks)
NB.
NB.   NB. read Cognos Blueprint HR model data
NB.   hrd=. 'c:\temp' loadmodelcsvs 'hr planning cubes';'hr planning lists';'hr planning links'
NB.   hrm=. parsemodelstruc hrd

'cubes lists links'=. y

if. #cubes do. cubemd=. parseusertab 'cube' objusertab objlist cubes else. cubemd=. cubes end.

if. #lists do.
  NB. collect lengths of dlists 
  lists=.   objlist lists
  lengths=. dlistsize lists
  'D-List lengths invalid' assert ,0<lengths

  listmd=.  (parseusertab 'list' objusertab lists) ,. <"0 lengths
else. 
  listmd=. lists
end.

if. #links do. 
  linkstext=. objlist links
  linkmd=.  parseusertab 'link' objusertab linkstext

  NB. extract any ODBC source sql 
  if. +./ 'ODBC Datasource:,' E. ;linkstext do.
    sql=. allwhitetrim&.> ('SQL Statement:,';'Driver options:,')&betweenstrs&> linkstext
    dsn=. allwhitetrim&.> ('Table:,';'SQL Statement:,')&betweenstrs&> linkstext
    'sql and dsn mismatch' assert  (1 <: #&> ,sql) -: 1 <: #&> ,dsn

    NB. dequote " when only two quotes detected
    sql=. ]`([: '"'&afterstr '"'&beforelaststr)@.(2 = [: +/ '"'&=)&.> sql

    linkmd=. linkmd ,. dsn ,. sql
  end.
  
else. 
  linkmd=. links 
end.

cubemd;listmd;<linkmd
)


parseusertab=:3 : 0

NB.*parseusertab v-- parse user object tables
NB.
NB. monad:  bt =. parseusertab ct

ut=. 1 {"1 y
ut=. ut #&.>~ dlmask&.> ut
(0 {"1 y) ,. ut
)


pcdigraph=:3 : 0

NB.*pcdigraph v-- generates dot code from parent child tables.
NB.
NB. monad:  clDot =. pcdigraph stPC
NB.
NB.   NB. parent child table from hierarchy band table
NB.   pc=. hiertopc (readtd 'c:\wd\franklin\dataexamples\FFS E-list.txt') -.&.> '"'
NB.
NB.   dot=. pcdigraph s: pc
NB.
NB. dyad:   clDot =. clName pcdigraph stPC

'pctable' pcdigraph y
:
NB. topological link source target
lts=. sortlts _3 {."1 y

NB. source/target
st=. 1 2 {"1 lts

NB. link names
ln=. 0 {"1 lts

NB. short labels long name xref
nxf=. nodexref st

NB. map nodes to short forms
dg=. ((1 {"1 nxf) i.st) { 0 {"1 nxf

NB. link labels
ll=. s: (<' "]') ,&.>~  (<' [dir=back, label=" ') ,&.> ":&.> <"0 >: i. # dg

NB. dot node connection syntax
dg=. (0 3 1 2 4) {"1 (dg ,. ll) ,"1  s: '->';'; //L: '
dg=. dg ,. ln
dg=. ctl ;"1 (<'  ') ,. (5 s: dg) ,&.> ' '

NB. format node lables
dg=. dg,LF,labelsfrnld nxf

NB. graph header/trailer
hdr=. 'digraph ',(alltrim x),' {',LF,'subgraph cluster1 {',LF,'  ordering=out;',LF
hdr=. hdr,'  node [style=',NODESTYLE,', color=',INTERIORCOLOR,'];',LF
tr=. LF,'}',LF,'}'

hdr,dg,tr
)

NB. select and disclose array items
pick=:>@{

NB. first quartile
q1=:median@((median > ]) # ]) ::_:

NB. third quartile
q3=:median@((median < ]) # ]) ::_:

NB. reads a file as a list of bytes
read=:1!:1&(]`<@.(32&>@(3!:0)))


reb=:3 : 0

NB.*reb v-- removes redundant blanks - leading, trailing multiple
NB.
NB. monad:  reb cl
NB. dyad:  ua reb ul

' ' reb y
:
y=. x , y
b=. x = y
}.(b*: 1|.b)#y
)

NB. remove trailing blank columns
rebtbcol=:] #"1~ [: -. [: *./ [: *./\."1 ' '&=


refirstinrow=:4 : 0

NB.*refirstinrow v-- replace first (0{x) occurrence in row(s) of (y) with (1{x) 
NB.
NB. dyad:   ct =. clrn refirstinrow ct
NB.
NB.   'n*'  refirstinrow  7 5$'***n     '

c=. y i."1 ] 0{x
b=. c < {:$ y
(1{x) (<"1 b # (i.#y) ,. c) } y
)


requoted=:4 : 0

NB.*requoted v-- replaces atoms in "quoted" lists.
NB.
NB. Replaces all (1{x) in simple nonnested atom runs delimited by
NB. (0{x) with (2{x).
NB.
NB. dyad:  ulRep =. uaQuoteCharRep requoted ul
NB.
NB.   NB. replace ,'s in " delimited characters
NB.   ('",',1{a.) requoted 'this , "damm quoted comma , screws up my" , based parsing'
NB.
NB.   NB. numeric quotes
NB.   1 2 9 requoted 0 0 0 1 2 3 1 0 1 2 2 2 1 0

NB. quote, atom, replacement (must be distinct)
'q c r'=. x

if. +./b=. q=y do.
  'unbalanced quotes' assert 0=2|+/b
  
  NB. replacements
  p=. I. (c=y) *. ~:/\b
  r p} y
else.
  y
end.
)

NB. right justify table
rjust=:' '&$: :(] |."_1~ +/"1@(-.@(<./\."1@([ = ]))))

NB. round y to nearest x (e.g. 1000 round 12345)
round=:[ * [: <. 0.5 + %~


sortlts=:3 : 0

NB.*sortlts v-- topological sort of link-source-target table.
NB.
NB. monad:  sortlts stLts
NB.
NB.   sortlts lts

st=. 1 2 {"1 y           NB. source target
uc=. ~. , st             NB. unique cube list
suc=. (topsort st){uc    NB. sorted cubes
y {~ /: suc i. 1 {"1 y   NB. sorted table
)

NB. sum of square deviations (2)
ssdev=:+/@:*:@dev

NB. standard deviation (alternate spelling)
stddev=:%:@:var


timestamp=:3 : 0

NB.*timestamp v-- formats timestamp as dd mmm yyyy hr:mn:sc
NB.
NB. monad:  cl =. timestamp zu | nlTime
NB. 
NB.   timestamp ''              NB. empty now
NB.   timestamp 2007 9 16       NB. fills missing
NB.   timestamp 1953 7 2 12 33   

if. 0 = #y do. w=. 6!:0'' else. w=. y end.
r=. }: $ w
t=. 2 1 0 3 4 5 {"1 [ _6 [\ , 6 {."1 <. w
d=. '+++::' 2 6 11 14 17 }"1 [ 2 4 5 3 3 3 ": t
mth=. _3[\'   JanFebMarAprMayJunJulAugSepOctNovDec'
d=. ,((1 {"1 t) { mth) 3 4 5 }"1 d
d=. '0' (I. d=' ') } d
d=. ' ' (I. d='+') } d
(r,20) $ d
)

NB. appends trailing line feed character if necessary
tlf=:] , ((10{a.)"_ = {:) }. (10{a.)"_

NB. topological sort of unique source target connection table nodes
topsort=:\:@:(+/"1@:(tranclose@:adjfrct))


toupper=:3 : 0

NB.*toupper v-- convert to upper case
NB.
NB. monad:  cl =. toupper cl

x=. I. 26 > n=. ((97+i.26){a.) i. t=. ,y
($y) $ ((x{n) { (65+i.26){a.) x}t
)

NB. computes a transitive closure
tranclose=:(+. +./ .*.~)^:_

NB. transitive closure
tranclose2=:# (i.~ {. ]) [: }. (, #) {~^:a: 0:


trimlibblanks=:3 : 0

NB.*trimlibblanks  v--  remove  multiple  leading   library  name
NB. blanks.
NB.
NB. I use blanks to move active libraries to the front of analyst
NB. library lists. It makes it easiar to pick out the few you are
NB. working  on  in  long  lists.  These  extra  blanks  are  not
NB. significant  in the  names generated by (nld)  and have to be
NB. removed.
NB.
NB. monad:  ct =. trimlibblanks ct

names=. <"1 y
>((' '&beforestr)&.> names) ,&.> ' ' ,&.> alltrim@:(' '&afterstr)&.> names
)

NB. appends trailing \ character if necessary
tslash=:] , ('\'"_ = {:) }. '\'"_


uniquedlistsizes=:3 : 0

NB.*uniquedlistsizes v-- bt of unique dlist nld names and lengths.
NB.
NB. monad:  uniquedlistsizes btDls
NB. 
NB.   dls=. dcubelistsizes srm
NB.   uniquedlistsizes dls

'lists sizes'=. |: <"1&.> 1 2 {"1 y
udls=. /:~  ~. (,lists) ,. ,sizes

NB. remove empty items
udls #~ +./"1 #&> udls
)


uniquesql=:3 : 0

NB.*uniquesql v-- unique sql statements from (hrm).
NB.
NB. monad:  btcl =. uniquesql blHrm
NB.
NB.   hrm=. parsemodelstruc hrd
NB.   uniquesql hrm

if. #y do.
  sql=. 3 {"1 [ 2 pick y
  sql=. countsql ~.sql -. <''
  /:~ (~: 0 {"1 sql)#sql
else.
  0 2$''
end.
)

NB. formats object users table
userstab=:[: ];._1 (10{a.) , (13{a.) -.~ ]

NB. var
var=:ssdev % <:@#


wrapwords=:4 : 0

NB.*wrapwords v-- wrap words into lines of length (x).
NB.
NB. This algorithm: due to Roger Hui. Wraps words (nonblank) runs
NB. into lines of length (x) without breaking words. Words cannot
NB. be longer  than (x).  Transitive closure  is used to  compute
NB. where appropriate newline (LF) characters replace blanks.
NB.
NB. dyad:  cl =. iaWidth wrapwords clWords
NB.
NB.   27 wrapwords 7770$'go ahead make my day and surprise me'

NB. remove extra blanks and CRLF
y=. reb y -. CRLF

e=. (' ' I.@:= y),#y
LF (e {~ <: tranclose2 e I. (x+2)+}:_1,e)} y
)

NB. writes a list of bytes to file
write=:1!:2 ]`<@.(32&>@(3!:0))

NB.*POST_analystgraphs s-- postprocessor.

smoutput 0 : 0 
NB. root word(s):
NB.  loadanalystmodel      NB. gets/sets data for analyst models
NB.  loadcontributormodel  NB. gets/sets data for contributor analyst models
)

cocurrent 'base'
coinsert 'analystgraphs' 

