NB.*brandxmp s-- brand directories of xmp sidecar files with file name and hash.
NB.
NB. verbatim:
NB. 
NB. interface word(s):
NB. ------------------------------------------------------------------------------
NB.  titbranddir - brand eligible xmp files in directory
NB.  titbrandxmp - brand xmp sidecar file with file name and hash of associated image
NB.  
NB. created: 2022jul13
NB. ------------------------------------------------------------------------------

coclass 'brandxmp'

NB.*dependents
NB. (*)=: wrecho XMPTITLEFRAG
NB.*enddependents

NB. write bytes (x) and return file (y)
wrecho=. {{ y [ x (write :: _1:) y }}

XMPTITLEFRAG=: (0 : 0)
<dc:title>
    <rdf:Alt>
     <rdf:li xml:lang="x-default">[~(fhash)~]</rdf:li>
    </rdf:Alt>
   </dc:title>
)
NB.*end-header

NB. carriage return character
CR=:13{a.

NB. interface words (IFACEWORDSbrandxmp) group
IFACEWORDSbrandxmp=:<;._1 ' titbranddir titbrandxmp'

NB. line feed character
LF=:10{a.

NB. image type considered raw
RAWFILETYPES=:<;._1 ' jpg tif tiff nef dng png jpeg heic'

NB. root words (ROOTWORDSbrandxmp) group      
ROOTWORDSbrandxmp=:<;._1 ' IFACEWORDSbrandxmp ROOTWORDSbrandxmp titbranddir'

NB. version, make count and date
VMDbrandxmp=:'0.5.0';4;'13 Jul 2022 22:56:27'

NB. retains string after first occurrence of (x)
afterstr=:] }.~ #@[ + 1&(i.~)@([ E. ])

