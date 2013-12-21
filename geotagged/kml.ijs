NB.*kml s-- words for manipulating GoogleEarth kml/gpx documents.
NB. 
NB. verbatim:
NB.
NB. http://bakerjd99.wordpress.com/2009/10/04/google-earth-image-touring/
NB.
NB. interface word(s):
NB. ------------------------------------------------------------------------------                                 
NB. geotaggedfrtab -- generates kml document referencing geotagged smugmug images
NB. geotaggpxfrtab -- generates gpx document using geotagged image locations                                            
NB.                                                          
NB. author:  John D. Baker  
NB. created: 2007jun21
NB. -------------------------------------------------------------------------
NB. 07jun21 code extracted from (flickr) group 
NB. 09sep25 converted from (smugmug)
NB. 09sep30 fixed waypoint order within galleries (nearestnew)
NB. 09oct01 move kml snippets to group header
NB. 09oct02 touring code added 
NB. 09oct05 grand tour of all locations added
NB. 09dec05 (clip1char) hack to remove ' 1' suffixes from album name
NB. 10feb01 modified to use tab delimited files
NB. 11oct19 gpx verbs added
NB. 13dec20 saved in (jacks) GitHub repo

NB. (9!:41) 0  NB. 0 removes white space 1 (default) retains
require 'regex'

coclass 'kml' 

NB.*dependents
NB. (*)=: KMLALBUMHEADER KMLALBUMTRAILER KMLHEADER KMLTRAILER KMLSMUGPLACEMARK
NB. (*)=: KMLSMUGTOURANIMATION KMLTOURHEADER KMLTOURTRAILER GPXHEADER GPXSMUGPLACEMARK GPXTRAILER
NB.*enddependents

NB. kml/gpx snippets defined in header so they display as standard text
KMLALBUMHEADER=: 0 : 0
<Folder>
  <name>{{smugmugalbumname}}</name>
  <open>0</open>
)

KMLALBUMTRAILER=: 0 : 0
</Folder>
)

KMLHEADER=: 0 : 0
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
<name>Geotagged SmugMug Images</name>
)

KMLTRAILER=: 0 : 0
</Document>
</kml>
)

KMLSMUGPLACEMARK=: 0 : 0
<Placemark id="{{pmida}}">
    <name>{{phototitle}}</name>
    <Snippet maxLines="1"></Snippet>
    <description><![CDATA[<p>
   
  <a href='{{albumurla}}/'>
   <img src= '{{mediumphotourl}}'/>
  </a>
  <br />
  
  <a href='{{albumurlb}}/'>View in SmugMug gallery</a>
  <br />
  
  </p>]]>
    </description>
    <LookAt>
      <longitude>{{longitude}}</longitude>
      <latitude>{{latitude}}</latitude>
      <range>{{range}}</range>
      <tilt>{{tilt}}</tilt>
      <heading>{{heading}}</heading>
    </LookAt>
    <Style>
      <IconStyle>
        <Icon>
          <href>{{iconurl}}</href>
        </Icon>
      </IconStyle>
    </Style>
    <Point>
      <extrude>1</extrude>
      <altitudeMode>relativeToGround</altitudeMode>
      <coordinates>{{viewpoint}}</coordinates>
    </Point>
</Placemark>
)

KMLSMUGTOURANIMATION=: 0 : 0
<gx:FlyTo>
    <gx:duration>{{flytoduration}}</gx:duration>
    <LookAt>
      <longitude>{{longitude}}</longitude>
      <latitude>{{latitude}}</latitude>
      <range>{{range}}</range>
      <tilt>{{tilt}}</tilt>
      <heading>{{heading}}</heading>
    </LookAt>
</gx:FlyTo>
<gx:AnimatedUpdate>
    <Update>
      <targetHref></targetHref>
      <Change>
        <Placemark targetId="{{pmida}}">
          <gx:balloonVisibility>1</gx:balloonVisibility>
        </Placemark>
      </Change>
    </Update>
</gx:AnimatedUpdate>
<gx:Wait><gx:duration>{{picturewait}}</gx:duration></gx:Wait>
<gx:AnimatedUpdate>
    <Update>
      <targetHref></targetHref>
      <Change>
        <Placemark targetId="{{pmidb}}">
          <gx:balloonVisibility>0</gx:balloonVisibility>
        </Placemark>
      </Change>
    </Update>
</gx:AnimatedUpdate>
<gx:Wait><gx:duration>{{endwait}}</gx:duration></gx:Wait>
)

