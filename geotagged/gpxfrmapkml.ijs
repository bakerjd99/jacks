NB.*gpxfrmapkml s-- convert Google Maps download kml to gpx.
NB.
NB. for more details see - verbatim:
NB.
NB. http://bakerjd99.wordpress.com/2012/05/16/gpx-from-google-maps-kml-j-script/
NB. 
NB. interface word(s): 
NB. ------------------------------------------------------------------------------                                 
NB. gpxfrmapkml - gpx from Google maps kml 
NB. nearestgpx  - gpx locations within (y) kilometers on one waypoint                                   
NB.                                                         
NB. created: 2012May16
NB. ------------------------------------------------------------------------------
NB. 12may29 added (nearestgpx)
NB. 13dec22 saved in (jacks) GitHub repo

require 'regex'

coclass 'gpxfrmapkml' 

NB.*dependents
NB. (*)=: GPXFRKMLHEADER GPXSMUGPLACEMARK GPXTRAILER
NB.*enddependents

GPXFRKMLHEADER=: 0 : 0
<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<gpx
version="1.1"
creator="J GPX from Google Maps KML script"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns="http://www.topografix.com/GPX/1/1"
xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
<metadata>
<name>{{headername}}</name>
<desc>{{headerdescription}}</desc>
<link href="http://bakerjd99.wordpress.com/">
<text>Analyze the Data not the Drivel</text>
</link>
</metadata>
)

GPXSMUGPLACEMARK=: 0 : 0
<wpt lat="{{latitude}}" lon="{{longitude}}">
<ele>0</ele>
<name>{{phototitle}}</name>
</wpt>
)

GPXTRAILER=: 0 : 0
<extensions>
</extensions>
</gpx>
)
NB.*end-header

NB. regular expression matching placeholder variables in html lists
HTMLVARBPATTERN=:'{{[a-z]*}}'

NB. interface words (IFACEWORDSgpxfrmapkml) group
IFACEWORDSgpxfrmapkml=:<;._1 ' gpxfrmapkml nearestgpx'

NB. root words (ROOTWORDSgpxfrmapkml) group      
ROOTWORDSgpxfrmapkml=:<;._1 ' IFACEWORDSgpxfrmapkml ROOTWORDSgpxfrmapkml gpxfrmapkml nearestgpx read write'

NB. retains string (y) after last occurrence of (x)
afterlaststr=:] }.~ #@[ + 1&(i:~)@([ E. ])

NB. retains string after first occurrence of (x)
afterstr=:] }.~ #@[ + 1&(i.~)@([ E. ])

NB. trims all leading and trailing blanks
alltrim=:] #~ [: -. [: (*./\. +. *./\) ' '&=

NB. trims all leading and trailing white space
allwhitetrim=:] #~ [: -. [: (*./\. +. *./\) ] e. (9 10 13 32{a.)"_

NB. arc tangent
arctan=:_3&o.

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))

NB. extracts text of xml attribute
attrvalue=:'"'"_ beforestr ([ , '="'"_) afterstr '>'"_ beforestr ]

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

NB. cosine radians
cos=:2&o.


earthdist=:4 : 0

