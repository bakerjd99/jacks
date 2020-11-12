coclass'dbi'
DBIBASETYPES=:<;._1' U1 U4 U8 I16 I32 F64 D6 C0'
DBISPECIAL=:145 95 241
DBIVERSION=:3
IFACEWORDSdbi=:<;._1' dbicreate dbiread dbitemplate dbiwrite dbimetadata'
ROOTWORDSdbi=:<;._1' IFACEWORDSdbi ROOTWORDSdbi dbicreate dbiread dbitemplate dbiwrite'
apply=:128!:2
assert=:0 0"_$13!:8^:((0:e.])`(12"_))
boxopen=:<^:(L.=0:)
bytebits3=:_8{."1[:2&#.@(0 1&i.)^:_1 a.i.]
changestr=:4 :0
pairs=.2{."(1)_2[\<;._1 x
cnt=._1[lim=.#pairs
while.lim>cnt =.>:cnt do.
't c'=.cnt{pairs
if.+./b=.t E.y do.
r=.I.b
'l q'=.#&>cnt{pairs
p=.r+0,+/\(<:#r)$d=.q-l
s=.*d
if.s=_1 do.
b=.1#~#b
b=.((l*#r)$1 0#~q,l-q)(,r+/i.l)}b
y=.b#y
if.q=0 do.continue.end.
elseif.s=1 do.
y=.y#~>:d r}b
end.
y=.(c$~q*#r)(,p+/i.q)}y
end.
end.y
)
d6=:3 :0
'not 7 item timestamps'assert isd6 y
,ts6Frts7 y
)
dbicheckdata=:4 :0
msg=.'invalid name data table'
msg assert(2=#$x)*.(2={.$x)*.(1<:{:$x)*.isboxed x
msg assert(*./ischar&>0{x)*.1=#~.#&>1{x
(0{y)=.1{y
pfx=.<dbiname,'_'
dfnm=.pfx,&.>fnm
msg assert(0{x)e.dfnm
ord=./:dfnm i.0{x
x=.ord{"1 x
fmsk=.dfnm e.0{x
if.0=nrf do.ord
else.
ccnt=.{:@$&>1{x
fnc=.fmsk#fnc
rmsk=.0<fnc
msg assert(rmsk#fnc)=rmsk#ccnt
ccnt=.rmsk*#@":&><"0 ccnt
ety=.fmsk#"1 }."1 dbifieldtypes y
ety=.(pfx,&.>0{ety)(,0)}ety
ety=.((<'is'),&.>tolower&.>ccnt}.&.>1{ety)(,1)}ety
if.+./mc=.('isc'&-:)@(3&{.)&>1{ety do.
(mc#1{ety)=.iscfield
end.
'invalid field type(s)'assert(1{ety)apply&>1{x
ord
end.
)
dbicreate=:4 :0
'.dbi file exists'assert-.fexist y
'.dbi extension missing'assert'dbi'-:tolower justext y
msg=.'invalid name type table'
msg assert(2=#$x)*.(2={.$x)*.(1<{:$x)*.isboxed x
msg assert(*./1>:,(#@$)&>x)*.*./,ischar&>x
dbinamecheck 0{x
(0{dty)=.1{dty=.dbiparsetypes}.1{x
msg assert 0<:nrf=._1&".;0{1{x
nff=.<:{:$x
fbd=.dty dbioffsets nrf,nff
fbd=.}.fbd[nbf=.0{fbd
dbiname=.;(<0;0){x
fir=.DBIVERSION
fts=.nff#,:t7stmp 6!:0''
fnm=.}.0{x
dm=.dbiname;fir;nrf;nff;fnm;fnc;fty;fnb;fsc;fts;fbd
dm=.(;:'dbiname fir nrf nff fnm fnc fty fnb fsc fts fbd'),:dm
fhd=.dbiheader dm
('unable to write header -> ',y)assert 0<:bytes=.fhd fwrite y
bytes=.(nbf,bytes)fresize y
)
dbifieldtypes=:3 :0
(0{y)=.1{y
msk=.fnc>0
trc=.msk#^:_1":&>msk#<"0 fnc
tft=.<"1 trc,.fty,.":,.fnb
msk=.fsc>0
tft=.tft,&.>msk#^:_1 msk#'.'&,@":&.><"0 fsc
|:((dbiname;":nrf),fnm,.tft)-.&.>' '
)
dbiheader=:3 :0
(0{y)=.1{y
ni32=.nff,4
t1=.(nff,128)$0{a.
t1=.(16{."1>fnm)(<a:;i.16)}t1
t1=.(ni32$2 ic fnc)(<a:;16+i.4)}t1
t1=.(ni32$2 ic fnb)(<a:;20+i.4)}t1
t1=.fty(<a:;24)}t1
t1=.(fsc{a.)(<a:;25)}t1
t1=.(ts6Frts7 fts)(<a:;26+i.6)}t1
t1=.(ni32$2 ic fbd)(<a:;32+i.4)}t1
t1=.' ',t1
t1=.(4{.'DBI')(<0;i.4)}t1
t1=.('4.2'(;@(8!:0))fir)(<0;4+i.4)}t1
t1=.(8{.dbiname)(<0;8+i.8)}t1
t1=.(2 ic nrf,nff)(<0;16+i.8)}t1
,t1
)
dbimetadata=:3 :0
('to small for a .dbi file -> ',y)assert 128<dsize=.fsize y
emsg=.'unable to read file -> ',y=.utf8 y
emsg assert _1-.@-:hdr=.iread y;0 128
'nrf nff'=._2 ic(16+i.8){hdr
hdrsize=.128*>:nff
'file size header mismatch'assert hdrsize<:dsize
emsg assert _1-.@-:fdsc=.iread y;128,nff*128
dbiparseheader hdr,fdsc
)
dbinamecheck=:3 :0
alpha=.((65+i.26),97+i.26){a.
digits=.'0123456789'
dbn=.;0{y
'invalid table name'assert-.(({.dbn )e.digits)+.(8<#dbn )+.0 e.dbn e.alpha,digits
fnm=.}.y
'field names not unique'assert~:fnm
msg=.'invalid field name(s)'
msg assert-.1 e.({.&>fnm)e.digits
msg assert fnm*./@:e.&><alpha,digits
msg assert 16>:#&>fnm
1
)
dbioffsets=:4 :0
(0{x)=.1{x
'nrf nff'=.y
fbdnew=.>.(nrf*((fty e.'CD'){1 8)*(|fnc)*1>.fnb)%8
if.5={:$x do.
if.#pos=.I.0=fnb do.fbdnew =.(pos{}.(fbd,0)-0,fbd)pos}fbdnew end.
end.
_1|.(128*nff+1)++/\0,fbdnew
)
dbiparseheader=:3 :0
fdsc=.128}.y[hdr=.128{.y
'not a .dbi file'assert'DBI '-:4{.hdr
'.dbi version <: 2.00'assert 2.00<fir=._1&".(4+i.4){hdr
dbiname=.;dbirepsnc<toupper((8+i.8){hdr)-.' '
if.*./'STFREQ'E.dbiname do.dbiname =.'STFREQ'end.
'nrf nff'=._2 ic(16+i.8){hdr
fdsc=.(nff,128)$fdsc
fnm=.dbirepsnc(<"1 (i.16){"1 fdsc)-.&.>' '
fnc=._2 ic,(16+i.4){"1 fdsc
fty=.24{"1 fdsc
fnb=._2 ic,(20+i.4){"1 fdsc
fsc=.a.i.25{"1 fdsc
fts=.ts7Frts6(26+i.6){"1 fdsc
fbd=._2 ic,(32+i.4){"1 fdsc
desc=.;:'dbiname fir nrf nff fnm fnc fty fnb fsc fts fbd'
desc,:dbiname;fir;nrf;nff;fnm;fnc;fty;fnb;fsc;fts;fbd
)
dbiparsetypes=:3 :0
typ=.'CIUFD'[msg=.'invalid field types'
m0=.y e.&.><typ
msg assert 1=+/&>m0
fnc=.-{.&>m0
if.#t0=.,(_1&".)@,&>,m0<;._2&>y do.
m1=.fnc~:_1
msg assert 0<:t0=.m1#t0
fnc=.t0(I.m1)}fnc
end.
fty=.,m0#&.>y
y=.,m0<;._1&>y
t0=.y i.&.>'.'
t1=.fty,&.>t0{.&.>y
fty=.;fty
msg assert(('C'~:fty)#t1)e.DBIBASETYPES
msg assert _1<fnb=._1&".&>t1-.&.><typ
t1=.t0}.&.>y
if.1 e.m0=.0<fsc=.#&>t1 do.
msg assert'UI'e.~m0#fty
t0=.I.m0
msg assert 1='.'+/@:=&>t0{y
t1=._1&".&>(t0{t1)-.&.>'.'
msg assert-._1 e.t1
fsc=.t1 t0}fsc
end.
(;:'fnb fnc fty fsc'),:fnb;fnc;fty;fsc
)
dbiread=:3 :0
0 dbiread y
:
'.dbi file does not exist'assert fexist y
(0{dm)=.1{dm=.dbimetadata y
nbf=.fsize y=.utf8 y
nrf=.nbf dbitestnrf dm
fbdx=.fbd,nbf
fty=.tolower fty
if.x-:0 do.
rdr=.lff=.i.nff
else.
rf=.boxopen x
'invalid field names'assert rf e.fnm
lff=.fnm i.rf
rdr=.rf i.lff{fnm
end.
emsg=.'unable to read file -> ',y
dat=.i.0
for_iff.lff do.
n1=.iff{fnb
t=.n2=.iff{fnc
n2v=.(n2>:0)#n2
t=.(t<0){t,1
s1=.iff{fsc
if.nrf=0 do.t=.''
else.
l1=.((>:iff){fbdx)-b1=.iff{fbd
emsg assert _1-.@-:t=.iread y;b1,l1
end.
select.iff{fty
case.'f'do.
'floating point field must be 64 bits'assert n1 e.64
t=._2 fc t
if.n2>:0 do.t =.(nrf,n2)$t end.
case.'i'do.
'signed integer must be 16 or 32 bits'assert n1 e.16 32
t=.(-n1%16)ic t
if.n2>:0 do.t =.(nrf,n2)$t end.
if.s1 ~:0 do.t=.t%10^s1 end.
case.'u'do.
'unsigned integer field must be 1, 4 or 8 bits'assert n1 e.1 4 8
if.n1=1 do.t=.(nrf*1 >.n2){.,bytebits3 t
elseif.n1=4 do.t=.dfb((*/nrf,n2v),4 )$,bytebits3 t
elseif.n1=8 do.t=.a.i.t
end.
if.n2>:0 do.t =.(nrf,n2)$t end.
if.s1 ~:0 do.t=.t%10^s1 end.
case.'d'do.
'date fields must be 6 bytes'assert n1 e.6
t=.ts7Frts6(nrf,6)$t
case.'c'do.
if.n1=0 do.t =.];._1 t else.t =.(nrf,n1)$t end.
end.
dat=.dat,<t
end.
(,rdr){"1(2,#rdr)$((<dbiname,'_'),&.>lff{fnm),dat
)
dbirepsnc=:3 :0
(<spcrep DBISPECIAL)changestr&.>y
)
dbitemplate=:3 :0
'.dbi file does not exist'assert fexist y
dbifieldtypes dbimetadata y
)
dbitestnrf=:4 :0
(0{y)=.1{y[nbf=.x
n2=.1(I.0>fnc)}fnc
v1=.fnb=0
n2=.fnb*n2*(fty e.'CD'){1 8
n1=.>.(nrf*n2)%8
t1=.((}.fbd),nbf)-fbd
if.#v1x=.I.v1 do.n1 =.(v1x{t1)v1x}n1 end.
if.n1-.@-:t1 do.
if.+./v1=.(fty e.'IFD')+.(fty e.'CU')*.n2>:8 do.
t2=.(8*v1#t1)%v1#n2
mode2<.t2
end.
else.nrf
end.
)
dbiwrite=:4 :0
'.dbi file does not exist'assert fexist y
(0{dm)=.1{dm=.dbimetadata y=.utf8 y
ord=.x dbicheckdata dm
x=.ord{"1 x
if.nrf={.#&>1{x do.
(0;y;<dm)dbiwritefields x
else.
'all fields must be specified if record count does not match file'assert({:$x)=nff
(1;y;<dm)dbiwritefields x
end.
)
dbiwritefields=:4 :0
'rwf dfile dm'=.x
(0{dm)=.1{dm
nrf=.#>0{1{y
fbd=.(;:'fnb fnc fty fsc fbd'),:fnb;fnc;fty;fsc;fbd
fbd =.fbd dbioffsets nrf,nff
fbd=.}.fbd[nbf=.0{fbd
fts=.nff#,:t7stmp 6!:0''
fir=.DBIVERSION
dm=.dbiname;fir;nrf;nff;fnm;fnc;fty;fnb;fsc;fts;fbd
dm=.(;:'dbiname fir nrf nff fnm fnc fty fnb fsc fts fbd'),:dm
bc=.0[emsg=.'unable to write dbi file -> ',dfile
if.rwf do.emsg assert 0<:bc=.(dbiheader dm)fwrite dfile end.
if.0=nrf do.bc
else.
lff=.fnm i.(>:#dbiname)}.&.>0{y
'full rewrite needed for C0 fields'assert-.(0 e.lff{fnb)*.nff~:{:$y
fty=.tolower fty
elen=.(}.fbd,nbf)-}:fbd,nbf
hup=.-.rwf[hlen=.128*>:nff
for_iff.lff do.
dat=.>iff_index{1{y
select.iff{fty
case.'f'do.dat=.f64 dat
case.'i'do.
dat=.,dat
if.0<iff{fsc do.dat=.dat*10^iff{fsc end.
dat=.i16`i32@.(<:(iff{fnb)%16)dat
case.'u'do.
dat=.,dat
if.0<iff{fsc do.dat=.dat*10^iff{fsc end.
dat=.u1`u4`u8@.(1 4 8 i.iff{fnb)dat
case.'d'do.dat=.d6 dat
case.'c'do.
if.0=iff{fnb do.
dat=.;((255){a.),&.>rtrim&.><"1 dat
elen=.(#dat)iff}elen
fbd=.}:hlen,hlen++/\elen
hup=.1
else.
dat=.,(iff{fnb){."1 dat
end.
end.
fts=.(t7stmp 6!:0'')iff}fts
emsg assert(iff{elen)=#dat
emsg assert _1-.@-:dat iwrite dfile;iff{fbd
bc=.bc+dat=.#dat
end.
if.hup do.
dm=.(fts;fbd)(<1;(0{dm)i.;:'fts fbd')}dm
emsg assert _1-.@-:(dbiheader dm)iwrite dfile;0
end.
bc
end.
)
dfb=:2&#.@(0 1&i.)
f64=:3 :0
'not f64 floating'assert isf64 y=.,y
2 fc y
)
fboxname=:([:<8 u:>) ::]
fc=:3!:5
fexist=:1:@(1!:4) ::0:@(fboxname&>) @boxopen
fresize=:4 :0
'nbf bytes'=.x
if.nbf=bytes do.nbf
else.
msg=.'unable to resize file'
msg assert _1-.@-:' 'iwrite y;<:nbf
msg assert 0<fbytes=.fsize y
msg assert fbytes=nbf
fbytes
end.
)
fsize=:1!:4 ::(_1:)@(fboxname&>)@boxopen
fwrite=:([:,[) (#@[[1!:2) ::(_1:) [:fboxname]
hfd=:16&#.@('0123456789ABCDEF'&i.)^:_1
i16=:3 :0
'not i16 integer'assert isi16 y=.,y
1 ic y
)
i32=:3 :0
'not i32 integer'assert isi32 y=.,y
2 ic y
)
ic=:3!:4
iread=:1!:11 ::(_1:)
isboxed=:32&=@(3!:0)
iscfield=:3 :0
if.ischar y do.-.(255{a.)e.y else.0 end.
)
ischar=:2&=@(3!:0)
isd6=:3 :0
if.-.(isint y)*.(2=#$y)*.(7={:$y)do.0
elseif.(1 7$0)-:~.y do.1
elseif.do.
if.0 e.valdate 3{."1 y do.0 
elseif.0 e.(0 &<:*.24&>:)3{"1 y do.0 
elseif.0 e.(0 &<:*.60&>:)4 5{"1 y do.0 
elseif.0 e.(0 &<:*.999&>:)6{"1 y do.0 
elseif.do.1
end.
end.
)
isf64=:8&=@(3!:0)
isi16=:3 :0
if.isint y =.,y do.*./1=(_32769 32767)I.(<./,>./)y else.0 end.
)
isi32=:isint
isint=:1 4 e.~3!:0
isu1=:1&=@(3!:0)
isu4=:3 :0
if.isint y =.,y do.*./((<./,>./)y )e.i.16 else.0 end.
)
isu8=:3 :0
if.isint y =.,y do.*./((<./,>./)y )e.i.256 else.0 end.
)
iwrite=:1!:12 ::(_1:)
justext=:''"_`(]#~[:-.[:+./\.'.'&=)@.('.'&e.)
mode2=:3 :0
if.0<#y =.,y do.
f=.#/.~y
(~.y)#~f e.>./f 
else.y
end.
)
rtrim=:]#~[:-.[:*./\.' '"_=]
spcrep=:[:,('/',.[:,.a.{~]),.'/hx',"1[:hfd,
t7stmp=:[:<.],1000*1|{:
tolower=:3 :0
x=.I.26>n=.((65+i.26){a.)i.t=.,y
($y)$((x{n){(97+i.26){a.)x}t
)
toupper=:3 :0
x=.I.26>n=.((97+i.26){a.)i.t=.,y
($y)$((x{n){(65+i.26){a.)x}t
)
ts6Frts7=:3 :0
'invalid 7 integer timestamps'assert 7={:$y
r=.}:$y
z=.((*/r),48)$0
z=.((12#2)#:0{"1 y)(<a:;i.12)}z
z=.((4#2)#:1 {"1 y)(<a:;12+i.4)}z
z=.((5#2)#:2{"1 y)(<a:;16+i.5)}z
z=.((5#2)#:3{"1 y)(<a:;21+i.5)}z
z=.((6#2)#:4{"1 y)(<a:;26+i.6)}z
z=.((6#2)#:5{"1 y)(<a:;32+i.6)}z
z=.((10#2)#:6{"1 y)(<a:;38+i.10)}z
(r,6)$(dfb((8%~#z),8)$z){a.[z=.,z
)
ts7Frts6=:3 :0
tsb=.,"2 bytebits3 y
|:dfb@|:&>(1(+/\0 12 4 5 5 6 6)}48#0)<;.1|:tsb
)
u1=:3 :0
'not u1 boolean'assert isu1 y=.,y
a.{~dfb _8]\(8*>.(#y)%8){.y
)
u4=:3 :0
'not u4 integer'assert isu4 y=.,y
n=.>.0.5*#y
y=.(n,2)$(2*n){.y
(16 16#.y){a.
)
u8=:3 :0
'not u8 integer'assert isu8 y=.,y
y{a.
)
utf8=:8&u:
valdate=:3 :0
s=.}:$y
'w m d'=.t=.|:((*/s),3)$,y
b=.*./(t=<.t),(_1 0 0<t),12>:m
day=.(13|m){0 31 28 31 30 31 30 31 31 30 31 30 31
day=.day+(m=2)*-/0=4 100 400|/w
s$b*d<:day
)
NB.POST_dbi post processor.

smoutput IFACE=: (0 : 0)
NB. (dbi) interface word(s):
NB. ------------------------
NB. dbicreate    NB. create dbi file
NB. dbimetadata  NB. extracts dbi file metadata
NB. dbiread      NB. read dbi file
NB. dbitemplate  NB. (x) argument for (dbicreate) from dbi file
NB. dbiwrite     NB. write field data to dbi file
)

cocurrent 'base'
coinsert  'dbi'