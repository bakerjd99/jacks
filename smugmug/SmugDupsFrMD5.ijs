NB.*SmugDupsFrMD5 s-- find duplicate SmugMug images using MD5.
NB. 
NB. verbatim:
NB.
NB. http://bakerjd99.wordpress.com/2010/02/05/smugmug-duplicate-image-hunting/
NB. http://bakerjd99.wordpress.com/2010/02/11/more-on-smugmug-duplicates/
NB.                                                         
NB. author:  John Baker  
NB. created: 2013dec20
NB. ------------------------------------------------------------------------------ 
NB. 2013dec20 saved in (jacks) GitHub repo
NB.*end-header

NB. name of TAB delimited SmugMug album table file
SMUGALBUMTABLE=:'smugalbumtable.txt'

NB. name of TAB delimited SmugMug image table file
SMUGIMAGETABLE=:'smugimagetable.txt'

NB. directory containing SmugMug data files
SMUGTABLEDIR=:'c:\pd\docs\smugmug\data\'


CheckSmugDups=:3 : 0

NB.*CheckSmugDups v-- checks duplicate SmugMug images.
NB.
NB. monad:  CheckSmugDups uuIgnore

'albums images'=. readsmugtables 0
images=. }. images [ imhead=. 0 { images

NB. images should be unique in three ways:
r=. ,: 'PID unique: '; # ~.(imhead i. <'PID') {"1 images
r=. r, 'MD5 unique: '; # ~.(imhead i. <'MD5') {"1 images
r=. r, 'FILENAME unique: '; # ~.(imhead i. <'FILENAME') {"1 images

dups=. 1 <# ~. ;{:"1 r
dups;(ctl ;"1 ":&.> r);dups{'No duplicates';'Duplicates present'
)


SmugDupsFrMD5=:3 : 0

NB.*SmugDupsFrMD5 v-- duplicate SmugMug images from MD5.
NB.
NB. verbatim:
NB.
NB. http://bakerjd99.wordpress.com/2010/02/05/smugmug-duplicate-image-hunting/
NB.
NB. monad:  btct =. SmugDupsFrMD5 uuIgnore
NB.
NB.   SmugDupsFrMD5 0

NB. read table files
'albums images'=. readsmugtables 0
images=. }. images [ imhead=. 0 { images

NB. all duplicate MD5's
pos=. imhead i. <'MD5'
md5=. pos {"1 images
dup=. md5 #~ -. ~:md5
images=. (md5 e. dup)#images
images=. (/: pos {"1 images) { images

NB. remove images with matching smugmug pids
NB. these are proper virtual images and not copies
pos=. imhead i. <'PID'
pid=. pos {"1 images
mask=. -. ~: pid
smoutput (":+/mask),' virtual/collected images'
dup=. mask#pid
if. #images=. (-.pid e. dup)#images do.

  NB. retain selected columns and insert album names
  images=. (imhead i. ;:'FILENAME GID PID MD5 ALBUMURL') {"1 images
  albums=. ((0 {"1 albums) i. 1 {"1 images){ 1 {"1 albums
  images=. albums (<a:;1)} images

  NB. group by MD5
  images=. (~:3 {"1 images) <;.1 images
  images=. >&.>@:(<"1@|:) &> images

  NB. order MD5 groups by galleries in groups
  NB. this results in a good order for editing
  NB. out the duplicates on SmugMug
  images=. (\:&.> 1 {"1 images) {&.> images
  (\: 0 {&> 1 {"1 images){images
else.
  smoutput'no MD5 duplicates'
  0 5$''
end.
)

NB. character table to newline delimited list
ctl=:}.@(,@(1&(,"1)@(-.@(*./\."1@(=&' '@])))) # ,@((10{a.)&(,"1)@]))


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

NB. session manager output
smoutput=:0 0 $ 1!:2&2

NB. appends trailing \ character if necessary
tslash=:] , ('\'"_ = {:) }. '\'"_