NB.*earthdist v-- distance in km between n points on the Earth's surface.
NB.
NB. dyad:  (fl | ft) earthdist (fl | ft)
NB. 
NB.   NB. Paris longitude, latitude
NB.   NB. ddfrdms computes decimal degrees from degree, minutes, seconds
NB.   l1     =. ddfrdms _2 _20 _14    NB.  2d 20m 14s (East)
NB.   theta1 =. ddfrdms 48 50 11      NB. 48d 40m 11s (North)
NB.
NB.   NB. Washington
NB.   l2     =. ddfrdms 77 3 56       NB. 77d  3m 56s (West)
NB.   theta2 =. ddfrdms 38 55 17      NB. 38d 55m 17s (North)
NB.
NB.   NB. rounded to 2 decimals matches Meeus
NB.   6181.63 = ". '0.2' 8!:2 (l1,theta1) earthdist l2,theta2
NB.
NB.   NB. table arguments
NB.   (|: 5 # ,: l1,theta1) earthdist |: 5 # ,: l2,theta2

a=.  6378.14      NB. Earth's mean radius (km)
fl=. % 298.257    NB. Earth's flattening (a * 1 - fl) is polar radius

NB. zero distances mask
b=.  *./ x = y

NB. longitudes and latitudes in decimal degrees
NB. western longitudes +, northern latitudes +
NB. (*)=. l1 l2 theta1 theta2
'l1 theta1'=.  x [ 'l2 theta2'=. y

f=.      rfd -: theta1 + theta2
g=.      rfd -: theta1 - theta2
lambda=. rfd -: l1 - l2

sqrsin=. *: @ sin
sqrcos=. *: @ cos

sinlam=.  sqrsin lambda [ coslam=. sqrcos lambda
sqrcosg=. sqrcos g [ sqrsing=. sqrsin g
sqrsinf=. sqrsin f [ sqrcosf=. sqrcos f

s=. (coslam * sqrsing) + sinlam * sqrcosf
c=. (coslam * sqrcosg) + sinlam * sqrsinf

omega=. arctan %: s % c
r3=. 3 * (%: s * c) % omega
d=.  +: omega * a
h1=. (<: r3) % +: c
h2=. (>: r3) % +: s

NB. required distance
d=. d * (>: fl*h1*sqrsinf*sqrcosg) - fl*h2*sqrcosf*sqrsing

NB. handle any zero distances
if. +./ b do.
  NB. cannot do b*d as d is undefined _. for zero distances
  if. #$ d do. 0 (I. b)} d elseif. b do. 0 elseif. 1 do. d end.
else.
  d
end.
)

NB. get pure element text
geteletext=:] betweenstrs~ [: tags [: alltrim [


gpxfrmapkml=:3 : 0

NB.*gpxfrmapkml v-- gpx from Google maps kml.
NB.
NB. monad:  clGpx =. gpxfrmapkml clKml
NB.
NB.   NB. download Google map waypoints as kml
NB.   kml=. read 'c:/temp/arizona annular eclipse.kml'
NB.
NB.   NB. convert to gpx and save
NB.   gpx=. gpxfrmapkml kml
NB.   gpx write 'c:/temp/arizona annular eclipse.gpx'  

NB. parse kml form waypoint table
dname=. ;'name' geteletext '<Placemark>' beforestr y
wpt=.   ;'Placemark' geteletext y
wpt=.   ('name' geteletext wpt) ,. <;._1&> ','&,&.> 'coordinates' geteletext wpt
hdr=.   ;:'phototitle longitude latitude'

NB. format gpx header 
gpxstamp=. 'Waypoints: ',(":#wpt),' GPX generated: ',timestamp''
gpxheader=. ('/{{headername}}/',dname,'/{{headerdescription}}/',gpxstamp) changestr GPXFRKMLHEADER
gpxtrailer=. GPXTRAILER

'idx pkml'=. HTMLVARBPATTERN patpartstr GPXSMUGPLACEMARK
rvarbs=. idx htmlvarbs pkml

NB. all row varibles must exist in data header
assert. *./ rvarbs e. hdr
rows=. (#wpt) # ,: pkml
rows=. ((hdr i. <'phototitle'){"1 wpt) (<a:;(rvarbs i. <'phototitle'){idx)} rows
rows=. ((hdr i. <'latitude'){"1 wpt) (<a:;(rvarbs i. <'latitude'){idx)} rows
rows=. ((hdr i. <'longitude'){"1 wpt) (<a:;(rvarbs i. <'longitude'){idx)} rows

gpxheader,(;rows),gpxtrailer
)

NB. extract html placeholder variable names
htmlvarbs=:{ -.&.> (<'{}')"_


nearestgpx=:4 : 0

NB.*nearestgpx  v--  gpx locations within (y)  kilometers  of one
NB. waypoint.
NB.
NB. Returns all waypoints in a gpx file within (0{x)  kilometers.
NB. If (4{x) is supplied at most  (<.4{x) waypoints within  (0{x)
NB. kilometers  are selected.  The result is a reduced  gpx file.
NB. Many GPS devices can only hold a limited number of waypoints.
NB.
NB. dyad:  clGpx =. flKmLbN nearestgpx clGpx
NB.
NB.   gpx=. read 'c:/pd/coords/poi/geotagged smugmug images.gpx'
NB.
NB.   NB. within 500 km of St. Louis apartment
NB.   gpx2=. 500 38.67648 _90.443777 nearestgpx gpx
NB.
NB.   NB. at most 100 nearest waypoints of St. Louis apartment within 500 km
NB.   gpx3=. 500 38.67648 _90.443777 10 nearestgpx gpx

'radius lat lon cnt'=. 4{.x
cnt=. <. | cnt [ radius=. |radius
wbeg=. '<wpt '
head=. wbeg&beforestr y
tail=. '</wpt>'&afterlaststr y
body=. (#head) }. (-#tail) }. y
body=. (wbeg E. body) <;.1 body
lb=. _999&".&> ('lat'&attrvalue ; 'lon'&attrvalue) &> body
'invalid latitude/longitude value(s)' assert -. _999 e. lb

NB. gpx latitude, longitude to Meeus (+northern lat), (+west lon)
km=. ((#lb) #"1 ,. 1 _1 * lat,lon) earthdist 1 _1 * |: lb

NB. sort by distance
ord=. /:km
km=. ord{km [ body=. ord{body

NB. retain at most (cnt) within (radius)
body=. (cnt&{.)`]@.(cnt=0) (radius >: km) # body
head,(allwhitetrim ;body),tail
)


patpartstr=:4 : 0

NB.*patpartstr v-- split list into sublists of pattern and non-pattern.
NB.
NB. dyad:  (ilIdx ;< blcl) =. clPattern patpartstr clStr
NB.
NB.   'hoo' patpartstr 'hoohoohoo'  
NB.   'ab.c' patpartstr   'abhc yada yada abNcabuc boo freaking hoo'
NB.   'nada' patpartstr 'nothing to match'
NB.
NB.   NB. result pattern indexes and split list
NB.   'idx substrs'=. 'yo[a-z]*'  patpartstr 'yo yohomeboy no no yoman'
NB.   idx{substrs  NB. patterns

NB. require 'regex' !(*)=. rxmatches
if. #pat=. ,"2 x rxmatches y do.
  mask=. (#y)#0
  starts=. 0 {"1 pat
  ends=. starts + <: 1 {"1 pat
  m1=. 1 (0,starts)} mask 
  m2=. _1 (|.!. 0) 1 ends} mask 
  m2=. m1 +. m2 
  mask=. 1 starts} mask
  idx=. (m2 {.;.1 mask) # i. +/m2       
  idx;< m2 <;.1 y
else.
  (i.0);<<y
end.
)

NB. reads a file as a list of bytes
read=:1!:1&(]`<@.(32&>@(3!:0)))

NB. radians from degrees
rfd=:*&0.017453292519943295

NB. sine radians
sin=:1&o.

NB. xml BEGIN and END tags
tags=:'<'&,@,&'>' ; '</'&,@,&'>'


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

NB. writes a list of bytes to file
write=:1!:2 ]`<@.(32&>@(3!:0))

NB.POST_gpxfrmapkml post processor 

smoutput 0 : 0
NB. interface word(s):
NB.  gpxfrmapkml  NB. gpx from Google maps kml
NB.  nearestgpx   NB. gpx locations within (y) kilometers of one waypoint
)

cocurrent 'base'
coinsert  'gpxfrmapkml'