KMLTOURHEADER=: 0 : 0
<gx:Tour>
    <name>{{smugmugalbumname}}</name>
    <gx:Playlist>
)

KMLTOURTRAILER=: 0 : 0
    </gx:Playlist>
</gx:Tour>
)

GPXHEADER=: 0 : 0
<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<gpx
version="1.1"
creator="J GPX from TAB delimited script"
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

GPXTRAILER=: 0 : 0
<extensions>
</extensions>
</gpx>
)

GPXSMUGPLACEMARK=: 0 : 0
<wpt lat="{{latitude}}" lon="{{longitude}}">
<ele>0</ele>
<name>{{phototitle}}</name>
</wpt>
)
NB.*end-header

NB. Google Earth wait after closing image
ENDWAITDEFAULT=:2

NB. Google Earth flyto next waypoint time in seconds
FLYTODURATIONDEFAULT=:6.5

NB. default viewpoint heading
HEADINGDEFAULT=:0

NB. regular expression matching placeholder variables in html lists
HTMLVARBPATTERN=:'{{[a-z]*}}'

NB. interface words (kml) group
IFACEWORDSkml=:<;._1 ' geotaggedfrtab geotaggpxfrtab'

NB. name of all images folder
KMLALLFOLDER=:'Geotagged SmugMug Images'

NB. image marker icon url
KMLICONURL=:'http://conceptcontrol.smugmug.com/photos/667062389_p3aEh-M-1.png'

NB. default (within gallery) duplicate url handling
KMLNODUPLICATES=:1

NB. default smugmug hidden image handling
KMLREMOVEHIDDEN=:1

NB. data element names required for geotagged smugmug image kml generation
KMLSMUGPLACEMARKVARBS=:<;._1 ' phototitle latitude longitude albumurla albumurlb mediumphotourl range tilt heading iconurl viewpoint pmida'

NB. line feed character
LF=:10{a.

NB. Google Earth wait in seconds while image is displayed
PICTUREWAITDEFAULT=:5

NB. default view range
RANGEDEFAULT=:2000

NB. root words (kml) group
ROOTWORDSkml=:<;._1 ' geotaggedfrtab write ROOTWORDSkml IFACEWORDSkml'

NB. name of TAB delimited SmugMug album table file
SMUGALBUMTABLE=:'smugalbumtable.txt'

NB. name of TAB delimited SmugMug image table file
SMUGIMAGETABLE=:'smugimagetable.txt'

NB. directory containing SmugMug data files
SMUGTABLEDIR=:'c:\pd\docs\smugmug\data\'

NB. default view tilt
TILTDEFAULT=:60

NB. retains string (y) after last occurrence of (x)
afterlaststr=:] }.~ #@[ + 1&(i:~)@([ E. ])

NB. trims all leading and trailing blanks
alltrim=:] #~ [: -. [: (*./\. +. *./\) ' '&=

NB. arc tangent
arctan=:_3&o.

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))

NB. retains string (y) before last occurrence of (x)
beforelaststr=:] {.~ 1&(i:~)@([ E. ])


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

NB. hack to remove trailing ' 1' suffixes from album names
clip1char=:] }.~ _2 * ' 1' -: _2 {. ]

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


formatsmugtabdata=:4 : 0

NB.*formatsmugtabdata  v-- converts smugtable  to format required
NB. for kml generation.
NB.
NB. dyad:  btcl =. clIconurl formatsmugtabdata (<blclHeader),<btclSmugtable

'imhead smugdat'=. y

