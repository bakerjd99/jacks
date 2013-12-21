NB.*SmugShotFix s-- fixes EXIF metadata in SmugShot images.
NB.
NB. This script uses Phil Harvey's superb EXIF command line tool.
NB. 
NB. verbatim:
NB.
NB. http://www.sno.phy.queensu.ca/~phil/exiftool/
NB. http://bakerjd99.wordpress.com/2011/04/03/smugshot-metadata-mess/
NB.
NB. interface word(s): 
NB. ------------------------------------------------------------------------------                                 
NB. SmugTablesFrXml2  NB. TAB delimited table files from SmugMug xml
NB. readsmugshots     NB. return SmugShot images from image table
NB. smugshotexif      NB. inserts missing EXIF metadata in SmugShot iPhone uploads                                   
NB.                                                         
NB. author:  John Baker
NB. created: 2011apr06
NB. ------------------------------------------------------------------------------ 
NB. 11apr06 group class created
NB. 11apr16 require 'dir' utility added
NB. 11apr19 tweaked to handle change in SmugShot download file name
NB.         script adjusted for J 7.0x
NB. 13dec20 store in (jacks) GitHub repo

require 'dir task'

coclass 'SmugShotFix'
NB.*end-header

NB. carriage return character
CR=:13{a.

NB. carriage return line feed character pair
CRLF=:13 10{a.

NB. Artist set in image files when none is present
DEFAULTARTIST=:'John D. Baker'

NB. Copyright message set in image files when none is present
DEFAULTCOPYRIGHT=:'All rights reserved'

NB. exif text imagedescription when tag is intialized - cannot be all blanks
DEFAULTDESCRIPTION=:'-'

NB. exiftool basic shell command
EXIFCMDTAB=:'exiftool -tab -coordformat "%.6f" '

NB. exif metadata items I care about
EXIFITEMS=:' -copyright -artist -datetimeoriginal -imagedescription -gpslatituderef -gpslatitude -gpslongituderef -gpslongitude '

NB. temporary file for exif descriptions
EXIFTMPFILE=:'c:\temp\exifdesc.txt'

NB. interface words (IFACEWORDSSmugShotFix) group
IFACEWORDSSmugShotFix=:<;._1 ' SmugTablesFrXml2 readsmugshots smugshotexif'

NB. root words (ROOTWORDSSmugShotFix) group      
ROOTWORDSSmugShotFix=:<;._1 ' ROOTWORDSSmugShotFix IFACEWORDSSmugShotFix'

NB. name of TAB delimited SmugMug album table file
SMUGALBUMTABLE=:'smugalbumtable.txt'

NB. directory containing SmugMug files
SMUGDATADIR=:'c:\pd\docs\smugmug\data\'

NB. name of augmented TAB delimited SmugMug album table file
SMUGIMAGETABLE2=:'smugimagetable2.txt'

NB. tab character
TAB=:9{a.


AlbumIdsFrAlbumURLs=:4 : 0

NB.*AlbumIdsFrAlbumURLs v-- extract gallery ids from AlbumURLS
NB.
NB. dyad:  blblGids =. iaCol AlbumIdsFrAlbumURLs blbtAlbums

urls=. (x&{"1)&.> y

NB. album ids must be unique
aids=.  ~.&.> ('_'&beforestr)@:('/'&afterlaststr) L: 0 urls
'album ids are not unique' assert 1= #&> aids
<"0;aids
)

NB. parses required attritube data in SmugMug rest xml for augmented table
AlbumImageTable2=:('id'&attrvalue ; 'FileName'&attrvalue ; 'MD5Sum'&attrvalue ; 'Hidden'&attrvalue ; 'Height'&attrvalue ; 'Width'&attrvalue ; 'Keywords'&attrvalue ; 'AlbumURL'&attrvalue ; 'MediumURL'&attrvalue ; 'Caption'&attrvalue ; 'Latitude'&attrvalue ; 'Longitude'&attrvalue ; 'Date'&attrvalue)&>


AlbumTableFrXml=:3 : 0

NB.*AlbumTableFrXml v-- parse gallery list from SmugMug rest xml and form album table.
NB.
NB. monad:  btcl=. AlbumTableFrXml clXml
NB.
NB.   xml=. read  'c:\pd\docs\smugmug\data\smugheavy.xml'
NB.   albums=. AlbumTableFrXml xml

gxml=.   ;'GalleryList' geteletext y
gidtit=. ('id'&attrvalue ; 'Title'&attrvalue)&> cutonalbumsxml gxml
gxml=. cutoncategoryxml gxml
catgry=. 'Name'&attrvalue&.> gxml

NB. not all galleries have subcategories
subgry=. 'Name'&attrvalue&.> ,cutonsubcategoryxml&> gxml
gidtit=. gidtit ,. catgry ,. subgry

NB. category, subcategory, title must form unique combination
'nonunique gallery names' assert isunique }."1 gidtit
(;:'GID TITLE CATEGORY SUBCATEGORY'),gidtit
)


SmugTablesFrXml2=:3 : 0

NB.*SmugTablesFrXml2 v-- TAB delimited table files from SmugMug xml.
NB.
NB. Slight variation on original - field added and I didn't check the code
NB. for any adverse consequences.
NB.
NB. monad:  blclFiles =. SmugTablesFrXml2 clFileXml
NB.
NB.   SmugTablesFrXml2 'c:\pd\docs\smugmug\data\smugheavy.xml'
NB.
NB. dyad:   blclFiles =. clOutDir SmugTablesFrXml2 clFileXml

'c:\pd\docs\smugmug\data\' SmugTablesFrXml2 y
:
xml=. read y

NB. album table - first row column names
albums=. AlbumTableFrXml xml
'CR LR TAB in albums' assert -.1 e. +./&> (CRLF,TAB)&e.&.> albums

NB. image tables for each gallery
images=. 'Images' geteletext ; 'GalleryImages' geteletext xml
images=. AlbumImageTable2@:cutonimageidxml&.> images

imhead=. ;:'GID PID FILENAME MD5 HIDDEN HEIGHT WIDTH KEYWORDS ALBUMURL MEDIUMURL CAPTION LATITUDE LONGITUDE UPLOADDATE'
aids=. (<:imhead i.<'ALBUMURL') AlbumIdsFrAlbumURLs images

'image album ids do not match albums' assert (;aids) e. }. 0 {"1 albums

NB. attach album ids to all images
images=. ;aids ,.&.> images
images=. alltrim&.> imhead , images
'CR LR TAB in images' assert -.1 e. +./&> (CRLF,TAB)&e.&.> images

NB. write TAB files
path=. tslash alltrim x
albums writetd alfile=. path,SMUGALBUMTABLE
images writetd imfile=. path,SMUGIMAGETABLE2
alfile;imfile
)

NB. retains string (y) after last occurrence of (x)
afterlaststr=:] }.~ #@[ + 1&(i:~)@([ E. ])