NB. retains string before first occurrence of (x)
beforestr=:] {.~ 1&(i.~)@([ E. ])

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


cutnestidx=:4 : 0

NB.*cutnestidx v-- cut list into nested runs and other.
NB.
NB. Nested runs are delimited by begin and end tags. This verb is
NB. oriented toward XML parsing where typical begin  end tags are
NB. <ul>  </ul>  and tags  with  attributes  like: <hoo  boy="2">
NB. </hoo>
NB.
NB. This verb can process numeric lists but care must be taken to
NB. insure the pad item (1{.0$y) does  not  match begin  and  end
NB. values.
NB.
NB. dyad:  (ilIdx ;< blcl) =. (clStart;clEnd) cutnestidx cl
NB.        (ilIdx ;< blnl) =. (nlStart;nlEnd) cutnestidx nl
NB.
NB.   xml=. 'yada <ol><li>one</li><ol><li>sub one</li></ol></ol> boo'
NB.   ('<ol';'</ol>') cutnestidx xml
NB.
NB.   88 99 cutnestidx (i.5),88,(10?10),99 88 5 5 5 5 5 99

if. #y do.
  's e'=. ,&.> x                NB. start end lists
  ut=. 1{.0$y                   NB. padding
  assert. -.s -: e              NB. they must differ
  assert. -.(s -:ut) +. e-:ut
  sp=. s E. ut=.y,ut            NB. start mask

  NB. quit if no delimiters
  if. -.1 e. sp do. (i.0);<<y return. end.

  ep=. e E. ut                  NB. end mask
  assert. (+/sp) = +/ep         NB. basic balance
  dp=. sp + - ep                NB. start end marks
  assert. 0 *./ . <: +/\ dp     NB. nested balance
  ep=. I. _1=dp [ sp=. I. 1=dp  NB. start end indexes
  ut=. +/\dp -. 0               NB. scanned marks
  dp=. /:~ sp,ep                NB. all indexes
  sp=. (firstones 1<:ut)#dp     NB. starts of nested
  ep=. (#e)+(0=ut)#dp           NB. starts of other
  dp=. /:~ ~.0,sp,ep            NB. cut starts
  ut=. }: 1 dp} (>:#y)#0        NB. cut mask
  (dp i. sp);<ut <;.1 y         NB. nest indexes cut list
else.
  (i.0);<<y                     NB. empty arg result
end.
)

NB. delete trailing line feed if necessary: dlf 'ab',LF
dlf=:] }.~ [: - (10{a.) = {:

NB. boxes UTF8 names
fboxname=:([: < 8 u: >) ::]

NB. 1 if file exists 0 otherwise
fexist=:1:@(1!:4) ::0:@(fboxname&>)@boxopen

NB. 0's all but first 1 in runs of 1's - like (firstone) but differs for nulls
firstones=:> (0: , }:)

NB. file name and extension from fully qualified file
justfileext=:] #~ [: -. [: +./\. '\'&=

NB. reads a file as a list of bytes
read=:1!:1&(]`<@.(32&>@(3!:0)))

NB. sha-256 hash from bytes: sha256 'hash me again'
sha256=:3&(128!:6)

NB. brand file with name and sha256 hash: shabrand 'c:\temp\IMG_0162.jpg'
shabrand=:(';' ,~ justfileext@winpathsep) , sha256@read


sidecars=:3 : 0

NB.*sidecars v-- image raws with corresponding sidecar xmp files.
NB.
NB. monad:  btcl =. sidecars clDirectory
NB.
NB.   p0=. 'c:/pictures/2022/idaho/01_jan/iphoneraw'
NB.   sidecars p0
NB.
NB. dyad:  btcl =. blcl sidecars clDirectory
NB.
NB.   p1=. 'C:\pictures\2022\North Rim Monument Valley\06_jun\d7500'
NB.   (;:'nef dng') sidecars p1  NB. only real raws

NB. image types considered "raws"
RAWFILETYPES sidecars y
:
NB. raw files !(*)=. dir
raw=. , ;1&dir&.> (<(tslash2 y) ,'*.') ,&.> x

NB. darktable sidecar file names are created by
NB. appending '.xmp' to the source file name
(fexist xmp) # raw,.xmp=.raw ,&.> <'.xmp'
)

NB. xml BEGIN and END tags
tags=:'<'&,@,&'>' ; '</'&,@,&'>'


titbranddir=:3 : 0

NB.*titbranddir v-- brand eligible xmp files in directory.
NB.
NB. monad:  blcl =. titbranddir clDirectory
NB.
NB.   rp=. 'c:\pictures\2022\North Rim Monument Valley\06_jun\d5100'
NB.   titbranddir rp

NB. "raws" with sidecar xmp
if. #ds=. sidecars y do.

  NB. insert file name & hash in title element
  xmps=. titbrandxmp&.> <"1 ds

  NB. write branded xmp files
  xmps wrecho&.> 1 {"1 ds
else.
  0$<'' NB. no eligible xmps
end.
)


titbrandxmp=:3 : 0

NB.*titbrandxmp v--  brand xmp  sidecar file  with file name  and
NB. hash of associated image.
NB.
NB. monad:  clXmp =. titbrandxmp blImageXmpFiles
NB.
NB.   xmp=. 'c:\pictures\2022\Idaho\sun valley mountain mali.tif.xmp'
NB.   ps=. xmp ;~ (-#'.xmp') }. xmp
NB.   titbrandxmp ps
NB.
NB.   ds=. sidecars 'C:\pictures\2022\North Rim Monument Valley\06_jun\d7500'
NB.   xmps=. titbrandxmp&.> <"1 ds

xmp=. read xmp [ 'raw xmp'=. y

NB. a single publisher element must exist to safely brand
pt=. '</dc:publisher>'
if. 1 ~: +/pt E. xmp do. xmp return. end.

NB. file name and sha256 brand
tit=. dlf ('/[~(fhash)~]/',shabrand raw) changestr XMPTITLEFRAG-.CR

NB. replace or insert title element
'idx cxmp'=. (tags 'dc:title') cutnestidx xmp
if. #idx do.
  ;(<tit) idx} cxmp
else.
  (pt ,~ pt beforestr xmp),LF,tit,pt afterstr xmp
end.
)

NB. appends trailing / iff last character is not \ or /
tslash2=:([: - '\/' e.~ {:) }. '/' ,~ ]

NB. standardizes path delimiter to windows back \ slash
winpathsep=:'\'&(('/' I.@:= ])} )

NB. writes a list of bytes to file
write=:1!:2 ]`<@.(32&>@(3!:0))

NB.POST_brandxmp post processor. 

smoutput IFACE=: (0 : 0)
NB. (brandxmp) interface word(s): 20220713j225627
NB. -----------------------------
NB. titbranddir  NB. brand eligible xmp files in directory
NB. titbrandxmp  NB. brand xmp sidecar file with file name and hash of associated image
)

cocurrent 'base'
coinsert  'brandxmp'