if. #smugdat do.

  NB. kml columns
  NB. (phototitle latitude longitude albumurla albumurlb mediumphotourl) range tilt heading iconurl viewpoint pmida
  dat=. ((#smugdat),#KMLSMUGPLACEMARKVARBS)$a:

  NB. use SmugMug image id number to uniquely mark waypoints
  pid=. (imhead i. <'PID') {"1 smugdat
  dat=. pid (<a:;KMLSMUGPLACEMARKVARBS i. <'pmida')} dat

  NB. check latitude longitude
  pos=. imhead i. ;:'LATITUDE LONGITUDE'
  lb=. pos {"1 smugdat
  'invalid latitude longitude' assert -. _999 e. _999&".&> lb
  dat=. lb (KMLSMUGPLACEMARKVARBS i. ;:'latitude longitude')}"1 dat

  NB. filenames to titles
  pos=. KMLSMUGPLACEMARKVARBS i. <'phototitle'
  dat=. (titlesfrfilenames (imhead i. <'FILENAME') {"1 smugdat) (<a:;pos)} dat

  NB. copy album urls
  pos=. KMLSMUGPLACEMARKVARBS i. ;:'albumurla albumurlb'
  dat=. ((2#imhead i. <'ALBUMURL') {"1 smugdat) pos}"1 dat
  pos=. KMLSMUGPLACEMARKVARBS i. <'mediumphotourl'
  dat=. ((imhead i.<'MEDIUMURL'){"1 smugdat) (<a:;pos)} dat

  NB. insert icon url
  dat=. (<x) (<a:;KMLSMUGPLACEMARKVARBS i. <'iconurl')} dat

  NB. insert various defaults
  dat=. (<":RANGEDEFAULT) (<a:;KMLSMUGPLACEMARKVARBS i. <'range')} dat
  dat=. (<":TILTDEFAULT) (<a:;KMLSMUGPLACEMARKVARBS i. <'tilt')} dat
  dat=. (<":HEADINGDEFAULT) (<a:;KMLSMUGPLACEMARKVARBS i. <'heading')} dat

  NB. default viewpoint longitude, latitude, 0
  viewpoint=. (1 {"1 lb) ,. (<',') ,. (0 {"1 lb) ,. <',0'
  viewpoint=. <"1 ;"1 alltrim&.> viewpoint
  dat=. viewpoint (<a:;KMLSMUGPLACEMARKVARBS i. <'viewpoint')} dat
  KMLSMUGPLACEMARKVARBS,dat
else.
  (0,#KMLSMUGPLACEMARKVARBS)$''
end.
)


geotaggedfrtab=:3 : 0

NB.*geotaggedfrtab  --  generates  a  kml  document  pointing  to
NB. current geotagged smugmug images.
NB.
NB. A variation on (geotaggedkml). This verb  extracts data  from
NB. SmugMug  TAB  delimited  table  files  instead   of   escaped
NB. Mathematica JSON.
NB.
NB. monad:  clKml =. geotaggedfrtab uuIgnore
NB.
NB.   kml=. geotaggedfrtab 0
NB.   kml write 'c:\pd\coords\kml\GeotaggedSmugmugImages.kml'
NB.
NB. dyad:  clKml =. paGalleries geotaggedfrtab uuIgnore
NB.
NB.   NB. one folder with all images and no tour
NB.   kml=. 0 geotaggedfrtab 0

1 geotaggedfrtab y
:
'albums images'=. readsmugtables 0
images=. }. images [ imhead=. 0 { images

NB. retain images with locations
images=. images #~ *./"1 [ 0<#&> (imhead i. ;:'LATITUDE LONGITUDE') {"1 images
suppress=. imhead i. ;:'FILENAME LATITUDE LONGITUDE'

if. x-:1 do.

  NB. sort by album name and generate a folder and tour of each album
  images=. images {~ /: ((0 {"1 albums) i. 0 {"1 images) { 1 {"1 albums
  albumtours=. ;1 1&makesmugplacemarkkmlfrtab&.> (<imhead) ,&.> (~: 0{"1 images) <;.1 images

  NB. generate tour of all locations without repeating images
  images=. images #~ ~:suppress {"1 images
  grandtour=. 0 1 makesmugplacemarkkmlfrtab imhead,images

  KMLHEADER,albumtours,grandtour,KMLTRAILER
else.
  images=. images #~ ~:suppress {"1 images
  KMLHEADER,(1 0 makesmugplacemarkkmlfrtab imhead,images),KMLTRAILER
end.
)


geotaggpxfrtab=:3 : 0

NB.*geotaggpxfrtab  --  generates  a  gpx  document  pointing  to
NB. current geotagged smugmug images.
NB.
NB. monad:  clKml =. geotaggpxfrtab uuIgnore
NB.
NB.   gpx=. geotaggpxfrtab 0
NB.   gpx write 'c:\pd\coords\poi\GeotaggedSmugmugImages.gpx'

'albums images'=. readsmugtables 0
images=. }. images [ imhead=. 0 { images

NB. retain images with locations
images=. images #~ *./"1 [ 0<#&> (imhead i. ;:'LATITUDE LONGITUDE') {"1 images
suppress=. imhead i. ;:'FILENAME LATITUDE LONGITUDE'

images=. images #~ ~:suppress {"1 images
0 makesmugplacemarkgpxfrtab imhead,images
)

NB. extract html placeholder variable names
htmlvarbs=:{ -.&.> (<'{}')"_


makesmugplacemarkgpxfrtab=:3 : 0

NB.*makesmugplacemarkgpxfrtab v-- generate geotagged image gpx.
NB.
NB. monad:  makesmugplacemarkgpxfrtab btclSmugImageTable
NB.
NB.   himages=. readtd2 SMUGTABLEDIR,SMUGIMAGETABLE
NB.
NB.   gpx=. makesmugplacemarkgpxfrtab himages
NB.
NB. dyad:  paGeoSort makesmugplacemarkgpxfrtab btclSmugImageTable
NB.
NB.   gpx=. 1 makesmugplacemarkgpxfrtab himages

0 makesmugplacemarkgpxfrtab y
:
if. #rdat=. prepsmuggeotaggedtabdata y do.

  hdr=. 0{rdat

  NB. match google earth sort
  rdat=. }.x sortgeotagged rdat

  gpxstamp=. 'Geotagged images: ',(":#rdat),' GPX generated: ',timestamp''
  gpxheader=. ('/{{headername}}/',KMLALLFOLDER,'/{{headerdescription}}/',gpxstamp) changestr GPXHEADER
  gpxtrailer=. GPXTRAILER

  'idx pkml'=. HTMLVARBPATTERN patpartstr GPXSMUGPLACEMARK
  rvarbs=. idx htmlvarbs pkml

  NB. all row varibles must exist in data header
  assert. *./ rvarbs e. hdr
  rows=. (#rdat) # ,: pkml
  rows=. ((hdr i. <'phototitle'){"1 rdat) (<a:;(rvarbs i. <'phototitle'){idx)} rows
  rows=. ((hdr i. <'latitude'){"1 rdat) (<a:;(rvarbs i. <'latitude'){idx)} rows
  rows=. ((hdr i. <'longitude'){"1 rdat) (<a:;(rvarbs i. <'longitude'){idx)} rows

  gpxheader,(;rows),gpxtrailer
else.
  NB. no geotagged placemark data
  ''
end.
)


makesmugplacemarkkmlfrtab=:3 : 0

NB.*makesmugplacemarkkmlfrtab  v--  generate  placemark  and tour
NB. kml.
NB.
NB. monad: clHtml =. makesmugplacemarkkmlfrtab btclSmugImageTable
NB.
NB.   himages=. readtd2 SMUGTABLEDIR,SMUGIMAGETABLE
NB.
NB.   kml=. makesmugplacemarkkmlfrtab himages
NB.
NB. dyad: clHtml =. plOptions makesmugplacemarkkmlfrtab btcl
NB.
NB.   NB. only tour code
NB.   0 1 makesmugplacemarkkmlfrtab himages
NB.
NB.   NB. folder and tour code
NB.   1 1 makesmugplacemarkkmlfrtab himages
NB.
NB.   NB. only folder code
NB.   1 0 makesmugplacemarkkmlfrtab himages

1 1 makesmugplacemarkkmlfrtab y
:
if. #rdat=. prepsmuggeotaggedtabdata y do.

  hdr=. 0{rdat

  NB. set album (default folder) name
  if. 1 1-:x do. album=. (reb smugalbumname rdat)-.'/' else. album=. KMLALLFOLDER end.

  kmlheader=. ('/{{smugmugalbumname}}/',album) changestr KMLALBUMHEADER
  kmltrailer=. KMLALBUMTRAILER
  kmltourheader=. ('/{{smugmugalbumname}}/',album) changestr KMLTOURHEADER

  rdat=. }.(0{x) sortgeotagged rdat

  NB. folder/placemarks
  if. 1=0{x do.
    'idx pkml'=. HTMLVARBPATTERN patpartstr KMLSMUGPLACEMARK
    rvarbs=. idx htmlvarbs pkml

    NB. all row varibles must exist in data header
    assert. *./ rvarbs e. hdr
    rows=. (#rdat) # ,: pkml

    rows=. ((hdr i. <'pmida'){"1 rdat) (<a:;(rvarbs i. <'pmida'){idx)} rows
    rows=. ((hdr i. <'phototitle'){"1 rdat) (<a:;(rvarbs i. <'phototitle'){idx)} rows
    rows=. ((hdr i. <'mediumphotourl'){"1 rdat) (<a:;(rvarbs i. <'mediumphotourl'){idx)} rows
    rows=. ((hdr i. <'albumurla'){"1 rdat) (<a:;(rvarbs i. <'albumurla'){idx)} rows
    rows=. ((hdr i. <'albumurlb'){"1 rdat) (<a:;(rvarbs i. <'albumurlb'){idx)} rows
    rows=. ((hdr i. <'longitude'){"1 rdat) (<a:;(rvarbs i. <'longitude'){idx)} rows
    rows=. ((hdr i. <'latitude'){"1 rdat) (<a:;(rvarbs i. <'latitude'){idx)} rows
    rows=. ((hdr i. <'range'){"1 rdat) (<a:;(rvarbs i. <'range'){idx)} rows
    rows=. ((hdr i. <'tilt'){"1 rdat) (<a:;(rvarbs i. <'tilt'){idx)} rows
    rows=. ((hdr i. <'heading'){"1 rdat) (<a:;(rvarbs i. <'heading'){idx)} rows
    rows=. ((hdr i. <'iconurl'){"1 rdat) (<a:;(rvarbs i. <'iconurl'){idx)} rows
    rows=. ((hdr i. <'viewpoint'){"1 rdat) (<a:;(rvarbs i. <'viewpoint'){idx)} rows
    placemarks=. ;rows
  end.

  NB. tour
  if. 1=1{x do.
    'idx pkml'=. HTMLVARBPATTERN patpartstr KMLSMUGTOURANIMATION
    rvarbs=. idx htmlvarbs pkml

    rows=. (#rdat) # ,: pkml
    rows=. ((hdr i. <'pmida'){"1 rdat) (<a:;(rvarbs i. <'pmida'){idx)} rows
    rows=. ((hdr i. <'pmida'){"1 rdat) (<a:;(rvarbs i. <'pmidb'){idx)} rows
    rows=. (<":FLYTODURATIONDEFAULT) (<a:;(rvarbs i. <'flytoduration'){idx)} rows
    rows=. ((hdr i. <'longitude'){"1 rdat) (<a:;(rvarbs i. <'longitude'){idx)} rows
    rows=. ((hdr i. <'latitude'){"1 rdat) (<a:;(rvarbs i. <'latitude'){idx)} rows
    rows=. ((hdr i. <'range'){"1 rdat) (<a:;(rvarbs i. <'range'){idx)} rows
    rows=. ((hdr i. <'tilt'){"1 rdat) (<a:;(rvarbs i. <'tilt'){idx)} rows
    rows=. ((hdr i. <'heading'){"1 rdat) (<a:;(rvarbs i. <'heading'){idx)} rows
    rows=. (<":PICTUREWAITDEFAULT) (<a:;(rvarbs i. <'picturewait'){idx)} rows
    rows=. (<":ENDWAITDEFAULT) (<a:;(rvarbs i. <'endwait'){idx)} rows
    tour=. kmltourheader,(;rows),KMLTOURTRAILER
  end.

  select. x
  case. 1 1 do. kmlheader,placemarks,tour,kmltrailer
  case. 1 0 do. kmlheader,placemarks,kmltrailer
  case. 0 1 do. tour
  case. 0 0 do. ''
  end.

else.
  NB. no geotagged placemark data
 ''
end.
)


nearestnew=:3 : 0

NB.*nearestnew v-- order of nearest points.
NB.
NB. This verb  produces  better tours than ordering  waypoints by
NB. longitude only. I  am  not  satisfied  with the loopeyness of
NB. this verb. There must be a more elegant and faster solution.
NB.
NB. monad:  ilOrder =. nearestnew btclLatLong

NB. no points to order
if. (#y) e. 0 1 do. i.#y return.end.

NB. Google Earth lat:(+ north),lng:(- west)
NB. to Meeus     lat:(+ north),lng:(+ west)
lb=. (- 1{"1 y) (<a:;1)} y

NB. nearest point order - excluding self
npo=. lb earthdist"1 2 |:lb
npo=. }:"1 /:"1 npo + _ * =/~ i.#npo

NB. start with first point
seen=.current=. 0
all=. i. #npo

whilst. #all-.seen do.

  NB. nearest unseen point
  current=. 0{(current{npo) -. seen
  seen=. seen,current

end.
seen
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


prepsmuggeotaggedtabdata=:3 : 0

NB.*prepsmuggeotaggedtabdata v-- prepare SmugMug image table data
NB. for kml generation.
NB.
NB. monad:  btclData =. prepsmuggeotaggedtabdata btcl
NB.
NB.   himages=. readtd2 SMUGTABLEDIR,SMUGIMAGETABLE
NB.
NB.   prepsmuggeotaggedtabdata himages
NB. 
NB. dyad:  btclData =. plHu prepsmuggeotaggedtabdata btcl
NB.
NB.   0 1 prepsmuggeotaggedtabdata himages

(KMLREMOVEHIDDEN,KMLNODUPLICATES) prepsmuggeotaggedtabdata y
:
NB. hidden and duplicate handling
'bhid bdup'=. x
dat=. }. y [ imhead=. 0 { y

NB. retain only geotagged images
mask=. *./"1 [ 0 < #&> dat {"1~ imhead i. ;:'LATITUDE LONGITUDE'
dat=.  mask # dat

NB. remove hidden images
if. bhid do. dat=. dat #~ '0'= ;(imhead i. <'HIDDEN') {"1 dat end.

NB. remove duplicate images using SmugMug picture id
if. bdup do. dat=. dat #~ ~:(imhead i. <'PID') {"1 dat end.

KMLICONURL formatsmugtabdata (<imhead),<dat
)


readsmugtables=:3 : 0

NB.*readsmugtables v-- reads SmugMug tables.
NB.
NB. monad:  readsmugtables uuIgnore
NB.
NB.   'albums images'=. readsmugtables 0

path=. tslash SMUGTABLEDIR
albums=. readtd2 path,SMUGALBUMTABLE
images=. readtd2 path,SMUGIMAGETABLE
(<albums),<images
)

NB. read TAB delimited table files - faster than (readtd) - see long document
readtd2=:[: <;._2&> (9{a.) ,&.>~ [: <;._2 [: (] , ((10{a.)"_ = {:) }. (10{a.)"_) (13{a.) -.~ 1!:1&(]`<@.(32&>@(3!:0)))


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

NB. radians from degrees
rfd=:*&0.017453292519943295

NB. sine radians
sin=:1&o.

NB. format smug album/gallery name from gallery url
smugalbumfmt=:[: clip1char '- ' charsub '/' afterlaststr '/' beforelaststr ]

NB. extract SmugMug album name for album url
smugalbumname=:smugalbumfmt ([: ; 0 { [: }. ] {"1~ (<'albumurla') i.~ 0 { ])


sortgeotagged=:4 : 0

NB.*sortgeotagged v-- sort geotagged images for Google Earth touring.
NB.
NB. dyad:  btcl =. paOrder sortgeotagged btcl

dat=. }.y [ hdr=. 0{y

lb=. ".&> (<a:;hdr i. ;:'latitude longitude'){dat

NB. sort by longitude - makes for smoother Google Earth sailing
ord=. /: 1 {"1 lb
dat=. ord{dat
lb=. ord{lb

NB. now sort by nearest unseen neighbor
dat=. (nearestnew lb){dat

NB. reverse for grand tour
if. x=0 do. dat=. |. dat end.

hdr,dat
)


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


titlesfrfilenames=:3 : 0

NB.*titlesfrfilenames v-- convert file names to titles.
NB.
NB. monad:  blcl =. titlesfrfilenames blclFilenames
NB.
NB.   kmltab=: smugkmltable cutonfiles reescm read 'c:\temp\gjson.m'
NB.   titlesfrfilenames 0 {"1 kmltab

NB. remove extensions and [pids]
t=. '['&beforelaststr@:('.'&beforelaststr) &.> y

NB. remove common photographic sizes
t=. '/4x6//5x7//8x10//12x4/' changestr ; LF,&.> t

NB. remove redundant blanks
reb&.> <;._1 tolower t
)


tolower=:3 : 0

NB.*tolower v-- convert to lower case.
NB.
NB. monad: cl =. tolower cl

x=. I. 26 > n=. ((65+i.26){a.) i. t=. ,y
($y) $ ((x{n) { (97+i.26){a.) x}t
)

NB. appends trailing \ character if necessary
tslash=:] , ('\'"_ = {:) }. '\'"_

NB. writes a list of bytes to file
write=:1!:2 ]`<@.(32&>@(3!:0))

NB.POST_kml post processor for kml 

smoutput 0 : 0
NB. interface word(s)
NB.   geotaggedfrtab  NB. generates a kml document pointing to current geotagged smugmug images
NB.   geotaggpxfrtab  NB. generates a gpx document pointing to current geotagged smugmug images
)

cocurrent 'base'
coinsert  'kml'