NB. retains string after first occurrence of (x)
afterstr=:] }.~ #@[ + 1&(i.~)@([ E. ])

NB. trims all leading and trailing blanks
alltrim=:] #~ [: -. [: (*./\. +. *./\) ' '&=

NB. trims all leading and trailing white space
allwhitetrim=:] #~ [: -. [: (*./\. +. *./\) ] e. (9 10 13 32{a.)"_

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))

NB. extracts text of xml attribute
attrvalue=:'"'"_ beforestr ([ , '="'"_) afterstr '>'"_ beforestr ]

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


charsub=:4 : 0

NB.*charsub v-- single character pair replacements.
NB.
NB. dyad:  clPairs charsub cu
NB.
NB.   '-_$ ' charsub '$123 -456 -789'

'f t'=. ((#x)$0 1)<@,&a./.x
t {~ f i. y
)

NB. cut SmugMug rest xml on album ids
cutonalbumsxml=:] <;.1~ '<Album id=' E. ]

NB. cut SmugMug rest xml on categories
cutoncategoryxml=:] <;.1~ '<Category id=' E. ]

NB. cut SmugMug rest xml on image ids
cutonimageidxml=:] <;.1~ '<Image id=' E. ]

NB. cut SmugMug rest xml on subcategories
cutonsubcategoryxml=:] <;.1~ '<SubCategory id=' E. ]

NB. enclose all character lists in blcl in " quotes
dblquote=:'"'&,@:(,&'"')&.>

NB. enclose in " characters
enquote=:'"' , '"' ,~ alltrim


exifinfo=:3 : 0

