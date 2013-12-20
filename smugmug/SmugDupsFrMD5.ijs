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
