cocurrent'Swag'
BadNumber=:_999999
BalanceSeries=:<;._1' BB NW'
ConfigSheetNames=:<;._1' CrossReference Parameters'
CreditChargeSeries=:<;._1' IC EC EF'
CrossReferenceSheet=:0 0$a:
CustomSeriesVerbs=:0$a:
DataSheetNames=:<;._1' Actuals Forecast'
DebtSeries=:<;._1' D0 D1 D2 D3 D4'
DebtSeriesNames=:<;._1' dbhouse dbcar dboptional dbother dbmedical'
ExpenseSeries=:<;._1' E0 E1 E2 E3 E4 E5 E6 E7 E8 EC EF'
IFACEWORDSSwag=:<;._1' FutureScenarios LoadConfig LoadSheets Swag SwagTest RunTest RunTheNumbers'
IncomeSeries=:<;._1' I0 I1 I2 I3 I4 I5 IC'
MainConfiguration=:<;._1' CrossReference Parameters'
MethodArguments=:<;._1' MethodArguments BackPeriods Fee Initial Interest LoanEquity YearInflate Schedule YearTerm DHouse DCar DOptional DOther DMedical RSavings RInvest REquity ROther'
MethodOrder=:<;._1' Method assume history reserve borrow transfer spend'
MethodTokens=:;:'()[=.'
ModelConfiguration=:0$a:
ModelLocale=:'Swag'
NoChange=:'';i.0
ROOTWORDSSwag=:<;._1' FutureScenarios IFACEWORDSSwag MainConfiguration ROOTWORDSSwag RepeatScenario RunTheNumbers TestConfiguration'
ReserveSeries=:<;._1' R0 R1 R2 R3'
ReserveSeriesNames=:<;._1' rssavings rsinvest rsequity rsother'
SSpreadPrefix=:'-s'
ScenarioPrefix=:'s'
SheetExt=:'.txt'
SheetSuffix=:'Sheet'
TABRawPath=:'c:/jod/mep/alien/mep/rawact/'
TABSheetPath=:'c:/jod/mep/alien/mep/tabsheets/'
TestConfiguration=:<;._1' CrossReference TestParameters'
TotalSeries=:<;._1' Etotal Itotal Rtotal Dtotal'
UtilitySeries=:<;._1' U0 U1 U2 U3'
VaryHistory=:0
AccumulateSeries2=:4 :0
'sv gr'=.y
pv=.x{.sv
cv=.(_1{.pv),x}.sv
cg=.(_1{.x{.gr),x}.gr
for_j.i.<:#cv do.
cv=.(((>:j){cv)+(j{cg)*j{cv)(>:j)}cv
end.
pv,}.cv
)
AccumulateSeries3=:(]{.~0{[),[:}.[:+/\(1{[),]}.~0{[
ActualFromRaw=:3 :0
'cross reference not loaded'assert 0<#CrossReferenceSheet
t=.}.((0{t)i.;:'Date Name Amount'){"1 t=.readtd2 y
d=.BadNumber&".&>(0{"1 t)-.&.>'-'
('invalid dates in raw file: ',y)assert valdate datefrint d
d=.d,.((SheetHeader 0)XrefSeries 1 {"1 t),.BadNumber&".&>2{"1 t
('invalid numbers in raw file: ',y)assert-.BadNumber e.,d
'to many columns for key encoding'assert 100>>./1 {"1 d
ym0=.100*100<.@%~0{"1 d
b=.~:t=.ym0+1 {"1 d
(>:b#ym0),.(b#1 {"1 d),.t+//.2{"1 d
)
ActualSheet=:3 :0
fom=.FirstOfMonth 0
f=.;:'RawIncome RawReserves RawExpenses'
f=.(<TABRawPath),&.>f,&.><SheetExt
'missing raw actual files'assert fexist f
d=./:~;ActualFromRaw&.>f
d=.d#~fom>0{"1 d
h=.SheetHeader 0
r=.FirstMonthRange(<./,>./)0{"1 d
a=.r(<a:;0)}a=.((#r),#h)$0
a=.(2{"1 d)(<"1 ((0{"1 a)i.0{"1 d),.1 {"1 d)}a
a=.(+/"1 (h i.ExpenseSeries){"1 a)(<a:;eC=.h i.<'Etotal')}a
a=.(+/"1 (h i.IncomeSeries){"1 a)(<a:;iC=.h i.<'Itotal')}a
a=.(+/"1 (h i.ReserveSeries){"1 a)(<a:;rC=.h i.<'Rtotal')}a
a=.(+/"1 (h i.DebtSeries){"1 a)(<a:;dC=.h i.<'Dtotal')}a
a=.(-/"1 (iC,eC){"1 a)(<a:;bC=.h i.<'BB')}a
rdd=.-/"1 (rC,dC){"1 a
nw=.rdd+0 0 AccumulateSeries3 bC{"1 a
a=.nw(<a:;h i.<'NW')}a
a=.({:nw)(<(<:#a);h i.<'U0')}a
h,(FormatSheetDates 0{"1 a),.}."1 (8!:0)a
)
AllocOnOffRange=:4 :0
'snc numx rsn'=.x['cn cv'=.y
optx=.4}.numx['fom value ondate offdate'=.4{.numx
if.offdate<:fom do.NoChange return.end.
'Fee Initial'=.2{.optx
(ReserveArguments)=.rsn
ralloc=.AllocTable|&.>".&.>ReserveArguments
asn=.cn {~cn XrefSeries ReserveSeriesNames
'reserve allocation length mismatch'assert(#ReserveSeriesNames)={:$ralloc
(cn)=.cv
rfx=.<a:;px=.(ondate,offdate)RangeIndexes Date
sie=.".&>asn
if.snc-:'IC'do.
sie=.((rfx{sie)+"1 0 value*0{ralloc)rfx}sie
EF=.(Fee+px{EF)px}EF
if.Initial=0 do.
EC=.(value+px{EC)px}EC
else.
IC=.(Fee+px{IC)px}IC
U0=.(value+px{U0)px}U0
end.
elseif.snc-:'EC'do.
'Initial must be zero for spend'assert Initial=0
sie=.((rfx{sie)-"1 0 value*0{ralloc)rfx}sie
U1=.(value+px{U1)px}U1
EF=.(Fee+px{EF)px}EF
elseif.do.'invalid allocation method'assert 0
end.
(<(;:'IC EC EF U0 U1'),asn),<IC,EC,EF,U0,U1,sie
)
AllocTable=:3 :0
1 AllocTable y
:
at=.|:2{.&>y
at=.x(<(I.0=+/"1 at);0)}at
'invalid allocation'assert(+/"1 at)e.0 1
at
)
ApplyScenarioMethod=:4 :0
'hp sm'=.<"1 x
'fom cn cv'=.y
mn=.;sm{~hp i.<'Method'
marg=.;sm{~hp i.<'MethodArguments'
try.
".marg[(MethodArguments)=.0
catch.
('invalid method arguments: ',marg)assert 0
end.
ondate=.".(;sm{~hp i.<'OnDate')-.'-'
offdate=.".(;sm{~hp i.<'OffDate')-.'-'
value=.".;sm{~hp i.<'Value'
fvof=.fom,value,ondate,offdate
select.mn
case.'assume'do.
(fvof;<".&.>ReserveArguments)AssumeOnOffRange 0{cv
case.'history'do.
(1{cn);(HistAddFuncs_Swag_,<fvof,BackPeriods,YearInflate)FuncHistOnOffRange 0 1{cv
case.'reserve'do.
('IC';(<fvof,Fee,Initial),<".&>ReserveArguments)AllocOnOffRange cn;cv
case.'transfer'do.
((<fvof,Fee,LoanEquity),(<".&.>ReserveArguments),<".&.>DebtArguments)TranOnOffRange cn;cv
case.'borrow'do.
((<fvof,Fee,Interest,LoanEquity,YearTerm),(<Schedule),(<".&.>ReserveArguments),<".&>DebtArguments)BorrowOnOffRange cn;cv
case.'spend'do.
('EC';(<fvof,Fee,Initial),<".&.>ReserveArguments)AllocOnOffRange cn;cv
case.do.'invalid scenario method'assert 0
end.
)
AssumeOnOffRange=:4 :0
'numx rsn'=.x[Date=.y
'fom value ondate offdate'=.4{.numx
if.offdate>fom do.
'invalid assumptions rates are single numbers'assert 1=#&>rsn
rsn=.;rsn
rsn=.value(I.0=rsn)}rsn
rsn=.,.>:(rsn%100)%12
px=.(ondate,offdate)RangeIndexes Date
ReserveGrowth_Swag_=:(rsn#"1~#px)(<(>:i.#rsn);px)}ReserveGrowth_Swag_
end.
NoChange
)
BalanceStatistics=:4 :0
dates=.DateFromSheet y
sheet=.FormatStatSheet(x,'Balance')SeriesYearStatistics dates,.'BB'ValuesFromSheet y
sheet=.sheet,.2}."1 FormatStatSheet(x,'Networth')SeriesYearStatistics dates,.'NW'ValuesFromSheet y
sheet=.sheet,.2}."1 FormatStatSheet(x,'Reserves')SeriesYearStatistics dates,.'Rtotal'ValuesFromSheet y
sheet=.sheet,.2}."1 FormatStatSheet(x,'Debts')SeriesYearStatistics dates,.'Dtotal'ValuesFromSheet y
equity=.XrefSeries'rsequity'
sheet,.2}."1 FormatStatSheet(x,'Equity')SeriesYearStatistics dates,.equity ValuesFromSheet y
)
BorrowOnOffRange=:4 :0
'numx Schedule rsn dbtn'=.x['cn cv'=.y
optx=.4}.numx['fom value ondate offdate'=.4{.numx
if.offdate<:fom do.NoChange return.end.
'Fee Interest LoanEquity YearTerm'=.4{.optx
(DebtArguments)=.dbtn
(ReserveArguments)=.rsn
darg=.0~:{.@".&>DebtArguments
rarg=.0~:{.@".&>ReserveArguments
if.0=+/darg do.darg =.1(DebtArguments i.<'DOther')}darg end.
'invalid loan payment and debt series pairing'assert(1=+/darg)*.(+/rarg)e.0 1
ds=.cn {~cn XrefSeries;(I.darg){DebtSeriesNames
ps=.cn {~cn XrefSeries'rsequity'
if.0=+/rarg do.
pcc=.1[pmtn=.1{cn
else.
pcc=._1[pmtn=.cn {~cn XrefSeries;(I.rarg){ReserveSeriesNames
end.
(cn)=.cv
px=.(ondate,offdate)RangeIndexes Date
if.ischar Schedule =.,Schedule do.
('amortization schedule missing: ',Schedule)assert fexist Schedule
at=.|:BadNumber&".&>}.readtd2 Schedule
'invalid amortization schedule table'assert-.(BadNumber e.at)+.4~:#at
else.
if.YearTerm=0 do.YearTerm=.1>.-/10000<.@%~offdate,ondate end.
at=.|:value*amort 12,(Interest%100),YearTerm
end.
lb=._1{(#px){.ob['pp ob'=.0 1{at
dv=.((px{dv)+(#px){.ob)px}dv=.".&>ds
cv=.((cv{~>:px)+pcc*(#px){.pp)(>:px)}cv=.".&>pmtn
U3=.(((#px){.pp)+(>:px){U3)(>:px)}U3
pv=.".&>ps
if.LoanEquity~:0 do.
pv=.((pv{~>:px)+(#px){.3{at)(>:px)}pv
end.
if.lb>0{0{at do.
px=.I.+./\offdate=Date
dv=.(lb+px{dv)px}dv
end.
(<ds,(<'U3'),pmtn,ps),<dv,U3,cv,:pv
)
CheckConfigSheets=:3 :0
nouns=.y
'two config sheets expected'assert 2=#nouns
'sheets are not all nouns'assert 0=nc nouns
dat=.".&.>nouns
msk=.(<;:'OnDate OffDate')*./@e.&>{.&.>dat
'on/off dates missing from config sheets'assert+./msk
parm=.;dat#~msk
xref=.;dat#~-.msk
dates=.OnOffDates parm
dymd=.datefrint,dates
'unknown series methods'assert MethodOrder e.~parm{"1~(0{parm)i.<'Method'
'invalid on/off dates'assert valdate dymd
'on/off dates not all first of month'assert*/1 ={:"1 dymd
'on/off dates out of order'assert</"1 dates
shd=.SheetHeader 0
'sheet header names not unique'assert~:shd
'total series names not in header'assert TotalSeries e.shd
xnames=.xref{"1~(0{xref)i.<'Name'
'cross reference names not unique'assert~:xnames
pnames=.parm{"1~(0{parm)i.<'Name'
'parameter names not in cross reference'assert pnames e.xnames
snames=.xref{"1~(0{xref)i.<'SeriesName'
'series names not unique'assert~:snames
'sheet header names not in cross reference'assert shd e.snames
'debt series long names not in cross reference'assert DebtSeriesNames e.xnames
'reserve series long names not in cross reference'assert ReserveSeriesNames e.xnames
'total series names not unique'assert~:TotalSeries
'income series names not unique'assert~:IncomeSeries
'reserve series names not unique'assert~:ReserveSeries
'expense series names not unique'assert~:ExpenseSeries
'debt series names not unique'assert~:DebtSeries
'debt series long names not unique'assert~:DebtSeriesNames
'balance series names not unique'assert~:BalanceSeries
'utility series names not unique'assert~:UtilitySeries
'credit charge series names not unique'assert~:CreditChargeSeries
'method arguments names not unique'assert~:MethodArguments
'reserve series names length mismatch'assert(#ReserveSeriesNames)=#ReserveSeries
'debt series names length mismatch'assert(#DebtSeriesNames)=#DebtSeries
('ReserveArguments_',ModelLocale,'_')=:'R',&.>2 MargNames ReserveSeriesNames
('DebtArguments_',ModelLocale,'_')=:'D',&.>2 MargNames DebtSeriesNames
'reserve argument names invalid'assert ReserveArguments e.MethodArguments
'debt argument names invalid'assert DebtArguments e.MethodArguments
dat=.CheckMethodArguments parm{"1~(0{parm)i.<'MethodArguments'
nouns
)
CheckMethodArguments=:3 :0
pg=.(;: ::_9:)&.>y
if.1 e.bm=.pg e.<_9:''do.
smoutput bm#y
end.
'method arguments do not parse'assert-.bm
mt=.MethodTokens,MethodArguments
pg=.a:-.~WithoutNumerals WithoutQuoted mt-.~;pg
if.#pg=.pg-.CustomSeriesVerbs do.
smoutput pg
end.
'method arguments contain unknown name tokens'assert 0=#pg
1
)
CheckSheets=:3 :0
nouns=.y
'sheets are not all nouns'assert 0=nc nouns
dat=.".&.>nouns
'sheet data header mismatch'assert(</:~SheetHeader 0)-:&>/:~&.>0&{&.>dat
'sheet row count mismatch'assert 1=#~.#&>dat
'sheet date column mismatch'assert 1=#~.(0&{"1)&>dat
dymd=.datefrint dates=.".&>(}.0&{"1&>[0{dat)-.&.>'-'
'invalid sheet dates'assert valdate dymd
'dates out of order'assert(i.#dates)-:/:dates
'not all first of month'assert*/1 ={:"1 dymd
months=.(0{"1 dymd)</.1 {"1 dymd
'months out of order'assert(i.@#&.>months)-:/:&.>months
'months have gaps'assert 0=#1-.~;(}.-}:)&.>months
nouns
)
ComputeScenario=:4 :0
sl=.ScenarioPrefix,":scn['scn pn'=.x
lfuncs=.FuncArguments ModelLocale
hdp=.(0{pn)-.&.>' '
hdx=.hdp i.;:'Name Scenario Method'
pn=.(alltrim&.>(<a:;hdx){pn)(<a:;hdx)}pn
'no scenario rows selected'assert 0<#pn=.sl SelectScenario pn
pn=.MethodOrder SortScenario pn
tr=.scn ScenarioTimeRange pn
ssn=.0{"1 ss=.(1 {tr)SeriesFromSheet y
(ssn)=.1 {"1 ss
('scenario dates missing: ',sl)assert Date e.~,OnOffDates pn
'scenario date range insufficient'assert tr e.Date
ReserveGrowth_Swag_=:Date,1$~(#ReserveSeries),#Date
fx=.Date<fom=.FirstOfMonth 0
ssd=.(ssn)-.<'Date'
psd=.fx#"1".&>ssd
(ssd)=.(<fx)*&.>".&.>ssd
ifx=.I.-.fx
'sn nn'=.SeriesNameXref 0
rn=.CreditChargeSeries,ReserveSeries,DebtSeries,UtilitySeries
pn=.}.pn
sx=.hdp i.<'Name'
for_sm.pn do.
cn=.sn{~nn i.sx{sm
cv=.".&>csn=.~.'Date';cn,rn
'asn nv'=.(hdp,:sm)ApplyScenarioMethod fom;csn;cv
if.0=#asn do.continue.end.
(asn)=.(ifx{"1 nv)ifx}"1 ".&>asn
end.
Itotal=.(ifx{+/".&>IncomeSeries)ifx}Itotal
Etotal=.(ifx{+/".&>ExpenseSeries)ifx}Etotal
Dtotal=.(ifx{+/".&>DebtSeries)ifx}Dtotal
BB=.(ifx{Itotal-Etotal)ifx}BB
px=.(fom>:{.Date )*Date i.fom
for_rs.ReserveSeries do.
rsv=.px AccumulateSeries2(".;rs),:(>:rs_index){ReserveGrowth_Swag_
(rs)=.(ifx{rsv)ifx}rsv
end.
Rtotal=.(ifx{+/".&>ReserveSeries)ifx}Rtotal
aec=.-+/fx#EC[rdd=.Rtotal-Dtotal
if.+./fx do.
rdd=.(aec+ifx{rdd)ifx}rdd
if.0=+/fx#U0 do.aec=.0
elseif.aec=0 do.rdd=.(}.+/\0 ,ifx{0 ,(}.-}:)rdd)ifx}rdd
end.
end.
NW=.(ifx{rdd+(px,aec+(<:px){NW,0)AccumulateSeries3 BB)ifx}NW
'past has changed'assert psd-:fx#"1".&>ssd
'debts cannot be negative'assert 0<:<./,".&>DebtSeries
ssn SheetFromSeries".&.>ssn 
)
DateFromSheet=:[:".&>[:}.'-'-.&.>~]{"1~(<'Date')i.~0{]
FirstMonthRange=:3 :0
0 FirstMonthRange y
:
'start finish'=.y
'dates out of order'assert start<finish
start=.datefrint start[finish=.datefrint finish
'invalid dates'assert valdate start,:finish
dates=.monthdates~(0{start)+0:`]@.(0<#)i.>:0{finish-start
start=.intfrdate 1,~}:start
finish=.intfrdate 1,~}:finish
dates=.dates#~(start<:dates)*.dates<:finish
FormatSheetDates`]@.(0-:x)dates
)
FirstOfMonth=:3 :0
if.0=nc<'FirstOfMonthOverride'do.
FirstOfMonthOverride
else.
0 100 100#.<.1,~2&{.@(6!:0)''
end.
)
FormatSheetDates=:[:<"1'd<0>q<->,r<0>q<->3.0,r<0>2.0'8!:2 datefrint
FormatStatSheet=:3 :0
'hd sst'=.y
('Year';hd),.&.|:('0.0'(8!:0)2{."1 sst),.'d<0>'(8!:0)2}."1 sst
)
FuncArguments=:3 :0
fn=.0$a:[loc=.'_',(y-.' '),'_'
('dFrep',loc)=:[+0*]
('mFmean',loc)=:mean f.
('dFadd',loc)=:+
('mFpass',loc)=:]
(fhist=.'HistFuncs',loc)=:('mFmean';'dFrep'),&.><loc
(fhistadd=.'HistAddFuncs',loc)=:('mFmean';'dFadd'),&.><loc
(fres=.'ResFuncs',loc)=:('mFpass';'dFadd'),&.><loc
loc;fhist;fhistadd;fres
)
FuncHistOnOffRange=:4 :0
'moFunc dyFunc numx'=.x['Date series'=.y
optx=.4}.numx['fom value ondate offdate'=.4{.numx
BackPeriods=.0{optx
if.fom<ondate do.
(dyFunc;numx)FuncOnOffRange y
elseif.(ondate<:fom)*fom<offdate do.
rhist=.(ondate,fom)RangeIndexes Date
if.BackPeriods=_1 do.
elseif.(BackPeriods>#rhist )*1<:#rhist do.
rhist=.(Date i.fom){.series
value=.(moFunc~)(-BackPeriods>.#rhist){.rhist
elseif.(1<:BackPeriods)*BackPeriods<:#rhist do.
value=.(moFunc~)(-BackPeriods<.#rhist){.rhist{series
elseif.(BackPeriods=0)*1<:#rhist do.
value=.(moFunc~)rhist{series
end.
(dyFunc;fom,value,ondate,offdate,optx)FuncOnOffRange y
elseif.offdate<:fom do.
series
end.
)
FuncOnOffRange=:4 :0
'dyFunc numx'=.x['Date series'=.y
optx=.4}.numx['fom value ondate offdate'=.4{.numx
YearInflate=.1{optx
if.offdate<:fom do.series
else.
range=.((fom>.ondate),offdate)RangeIndexes Date
noise=.(#range)#0
if.VaryHistory~:0 do.noise =.VaryHistory*?.noise end.
if.YearInflate=0 do.
((noise+value#~#range)(dyFunc~)range{series)range}series
else.
value=.(noise+value)**/\1,(<:#range)#>:(YearInflate%100)%12
(value(dyFunc~)range{series)range}series
end.
end.
)
FuncSheetSeries=:4 :0
'func dat'=.y
(func~)(<a:;(SheetHeader 0)i.x){dat
)
FutureScenarios=:3 :0
MainConfiguration_Swag_ FutureScenarios y
:
ModelConfiguration_Swag_=:x
sf=.0$a:
for_sn.y do.
sf=.sf,RunTest~sn,3
end.
sf
)
LoadConfig=:3 :0
ConfigSheetNames LoadConfig y
:
'model configuration not set'assert 0<#x
files=.(<TABSheetPath),&.>x,&.><SheetExt
'missing configuration files'assert*./fexist files
(sheets=.x,&.><SheetSuffix)=:readtd2&.>files
CheckConfigSheets sheets
)
LoadSheets=:3 :0
(i.0)LoadSheets y
:
nouns=.SheetNames y[files=.SheetFiles y
nouns=.nouns,&.><SheetSuffix
emsg=.'missing sheet file(s)'
aix=.DataSheetNames i.<'Actuals'
if.(i.0)-:x do.
emsg assert fexist aix{files
(nouns)=:2#<readtd2;aix{files
else.
emsg assert*./fexist files
(nouns)=:readtd2&.>files
end.
CheckSheets nouns
)
MargNames=:([:toupper@(0&{)&.>}.&.>),&.>]}.&.>~[:>:[
OnOffDates=:[:".@(-.&'-')&>[:}.]{"1~(<;._1' OnDate OffDate')i.~0{]
RangeIndexes=:4 :0
y=.<.y[x=.<.x
I.(+./\1(y i.0{x)}0#~#y )**./\0(y i.1{x)}1#~#y 
)
RepeatScenario=:4 :0
'minimum replications >: 2'assert 2<:0{x
hd=.0{y
didx=.hd i.;:'OnDate OffDate'
onoff=.didx{"1}.y
onoff=.BadNumber&".&>onoff-.&.>'-'
'invalid dates'assert-.BadNumber e.,onoff
fly=.<.10000%~(<./,>./),onoff
offsets=.onoff-10000*0{fly
dates=.,/offsets+"2 0[10000*(0{fly)++/\(<:0{x)#>:-/|.fly
dates=.FormatSheetDates"_1 dates
fr=.;(<:0{x)#<}.y
fr=.y,dates didx}"1 fr
(<ScenarioPrefix,":1{x)(<(>:i.<:#fr);hd i.<'Scenario')}fr
)
RunTest=:3 :0
a:RunTest y
:
LoadConfig~ModelConfiguration
parms=.".(;1{ModelConfiguration),SheetSuffix
opt=.(2<.1{opt)1}opt=.2{.y
if.-.x-:a:do.parms SwagTest opt end.
LoadSheets 0{y
files=.parms Swag 0{y
if.2={:2{.y do.
erase'FirstOfMonthOverride_Swag_'
smoutput'first of month restored'
elseif.3={:2{.y do.
erase'FirstOfMonthOverride_Swag_'
smoutput'first of month restored'
(read;0{files)write TABSheetPath,(ScenarioPrefix,":0{y),'Actuals',SheetExt
VaryHistory_Swag_=:0[vh=.VaryHistory_Swag_
LoadSheets 0{y
VaryHistory_Swag_=:vh[files=.parms Swag 0{y
end.
files
)
RunTheNumbers=:3 :0
ModelConfiguration_Swag_=:MainConfiguration_Swag_
parms=.".;{:LoadConfig 0
scfx=.ScenarioPrefix
ac=.toHOST fmttd ActualSheet 0
ac write TABSheetPath,'MainActuals',SheetExt
sf=.0$a:
for_sn.y do.
ac write TABSheetPath,scfx,(":sn),'Actuals',SheetExt
sf=.sf,parms Swag sn[LoadSheets sn
end.
sf
)
ScenarioTimeRange=:4 :0
sdates=.((0{y)i.;:'Scenario OnDate OffDate'){"1 y
sdates=.1 2{"1}.(alltrim ScenarioPrefix,":x)SelectScenario alltrim &.>sdates
sdates=.(<./,>./),".&>sdates-.&.>'-'
ld=.datefrint{:sdates
({.sdates),intfrdate 1>.((0{ld)+12<.@%~2+1{ld),(12|2+1{ld),2{ld
)
SelectScenario=:]#~(1)0}([:<[)=]{"1~(<'Scenario')i.~0{]
SeriesFromSheet=:4 :0
st=.}.y[hd=.0{y
dx=.hd i.<'Date'
sd=.|:BadNumber&".&>((dx{"1 st)-.&.>'-')(<a:;dx)}st
'invalid dates/numbers in sheet'assert-.BadNumber e.,sd
sd=.<"1 sd
if.x>ld=.{:ymd=.;dx{sd do.
ymd=.ymd,}.FirstMonthRange ld,x
sd=.(#ymd){.&.>sd
sd=.(<ymd)dx}sd
end.
hd,.sd
)
SeriesNameXref=:3 :0
<"1 |:}.((0{CrossReferenceSheet)i.;:'SeriesName Name'){"1 CrossReferenceSheet
)
SeriesYearStatistics=:4 :0
years=.<.(0{"1 y)%10000
sst=.years</.1 {"1 y
hd=.;:'Min Max Q1 Q2 Q3 Mean StdDev Skew Kurt'
hd=.'MonthCount';hd,&.><x
sv=.$,(<./),(>./),q1,median,q3,mean,stddev,skewness,kurtosis
(<hd),<(~.years),.sv&>sst
)
SheetFiles=:3 :0
(<TABSheetPath),&.>(SheetNames y),&.><SheetExt
)
SheetFromSeries=:4 :0
p=.x i.<'Date'
d=.FormatSheetDates;p{"1 y
t=.|:'d<0>'&(8!:0)&>y
x,d(<a:;p)}t
)
SheetHeader=:3 :0
'Date';ExpenseSeries,'Etotal';IncomeSeries,'Itotal';ReserveSeries,'Rtotal';DebtSeries,'Dtotal';BalanceSeries,UtilitySeries
)
SheetNames=:3 :0
/:~(<ScenarioPrefix,":y),&.>DataSheetNames
)
SortScenario=:4 :0
scn=.}.y[hd=.0{y
'on date method'=.<"1 |:(hd i.;:'On OnDate Method'){"1 scn
bm=.(a:=on)+.(<'on')=tolower&.>on-.&.>' '
scn=.bm#scn[date=.bm#date[method=.bm#method
'no active scenario rows'assert 0<#scn
hd,scn{~/:((/:~~.date)i.date),.x i.method
)
Swag=:4 :0
scfx=.ScenarioPrefix,":y[sspx=.SSpreadPrefix,":y
scn=.scfx,'Forecast',SheetSuffix
('scenario not loaded: ',scn)assert 0=nc<scn
bal=.(y;<x)ComputeScenario".scn
bst=.sspx BalanceStatistics bal
(toHOST fmttd bal)write f0=.TABSheetPath,scfx,'Forecast',SheetExt
(toHOST fmttd bst)write f1=.TABSheetPath,scfx,'Stats',SheetExt
f0;f1
)
SwagTest=:4 :0
'scn opt'=.2{.y
strg=.scn ScenarioTimeRange x
if.fomover=.opt=2 do.
FirstOfMonthOverride_Swag_=:_10000+{.scn ScenarioTimeRange x
smoutput'first of month set to: ',":FirstOfMonthOverride_Swag_
end.
opt=.opt=0
dates=.FirstMonthRange strg
past=.dates<FirstOfMonth 0
shd=.SheetHeader 0
bnm=.((#dates),#shd)$0
bnm=.(opt*2000>.?.8000)(i0=.shd XrefSeries'salary')}"1 bnm
bnm=.(opt*2>.?.10)(i1=.shd XrefSeries'dividends')}"1 bnm
bnm=.(opt*5000>.?.200000)(shd XrefSeries'rssavings')}"1 bnm
bnm=.(opt*15000>.?.50000)(shd XrefSeries'rsinvest')}"1 bnm
bnm=.(opt*600>.?.2000)(e0=.shd XrefSeries'house')}"1 bnm
bnm=.(opt*2000>.?.4000)(e1=.shd XrefSeries'living')}"1 bnm
bnm=.(opt*100>.?.200)(e2=.shd XrefSeries'insurance')}"1 bnm
bnm=.past*"0 1 bnm
inc=.inx{bnm[inx=.<a:;i0,i1
bnm=.(inc+(]`?.)@.(0<[)"0[500<.>.inc)inx}bnm
exp=.exx{bnm[exx=.<a:;e0,e1,e2
bnm=.(exp+(]`?.)@.(0<[)"0[500<.>.exp)exx}bnm
fadd=.'CAdd_Swag_'
(fadd)=:+/"1
bnm=.(IncomeSeries FuncSheetSeries fadd;bnm)(<a:;shd i.<'Itotal')}bnm
bnm=.(ExpenseSeries FuncSheetSeries fadd;bnm)(<a:;shd i.<'Etotal')}bnm
bnm=.(ReserveSeries FuncSheetSeries fadd;bnm)(<a:;shd i.<'Rtotal')}bnm
bnm=.(DebtSeries FuncSheetSeries fadd;bnm)(<a:;shd i.<'Dtotal')}bnm
fsub=.'CSub_Swag_'
(fsub)=:-/"1
bnm=.((;:'Itotal Etotal')FuncSheetSeries fsub;bnm)(<a:;shd i.<'BB')}bnm
fnw=.'Netw_Swag_'
(fnw)=:-~`+`(-~)`:3"1
bnm=.((;:'Dtotal Rtotal Etotal Itotal')FuncSheetSeries fnw;bnm)(<a:;shd i.<'NW')}bnm
bal=.'d<0>'(8!:0)bnm
bal=.shd ,(FormatSheetDates dates)(<a:;shd i.<'Date')}bal
ppfx=.TABSheetPath,ScenarioPrefix,":scn
(toHOST fmttd bal)write f0=.ppfx,'Forecast',SheetExt
(toHOST fmttd bal)write f1=.ppfx,'Actuals',SheetExt
f0;f1
)
TranOnOffRange=:4 :0
'numx rsn dbtn'=.x['cn cv'=.y
optx=.4}.numx['fom value ondate offdate'=.4{.numx
if.offdate<:fom do.NoChange return.end.
'Fee LoanEquity'=.2{.optx
(ReserveArguments)=.rsn
(DebtArguments)=.dbtn
ralloc=.AllocTable|&.>".&.>ReserveArguments
asn=.cn {~cn XrefSeries ReserveSeriesNames
dalloc=.0 AllocTable|&.>".&.>DebtArguments
dsn=.cn {~cn XrefSeries DebtSeriesNames
'reserve allocation length mismatch'assert(#ReserveSeriesNames)={:$ralloc
'debt allocation length mismatch'assert(#DebtSeriesNames)={:$dalloc
rtr=.(1 1-:+/"1 ralloc)*0=+/,dalloc
rtd=.(1 =0{+/"1 ralloc)*1 =0{+/"1 dalloc
'invalid transfer allocation'assert 1=rtr+rtd
(cn)=.cv
rfx=.<a:;px=.(ondate,offdate)RangeIndexes Date
sie=.".&>asn
EF=.(Fee+px{EF)px}EF
if.rtr do.
sie=.((rfx{sie)-"1 0 value*0{ralloc)rfx}sie
sie=.((rfx{sie)+"1 0 value*1{ralloc)rfx}sie
U2=.(value+px{U2)px}U2
(<'EF';'U2';asn),<EF,U2,sie
else.
hcm=.".&>dsn
pp=.(rfx{hcm)<."1 0 value*0{dalloc
pp=.value<.({."1 pp),.}:"1 spp*0<spp=.(rfx{hcm)-+/\"1 pp
sie=.((rfx{sie)-"1(+/pp)*"1 0[0{ralloc)rfx}sie
U2=.((+/pp)+px{U2)px}U2
px2=.Date i.offdate
fb=.(px2}."1 hcm)-"1 0+/"1 pp
fb=.(0<fb)*fb
hcm=.((rfx{hcm)-(0{dalloc)*/+/\+/|rfx{sie)rfx}hcm
hcm=.(px2{."1 hcm),.fb
'debts cannot be negative'assert 0<:<./,hcm
if.LoanEquity~:0 do.
rqv=.cv{~cn XrefSeries'rsequity'
rqv=.((LoanEquity*+/,pp)+px{rqv)px}rqv
sie=.rqv(asn XrefSeries'rsequity')}sie
end.
(<'EF';'U2';asn,dsn),<EF,U2,sie,hcm
end.
)
ValuesFromSheet=:[:|:[:".&>[:}.]{"1~(0{])i.[:boxopen[
WithoutNumerals=:(<'-0123456789. ')-.&.>~]
WithoutQuoted=:]#~(<'''''')~:({.,{:)&.>
XrefSeries=:3 :0
(0$a:)XrefSeries y
:
try.
'sn nn'=.SeriesNameXref 0
xn=.sn{~nn i.bn=.boxopen y
if.#x do.x i.xn else.]`;@.(1=#)xn end.
catch.
('names not in series cross reference: ',;(~.bn),&.>' ')assert 0
end.
)
alltrim=:]#~[:-.[:(*./\.+.*./\)' '&=
amort=:3 :0
if.3~:#y do.
'frq int yrs'return.end.
'f i y'=.y
len=.f*y
i=.<:(>:i)^%f
vn=.*/\1,len$%>:i
osb=.osb%{.osb=.|.-.}.vn
pay=.%+/}.vn
pp=.pay-ip=.osb*i
pay,.osb,.ip,.pp
)
assert=:0 0"_$13!:8^:((0:e.])`(12"_))
boxopen=:<^:(L.=0:)
datefrint=:0 100 100&#:@<.
dev=:-"_1 _ mean
erase=:[:4!:55;: ::]
fboxname=:([:<8 u:>) ::]
fexist=:1:@(1!:4) ::0:@(fboxname&>) @boxopen
fmttd=:[:(],((10{a.)"_={:)}.(10{a.)"_)[:}.@(,@(1&(,"1)@(-.@(*./\."1@(=&' '@]))))#,@((10{a.)&(,"1)@]))[:}."1[:;"1(9{a.)&,@":&.>
intfrdate=:0 100 100&#.@:<.
ischar=:2&=@(3!:0)
kurtosis=:#*+/@(^&4)@dev%*:@ssdev
mean=:+/%#
median=:-:@(+/)@((<.,>.)@midpt{/:~)
midpt=:-:@<:@#
monthdates=:3 :0
days=.,/(,y),"0 1/,/(>:i.12),"0/,1
:
0 100 100#.monthdates y
)
nc=:4!:0
q1=:median@((median>]) #]) ::_:
q3=:median@((median<]) #]) ::_:
read=:1!:1&(]`<@.(32&>@(3!:0)))
readtd2=:[:<;._2&>(9{a.),&.>~[:<;._2[:(],((10{a.)"_={:)}.(10{a.)"_)(13{a.)-.~1!:1&(]`<@.(32&>@(3!:0)))
skewness=:%:@#*+/@(^&3)@dev%^&1.5@ssdev
smoutput=:0 0$1!:2&2
ssdev=:+/@:*:@dev
stddev=:%:@:var
toCRLF=:2&}.@:;@:((13{a.)&,&.>@<;.1@((10{a.)&,)@toJ)
toHOST=:toCRLF
toJ=:((10{a.)I.@(e.&(13{a.))@]}])@:(#~-.@((13 10{a.)&E.@,))
tolower=:3 :0
x=.I.26>n=.((65+i.26){a.)i.t=.,y
($y)$((x{n){(97+i.26){a.)x}t
)
toupper=:3 :0
x=.I.26>n=.((97+i.26){a.)i.t=.,y
($y)$((x{n){(65+i.26){a.)x}t
)
valdate=:3 :0
s=.}:$y
'w m d'=.t=.|:((*/s),3)$,y
b=.*./(t=<.t),(_1 0 0<t),12>:m
day=.(13|m){0 31 28 31 30 31 30 31 31 30 31 30 31
day=.day+(m=2)*-/0=4 100 400|/w
s$b*d<:day
)
var=:ssdev%<:@#
write=:1!:2]`<@.(32&>@(3!:0))

NB.POST_Swag post processor. 

smoutput 0 : 0
NB. interface word(s):
NB. FutureScenarios  NB. compute scenarios (y) as if all dates in future
NB. LoadConfig       NB. loads shared configuration sheets
NB. LoadSheets       NB. loads TAB delimited scenario actuals and forecast sheets
NB. RunTest          NB. run test scenario
NB. RunTheNumbers    NB. compute all scenarios on list (y)
NB. Swag             NB. compute Silly Wild Ass Guess forecast TAB delimited sheets
NB. SwagTest         NB. generates simulated scenario test sheets
)

cocurrent 'base'
coinsert  'Swag'