NB.*exifinfo v-- extracts selected image metadata.
NB.
NB. Uses exiftool.exe to extract metadata from image files.
NB.
NB. monad:  exifinfo clPathfile
NB.
NB.   exifinfo 'c:\wallpaper\alberta rmc queen.jpg'
NB.
NB.   NB. extract metadata from tif files in directory
NB.   exifinfo&.> 1 dir 'c:\pictures\20thcentury\europe\*.tif'

'invalid " in file name' assert -.'"' e. y
y=. alltrim y

NB. exiftool.exe must be on the command shell path
cmd=. EXIFCMDTAB,EXIFITEMS
cmd=. cmd,enquote y

NB. require task !(*)=. shell
dat=. shell cmd
dat=. <;._1&> TAB ,&.> <;._2 tlf dat -. CR

NB. format missing, warnings and errors
if. 1 1-:$dat do.
  if. 1 0 -: $>0{dat             do. dat=. 0 2$''
  elseif. +./'Warning: ' E. ;dat do. dat=. 1 2$'[WARNING]'; ;dat
  elseif. +./'Error' E. ;dat     do. dat=. 1 2$'[ERROR]'; ;dat
  end.
end.

y;<(/:0 {"1 dat){dat
)


extractsmugid=:3 : 0

NB.*extractsmugid v-- extract SmugMug id from downloaded SmugShot image file name.
NB.
NB. monad:  clSpid =. extractsmugid clPathFileJpg
NB.
NB.   extractsmugid 'c:/pictures/2011/Missouri/wip/smugshot_8866788 [s1255250408].jpg'
NB.   extractsmugid 'c:/pictures/2011/Missouri/wip/1255250408_smugshot_8866788.jpg'

spid=. ('_'&beforestr) @: ('/'&afterlaststr) y

if. spid -: 'smugshot' do.

  NB. spid attached by download/rename as suffix
  spid=. ;(' [s';'].jpg') betweenstrs y

end.

msg=. 'invalid image id'
msg assert 0<#spid
msg assert spid e. '0123456789'

spid
)


fmtlat=:3 : 0

NB.*fmtlat v-- format GoogleEarth latitude for exiftool.
NB.
NB. monad:  cl =. fmtlat faLat

ref=. ' -gpslatituderef=',;(0<:y){'South';'North'
lat=. ' -gpslatitude=',alltrim ,'9.6' (8!:2) | y
ref,' ',lat,' '
)


fmtlng=:3 : 0

NB.*fmtlat v-- format GoogleEarth longitude for exiftool.
NB.
NB. monad:  cl =. fmtlng faLng

ref=. ' -gpslongituderef=',;(y<:0){'East';'West'
lat=. ' -gpslongitude=',alltrim ,'10.6' (8!:2) | y
ref,' ',lat,' '
)

NB. get pure element text
geteletext=:] betweenstrs~ [: tags [: alltrim [

NB. 1 if image is a SmugShot file and 0 otherwise
issmugshot=:+./@:('smugshot_'&E.)

NB. 1 if items are unique 0 otherwise
isunique=:[: -. 0 e. ~:

NB. extracts the extension from qualified file names
justext=:''"_`(] #~ [: -. [: +./\. '.'&=)@.('.'&e.)

NB. reads a file as a list of bytes
read=:1!:1&(]`<@.(32&>@(3!:0)))


readsmugshots=:3 : 0

NB.*readsmugshots v-- return SmugShot images from image table
NB.
NB. monad:  readsmugshots uuIgnore

NB. read TAB delimited image table 
images=. readtd2 SMUGDATADIR,SMUGIMAGETABLE2
imhead=. 0 { images

NB. return only SmugShots
images=. images #~ issmugshot&> ((0{images) i. <'FILENAME') {"1 images
imhead,images
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


setartistcopyright=:3 : 0

NB.*setartistcopyright v-- sets the default artist and copyright using exiftool.
NB.
NB. monad:  setartistcopyright clPathFile
NB. dyad:   (clArtist;clCopyright;clDescription) setartistcopyright clPathFile

(DEFAULTARTIST;DEFAULTCOPYRIGHT;DEFAULTDESCRIPTION) setartistcopyright y
:

'artist copyright description'=. x

'invalid " in file name' assert -.'"' e. y
'original backup file' assert -.+./'_original' E. justext y

exf=. EXIFCMDTAB,' '
cpy=. ' -copyright=',(enquote copyright),' '
art=. ' -artist=',(enquote artist),' '
tags=. ;: 'Artist Copyright'

NB. check current image artist and copyright - do not change
'file info'=. exifinfo y
file=. ' ',enquote file
sm0=.sm1=. ''

if. 0 e.$info do.
  NB. missing metadata ATTEMPT to create !(*)=. shell

  NB. WARNING: if the exif is corrupt or suspect this will not succeed.

  NB. NOTE: assumes DEFAULTDESCRIPTION has no line feeds quote's et cetera
  desc=. ' -imagedescription=',(enquote description),' '
  sm0=. shell exf,desc,cpy,art,file
  (exifinfo y),<sm0
  return.
end.

if. (0{tags) e. 0 {"1 info do.
  NB. artist present check value
  val=. ; ((0 {"1 info) i. 0{tags) { 1 {"1 info
  if. 0=#val do. sm0=. shell exf,art,file end.
else.
  sm0=. shell exf,art,file 
end.

if. (1{tags) e. 0 {"1 info do.
  NB. copyright present check value
  val=. ; ((0 {"1 info) i. 1{tags) { 1 {"1 info
  if. 0=#val do. sm1=. shell exf,art,file end.
else.
  sm1=. shell exf,cpy,file
end.

NB. reread to reflect changes
(exifinfo y),<sm0,sm1
)


setdate=:4 : 0

NB.*setdate v-- sets original date time with exiftool.
NB.
NB. verbatim: (x) date argument is formatted:
NB.           'yyyy:mm:dd hr:mn:ss'
NB.
NB. dyad:  clDate setdate clFilePath
NB.
NB.   '2009:02:02 22:27:00' setdate 'c:\temp\test.tif'

NB. test date/time
dt=. _1 ". ' '(I. ':'=x)} x
msg=. 'invalid date time'
msg assert valdate 3{.dt
hr=. 3{dt [ ms=. _2{.dt
msg assert ((0 <: <./) *. (60 >: >./)) ms
msg assert (0&<: *. 24&>:) hr

cmd=. EXIFCMDTAB,' -datetimeoriginal=',enquote x

NB. require 'task' !(*)=. shell
sm=. shell cmd,' ',enquote y
(exifinfo y),<sm
)


setdescription=:3 : 0

NB.*setdescription v-- set exif image description with exiftool.
NB.
NB. monad: setdescription clPathFile
NB. dyad:  clDesc setdescription clPathFile

DEFAULTDESCRIPTION setdescription y
:
'invalid " in file name' assert -.'"' e. y
'original backup file' assert -.+./'_original' E. justext y

cmd=. EXIFCMDTAB,' ',(enquote '-imagedescription<=',EXIFTMPFILE),' '

NB. there are a number of comment tags in image metadata - clear
NB. other tags to insure only one comment is picked up by smugmug
cmd=.cmd, ' -description="" -caption-abstract="" -comment="" '

NB. remove double blanks and trailing whitespace
desc=. reb allwhitetrim x

NB. write to temp file - allows embedded quotes, line feeds et cetera
desc write EXIFTMPFILE

NB. insert/replace description !(*)=. shell
sm=. shell cmd,' ',enquote y

(exifinfo y),<sm
)


setlatlng=:3 : 0

NB.*setlatlng v-- set exif latitude and longitude.
NB.
NB. This verb takes latitude  and longitude  (x)  in  GoogleEarth
NB. format  (Northern   latitudes  +),  (Western  Longitudes  -),
NB. decimal degrees and sets exif gps values in image file (y).
NB.
NB. monad: setlatlng clPathFile
NB. 
NB.  NB. monad removes GPS infomation from image
NB.  setlatlng 'c:/wallpaper/puppy.jpg'
NB.
NB. dyad:  flLatLng setlatlng clPathFile
NB.
NB.   45.0899 _110.78135 setlatlng 'c:/wallpaper/kitten.jpg'

'invalid " in file name' assert -.'"' e. y
'original backup file' assert -.+./'_original' E. justext y
sm=. shell EXIFCMDTAB,' -gps:all= ',enquote y
(exifinfo y),<sm
:
'invalid " in file name' assert -.'"' e. y
'original backup file' assert -.+./'_original' E. justext y

'lat lng'=. x

NB. check lat/lng
msg=. 'invalid latitude/longitude'
msg assert 2=#x
'lat lng'=. x
msg assert (_90&<: *. 90&>:) lat
msg assert (_180&<: *. 180&>:) lng

latcmd=. fmtlat lat [ lngcmd=. fmtlng lng

NB. require task !(*)=. shell
sm=. shell EXIFCMDTAB,latcmd,lngcmd,enquote y

NB. reread to reflect changes
(exifinfo y),<sm
)

NB. REFERENCE - shell verb in task script - require 'task'
shell=:shell_jtask_


smugshotexif=:4 : 0

NB.*smugshotexif v--  inserts missing EXIF  metadata  in SmugShot
NB. iPhone uploads.
NB.
NB. The  iPhone  SmugShot  app  removes  EXIF  information during
NB. upload. This verb restores items I care about.
NB.
NB. dyad:  btclSmugMetaData smugshotexif clPathFile
NB.
NB.   NB. update TAB delimited SmugMug metadata tables
NB.   SmugTablesFrXml2 'c:\pd\docs\smugmug\data\smugheavy.xml'
NB.
NB.   NB. load SmugShot specific metadata
NB.   SMUGSHOTMD=: readsmugshots 0
NB.
NB.   SMUGSHOTMD smugshotexif 'c:\pictures\2011\Missouri\wip\1204618219_smugshot_9811805.jpg'
NB.
NB.   NB. fix all jpg files in a directory
NB.   (<SMUGSHOTMD) smugshotexif&> 1 dir 'c:\pictures\2011\Missouri\wip\*.jpg'

NB. extract SmugMug id from SmugShot file name
spid=. <extractsmugid y

NB. all smugshot pids
pids=. x {"1~ (0{x) i. <'PID'

if. spid e. pids do.

  NB. metadata exists for image insert items
  pos=. pids i. spid

  exif=. setartistcopyright y

  NB. use upload date for the missing original datetime
  date=. ;pos { x {"1~ (0{x) i. <'UPLOADDATE'
  date=. '-:' charsub date
  exif=. date setdate y

  caption=. ;pos { x {"1~ (0{x) i. <'CAPTION'
  exif=. caption setdescription y

  lb=. pos { x {"1~ (0{x) i. ;:'LATITUDE LONGITUDE'
  if. *./ 0 < #&> lb do.
    lb=. _999&". &> lb
    exif=. lb setlatlng y
  end.

  NB. rename as iphone file with original smugshot number
  NB. format path chars for windows rename 
  newname=. '.jpg'&beforelaststr y
  newname=. 'iphone ',('_'&afterlaststr) @:(' [s'&beforelaststr) newname
  shell '/\' charsub 'rename ' , ; ' ' ,&.> dblquote y;newname,'.jpg'

  newname ; exif
else.
  'No SmugShot metadata for';spid
end.
)

NB. xml BEGIN and END tags
tags=:'<'&,@,&'>' ; '</'&,@,&'>'

NB. appends trailing line feed character if necessary
tlf=:] , ((10{a.)"_ = {:) }. (10{a.)"_

NB. appends trailing \ character if necessary
tslash=:] , ('\'"_ = {:) }. '\'"_


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

NB. writes a list of bytes to file
write=:1!:2 ]`<@.(32&>@(3!:0))

NB. format and write TAB delimited table files
writetd=:] (1!:2 ]`<@.(32&>@(3!:0)))~ [: 2&}.@:;@:((13{a.)&,&.>@<;.1@((10{a.)&,)@(((10{a.) I.@(e.&(13{a.))@]} ])@:(#~ -.@((13 10{a.)&E.@,)))) [: }.@(,@(1&(,"1)@(-.@(*./\."1@(=&' '@])))) # ,@((10{a.)&(,"1)@])) [: }."1 [: ;"1 (9{a.) ,&.> [

NB.POST_SmugShotFix post processor 

smoutput 0 : 0
NB. interface word(s):
NB. SmugTablesFrXml2  NB. TAB delimited table files from SmugMug xml
NB. readsmugshots     NB. return SmugShot images from image table
NB. smugshotexif      NB. inserts missing EXIF metadata in SmugShot iPhone uploads        
)

cocurrent 'base'
coinsert  'SmugShotFix'