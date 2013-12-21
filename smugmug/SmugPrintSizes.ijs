NB.*SmugPrintSizes s-- compute largest print size for given dpi.
NB.
NB. verbatim:
NB.
NB. http://bakerjd99.wordpress.com/2010/02/21/assigning-smugmug-print-size-keys/
NB.                                
NB. author:  John Baker
NB. created: 2013dec20
NB. ------------------------------------------------------------------------------ 
NB. 2013dec20 saved in (jacks) GitHub repo
NB.*end-header

NB. round off for print surface area (square inches)
SMUGAREAROUND=:0.5

NB. round off for SmugMug aspect ratios - precision must distinguish all ratios
SMUGASPECTROUND=:0.0050000000000000001

NB. default print DPI (typically 300)
SMUGPRINTDPI=:300

NB. list of available SmugMug print sizes - larger sizes not listed
SMUGPRINTSIZES=:<;._1 ' 3.5x5 4x5 4x5.3 4x6 4x8 5x5 5x6.7 5x7 5x10 5x30 7x10 8x8 8x10 8x10.6 8x12 8x16 8x20 8.5x11 9x12 10x10 10x13 10x15 10x16 10x20 10x30 11x14 11x16 11x28 12x12 12x18 12x20 12x24 12x30'

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))


charsub=:4 : 0

NB.*charsub v-- single character pair replacements.
NB.
NB. dyad:  clPairs charsub cu
NB.
NB.   '-_$ ' charsub '$123 -456 -789'

'f t'=. ((#x)$0 1)<@,&a./.x
t {~ f i. y
)


printsizestable=:3 : 0

NB.*printsizestable v-- computes print sizes table.
NB.
NB. WARNING: THIS:  assumes the sizes listed in  (SMUGPRINTSIZES)
NB. have dimensions listed in Short x Long order.
NB.
NB. monad:  bt=. printsizestable blclPrintSizes
NB.
NB.   printsizestable SMUGPRINTSIZES

NB. assume (y) is short x long
ratios=. ".&> 'x%'&charsub&.> y
areas=.  ".&> 'x*'&charsub&.> y

NB. sizes with same ratio, eg: 4x5, 8x10, 4x6, 8x12
aspect=. ((~.ratios) i. ratios) </. i. #ratios

NB. columns: ratio, areas, printsizes
(<"0 ~.ratios) ,. (aspect {&.> <areas) ,. s:&.> aspect {&.> <y
)

NB. round y to nearest x (e.g. 1000 round 12345)
round=:[ * [: <. 0.5 + %~


smugprintsizes=:3 : 0

NB.*smugprintsizes v-- compute largest print size for given dpi.
NB.
NB. Computes the  largest  print size  (relative  to  DPI x)  for
NB. SmugMug images. Only images that have aspect ratios  close to
NB. the ratios  on  (SMUGPRINTSIZES) are associated  with a print
NB. size.
NB.
NB. monad:  st=. smugprintsizes btclImages
NB.
NB.   'albums images'=. readsmugtables 0
NB.   smugprintsizes images
NB.
NB. dyad:  st=. iaDpi smugprintsizes btclImages
NB.
NB.   200 smugprintsizes images

SMUGPRINTDPI smugprintsizes y
:
nsym=.s:<''

NB. reduce image table on PID
images=. }. y [ imhead=. 0 { y
pidpos=. imhead i. <'PID'
if. 0=#images=. images #~ ~:pidpos {"1 images do. 0 2$nsym return.end.

NB. compute print sizes table
pst=. printsizestable SMUGPRINTSIZES

NB. image dimensions short x long
idims=. _1&".&> (imhead i. ;:'WIDTH HEIGHT') {"1 images
'invalid image dimensions' assert -. _1 e. idims
idims=. (/:"1 idims) {"1 idims

NB. aspect ratio and print area (square inches)
ratios=. SMUGASPECTROUND round %/"1 idims
areas=.  SMUGAREAROUND round (*/"1 idims) % *: x

NB. mask table selecting images with ratio
masks=. (SMUGASPECTROUND round ;0 {"1 pst) =/ ratios
if. -.1 e. ,masks do. 0 2$nsym return.end.

masks=. <"1 masks
pids=.  s:&.> masks #&.> <pidpos {"1 images

NB. largest print area for selected images at current DPI
masks=. (1 {"1 pst) </&.> masks #&.> <areas
pids=.  (<"1&.> masks #"1 &.> pids) -. L: 0 nsym
sizes=.  <"0&.> 2 {"1 pst
; |:&.> ; pids ,: L: 0 (# L: 0 pids) # L: 0 sizes
)