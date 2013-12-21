(9!:41) 0
coclass'CSsrv'
Afmt=:":
Aex=:".
CSBOOLS=:<;._1 ' False True'
CSTYPES=:2 5$<;._1 ' string int double bool datetime System.String System.Int32 System.Double System.Boolean System.DateTime'
CSsrvBADRC=:_777
IFACEWORDSCSsrv=:<;._1 ' dtColumnInfo dtTableData isDataTable testDataTable dtDataTableFrTrdata'
ISDATATABLECODE=:31
ROOTWORDSCSsrv=:<;._1 ' IFACEWORDSCSsrv ROOTWORDSCSsrv box0 dtColumnInfo dtDataTableFrTrdata dtTableData isDataTable scatter testDataTable'
TESTWORDS=:<;._1 ' these are the words that we test by they are pure and good and devoid of the badness that is wrong'
assert=:0 0"_$13!:8^:((0:e.])`(12"_))
box0=:[:":&.><"0
dtColumnInfo=:>@:(0&{)
dtDataTableFrTrdata=:4 :0
'j f'=.x
if.(j=0 )*.0 =#f do.ISDATATABLECODE;<testDataTable 0 0 return.end.
b=.|:dtTableDataFrStr f
h=.{:$b
if.(j=0)+.0=#y do.d=.(0,h)$<''else.d=.dtTableDataFrStr y end.
if.(j,h)-:$d do.
a=.(<'Column'),&.>'r<0>4.0'(8!:0)i.h
g=.h$<'literal'
c=.1{b
i=.(1{CSTYPES)i.c
if.({:$CSTYPES)>>./i do.
c=.i{0{CSTYPES
e=.a,(0{b),g,:c
ISDATATABLECODE;<(<e),<d
else.
CSsrvBADRC;<y
end.
else.
CSsrvBADRC;<y
end.
)
dtTableData=:>@:(1&{)
dtTableDataFrStr=:<;._1&>@:(<;._1)
isDataTable=:3 :0
'_base_'isDataTable y
:
c=.CSsrvBADRC
b=.y,x
if.0~:nc<b do.c
elseif.a=.".b
-.(,2)-:$a do.c
elseif.0 e.$>1{a do.
if.~:/{:@:$&.>a do.c return.end.
ISDATATABLECODE return.
elseif.-.1 1-:L.&>a do.c
elseif.d=.$&.>a
-.2 2-:#&>d do.c
elseif.4~:{.;0{d do.c
elseif.~:/{:&>d do.c
elseif.do.
ISDATATABLECODE
end.
)
nc=:4!:0
rndcoords=:]$([:?~*/){[:,[:{[:i.&.><"0
scatter=:]{~[:rndcoords$
testDataTable=:3 :0
'i h'=.y
g=.h$<'literal'
b=.0{CSTYPES
c=.b{~?h##b
a=.(<'Column'),&.>'r<0>4.0'(8!:0)i.h
d=.c,&.>' ',&.>'r<0>4.0'(8!:0)i.h
f=.a,d,g,:c
if.0 <i do.e=.|:i testDataTableColumn"0 c else.e=.(0 ,h)$<''end.
(<f),<e
)
testDataTableColumn=:4 :0
select.y
case.'string'do.TESTWORDS{~?x##TESTWORDS
case.'int'do.":&.><"0?x#10000
case.'double'do.'0.2'(8!:0)239%~?x#613
case.'bool'do.(?x#2){CSBOOLS
case.'datetime'do.
a=.1 tsrep(1e9*?x#200)+tsrep(6!:0)''
c=.(<"1 ('q</>,q</>,q<>'(8!:2)3{."1 a))-.&.>' '
b=.(<"1 'q<:>,q<:>,q<>'(8!:2)<.3}."1 a)-.&.>' '
c,&.>' ',&.>b
case.do.
'invalid j DataTable column type'assert 0
end.
)
testDataTableMatch=:4 :0
if.x-:y do.1
else.
'b d'=.x
'c e'=.y
if.b-:c do.
if.*./0<(#d),#e do.
f=.(I.(<'double')=3{b){"1 d
a=.10j10
d=.a&".&>d
e=.a&".&>e
if.(a e.d)+.a e.e do.0 else.d-:e end.
else.
0
end.
else.
0
end.
end.
)
tsrep=:3 :0
0 tsrep y
:
if.x do.
r=.$y
'w n t'=.|:0 86400 1000#:,y
w=.w+657377.75
d=.<.w-36524.25*c=.<.w%36524.25
d=.<.1.75+d-365.25*w=.<.(d+0.75)%365.25
s=.(1+12|m+2),:<.0.41+d-30.6*m=.<.(d-0.59)%30.6
s=.|:((c*100)+w+m>:10),s
r$s,.(_3{.&>t%1000)+"1[0 60 60#:n
else.
a=.((*/r=.}:$y),{:$y)$,y
'w m d'=.<"_1|:3{."1 a
w=.0 100#:w-m<:2
n=.+/|:<.36524.25 365.25*"1 w
n=.n+<.0.41+0 30.6#.(12|m-3),"0 d
s=.3600000 60000 1000+/ .*"1 [3}."1 a
r$s+86400000*n-657378
end.
)
18!:4 <'base'
(9!:41) 1