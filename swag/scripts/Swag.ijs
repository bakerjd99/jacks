NB.*Swag s-- personal cash flow forecasting.
NB.
NB. verbatim:
NB.
NB. interface word(s):
NB. ------------------------------------------------------------------------------
NB.  FutureScenarios - compute scenarios (y) as if all dates in future
NB.  LoadConfig      - loads shared configuration sheets
NB.  LoadSheets      - loads TAB delimited scenario actuals and forecast sheets
NB.  RunTest         - run test scenario
NB.  RunTheNumbers   - compute all scenarios on list (y)
NB.  Swag            - compute Silly Wild Ass Guess forecast TAB delimited sheets
NB.  SwagTest        - generates simulated scenario test sheets
NB.
NB. created: 2015Oct04
NB. changes: ----------------------------------------------------------------------

cocurrent 'Swag'
NB.*end-header

NB. numeric value bound to execute
BadNumber=:_999999

NB. balance series names
BalanceSeries=:<;._1 ' BB NW'

NB. configuration sheet names without suffix
ConfigSheetNames=:<;._1 ' CrossReference Parameters'

NB. blcl names of credit and charge utility series
CreditChargeSeries=:<;._1 ' IC EC EF'

NB. name cross reference btcl table
CrossReferenceSheet=:0 0$a:

NB. a blcl of named custom series verbs
CustomSeriesVerbs=:0$a:

NB. data sheet names without suffix
DataSheetNames=:<;._1 ' Actuals Forecast'

NB. debt series names
DebtSeries=:<;._1 ' D0 D1 D2 D3 D4'

NB. debt series names in allocation order
DebtSeriesNames=:<;._1 ' dbhouse dbcar dboptional dbother dbmedical'

NB. expense series names
ExpenseSeries=:<;._1 ' E0 E1 E2 E3 E4 E5 E6 E7 E8 EC EF'

NB. interface words (IFACEWORDSSwag) group
IFACEWORDSSwag=:<;._1 ' FutureScenarios LoadConfig LoadSheets Swag SwagTest RunTest RunTheNumbers'

NB. income series names
IncomeSeries=:<;._1 ' I0 I1 I2 I3 I4 I5 IC'

NB. main cross reference and parameter settings
MainConfiguration=:<;._1 ' CrossReference Parameters'

NB. method argument parameters set to 0 for default
MethodArguments=:<;._1 ' MethodArguments BackPeriods Fee Initial Interest LoanEquity YearInflate Schedule YearTerm DHouse DCar DOptional DOther DMedical RSavings RInvest REquity ROther'

NB. defines application order of various methods - first item is method column
MethodOrder=:<;._1 ' Method assume history reserve borrow transfer spend'

NB. J tokens that appear in MethodArguments
MethodTokens=:;:'()[=.'

NB. set to either (TestConfiguration) or (MainConfiguration)
ModelConfiguration=:0$a:

NB. locale name of cash flow model
ModelLocale=:'Swag'

NB. value returned by series methods when no series are changed
NoChange=:'';i.0

NB. root words (ROOTWORDSSwag) group
ROOTWORDSSwag=:<;._1 ' FutureScenarios IFACEWORDSSwag MainConfiguration ROOTWORDSSwag RepeatScenario RunTheNumbers TestConfiguration'

NB. reserve series names
ReserveSeries=:<;._1 ' R0 R1 R2 R3'

NB. reserve series names in allocation order
ReserveSeriesNames=:<;._1 ' rssavings rsinvest rsequity rsother'

NB. spreadsheet label prefix
SSpreadPrefix=:'-s'

NB. scenario name prefix - appears in spreadsheets
ScenarioPrefix=:'s'

NB. TAB delimited sheet file extension
SheetExt=:'.txt'

NB. sheet name suffix
SheetSuffix=:'Sheet'

NB. path TAB delimited data actual data
TABRawPath=:'c:/jod/mep/alien/mep/rawact/'

NB. path to spread sheet TAB delimited data
TABSheetPath=:'c:/jod/mep/alien/mep/tabsheets/'

NB. test cross reference and parameter settings
TestConfiguration=:<;._1 ' CrossReference TestParameters'

NB. sums of series names
TotalSeries=:<;._1 ' Etotal Itotal Rtotal Dtotal'

NB. series used to track internal model state
UtilitySeries=:<;._1 ' U0 U1 U2 U3'

NB. when nonzero uniform random noise is added by history - see (FuncOnOffRange)
VaryHistory=:0


AccumulateSeries2=:4 : 0

NB.*AccumulateSeries2  v--  accumulate rate  adjusted current and
NB. future series credits and charges.
NB.
NB. dyad:  nl =. ia AccumulateSeries2 ntSeriesGrowth
NB.
NB.   sr=. ((15#100),0 0 _80 0 0 200 200) ,: (30#1),20$1.001667 0.98 1
NB.   3 AccumulateSeries2 sr
NB.
NB.   NB. same as (AccumlateSeries3) for rates of 1
NB.   ((37,36{0{sr) AccumulateSeries3 0{sr) -: 37 AccumulateSeries2 (0{sr) ,: 1

'sv gr'=. y

NB. forward last actuals and accumulate rate adjusted
NB. NOTE: assumes relevant actuals in series
pv=. x {. sv
cv=. (_1 {. pv) , x }. sv
cg=. (_1 {. x {. gr) , x }. gr

for_j. i.<:#cv do.
  cv=. (((>:j){cv) + (j{cg) * j{cv) (>:j)} cv
end.

pv , }. cv
)

NB. accumulate series from (0{x) with (1{x) as initial value - see long document
AccumulateSeries3=:(] {.~ 0 { [) , [: }. [: +/\ (1 { [) , ] }.~ 0 { [


ActualFromRaw=:3 : 0

NB.*ActualFromRaw v-- numeric actuals from TAB delimited raw files. 
NB.
NB. monad:  ft =. ActualFromRaw clFile
NB.
NB.   ActualFromRaw 'c:/jod/mep/alien/mep/rawact/RawIncome.txt'

'cross reference not loaded' assert 0 < #CrossReferenceSheet

t=. }. ((0{t) i. ;:'Date Name Amount'){"1 t=. readtd2 y
d=. BadNumber&".&> (0 {"1 t) -.&.> '-'
('invalid dates in raw file: ',y) assert valdate datefrint d 

d=. d,.((SheetHeader 0) XrefSeries 1 {"1 t),.BadNumber&".&> 2 {"1 t
('invalid numbers in raw file: ',y) assert -.BadNumber e. ,d

'to many columns for key encoding' assert 100 > >./1 {"1 d
ym0=. 100 * 100 <.@%~ 0 {"1 d
b=. ~:t=. ym0 + 1 {"1 d 

NB. aggregate by (name) to first of month
(>:b # ym0),.(b # 1 {"1 d),.t +//. 2 {"1 d
)


ActualSheet=:3 : 0

NB.*ActualSheet v-- read raw actual TAB delimited files and form actuals sheet.
NB.
NB. monad:  btcl =. ActualSheet uuIgnore

fom=. FirstOfMonth 0

NB. read raw files and reduce to month aggregates
f=. ;:'RawIncome RawReserves RawExpenses'
f=. (<TABRawPath) ,&.> f ,&.> <SheetExt
'missing raw actual files' assert fexist f
d=. /:~ ;ActualFromRaw&.> f

NB. remove any current or future months
d=. d #~ fom > 0 {"1 d

NB. form actuals table
h=. SheetHeader 0
r=. FirstMonthRange (<./ , >./) 0 {"1 d
a=. r (<a:;0)} a=. ((#r),#h) $ 0
a=. (2 {"1 d) (<"1((0 {"1 a) i. 0 {"1 d) ,. 1 {"1 d)} a

NB. total columns
a=. (+/"1 (h i. ExpenseSeries){"1 a) (<a:;eC=. h i. <'Etotal')} a
a=. (+/"1 (h i. IncomeSeries){"1 a) (<a:;iC=. h i. <'Itotal')} a
a=. (+/"1 (h i. ReserveSeries){"1 a) (<a:;rC=. h i. <'Rtotal')} a
a=. (+/"1 (h i. DebtSeries){"1 a) (<a:;dC=. h i. <'Dtotal')} a

NB. basic balance and net worth
a=. (-/"1 (iC,eC){"1 a) (<a:;bC=. h i. <'BB')} a
rdd=. -/"1 (rC,dC) {"1 a
nw=. rdd + 0 0 AccumulateSeries3 bC {"1 a
a=. nw (<a:;h i. <'NW')} a

NB. NOTE: actual net worth in utility series to prevent double counting
a=. ({:nw) (<(<:#a);h i. <'U0')} a

NB. format actuals sheet
h,(FormatSheetDates 0 {"1 a) ,. }."1 (8!:0) a 
)


AllocOnOffRange=:4 : 0

NB.*AllocOnOffRange v-- reserve and spend series adjustments and allocations.
NB.
NB. dyad:  ((<blcl) ,< nt) =. (clSeries ; (<nl) ,< blnl) AllocOnOffRange ((<blclSeries) ,< nt)

'snc numx rsn'=. x [ 'cn cv'=. y
optx=. 4 }. numx [ 'fom value ondate offdate'=. 4 {. numx
if. offdate <: fom do. NoChange return. end.

NB. optional reserve and spend arguments !(*)=. ReserveArguments
'Fee Initial'=. 2 {. optx
(ReserveArguments)=. rsn

NB. reserve allocation 
ralloc=. AllocTable |&.> ".&.> ReserveArguments
asn=. cn {~ cn XrefSeries ReserveSeriesNames
'reserve allocation length mismatch' assert (#ReserveSeriesNames)={:$ralloc

(cn)=. cv  NB. local series !(*)=. Date IC EC EF U0 U1

NB. period indexes and relevant allocation
rfx=. <a:;px=. (ondate,offdate) RangeIndexes Date
sie=. ".&> asn
if. snc -: 'IC' do.
  NB. reserve: fee adjusted value to allocation over period
  sie=. ((rfx{sie) +"1 0 value * 0{ralloc) rfx} sie
  EF=. (Fee + px{EF) px} EF
  NB. NOTE: charge expenses if not initial this is the only 
  NB. place in the system that adds to expense charges EC
  if. Initial=0 do.
    EC=. (value + px{EC) px} EC
  else.
    IC=. (Fee + px{IC) px} IC
    NB. store introduced funds this system does not create money
    U0=. (value + px{U0) px} U0
  end.
elseif. snc -: 'EC' do.
  NB. spend: fee adjusted value from allocation over period
  'Initial must be zero for spend' assert Initial=0
  sie=. ((rfx{sie) -"1 0 value * 0{ralloc) rfx} sie
  U1=. (value + px{U1) px} U1  NB. expenditures
  EF=. (Fee + px{EF) px} EF    NB. fee expense
elseif.do. 'invalid allocation method' assert 0       
end.
(<(;:'IC EC EF U0 U1'),asn) ,< IC,EC,EF,U0,U1,sie
)


AllocTable=:3 : 0

NB.*AllocTable v-- forms standard numeric allocation table.
NB.
NB. monad: nt =. AllocTable blnl
NB.
NB.   AllocTable 0 ; 0 ; 0  
NB.   AllocTable 0.2 ; 0.6 ; 0.2
NB.   AllocTable 0 0.8 ; 1 ;0 0.2 ; 0 0
NB. 
NB.   AllocTable 0.8 ; 0.9 ; 0    NB. invalid
NB.   AllocTable 0 0;0 0.7;0 0.4  NB. invalid
NB. 
NB. dyad: nt =. ia AllocTable blnl
NB.
NB.   0 AllocTable 0 ; 0 ; 0 ; 0

1 AllocTable y
:
NB. put 100% of zero allocations into first position
at=. |: 2 {.&> y
at=. x (<(I. 0 = +/"1 at);0)} at

NB. rows must sum to 0 or 1
'invalid allocation' assert (+/"1 at) e. 0 1
at
)


ApplyScenarioMethod=:4 : 0

NB.*ApplyScenarioMethod v-- applies scenario method.
NB.
NB. dyad:  (blcl ,< nt) =. btclHeadMethodRow ApplyScenarioMethod  (iaYYYYMM01 ; blclSeries ; ntDateValues) 

'hp sm'=. <"1 x  NB. header and scenario parameter row   
'fom cn cv'=. y  NB. first of month, series names, series values 

mn=.   ;sm {~ hp i. <'Method'
marg=. ;sm {~ hp i. <'MethodArguments'

NB. set method defaults in local scope then override
NB. !(*)=. BackPeriods Fee House Initial Interest LoanEquity Schedule YearInflate YearTerm 
NB. !(*)=. DebtArguments ReserveArguments
try.
  ".marg [ (MethodArguments)=. 0
catch.
  ('invalid method arguments: ',marg) assert 0
end.

NB. arguments that are always present
ondate=.  ".(;sm {~ hp i. <'OnDate') -.'-'
offdate=. ".(;sm {~ hp i. <'OffDate') -.'-'
value=.   ". ;sm {~ hp i. <'Value'
fvof=. fom,value,ondate,offdate

select. mn

  case. 'assume' do.
    (fvof;<".&.> ReserveArguments) AssumeOnOffRange 0{cv

  case. 'history' do.
    (1{cn);(HistAddFuncs_Swag_,<fvof,BackPeriods,YearInflate) FuncHistOnOffRange 0 1{cv

  case. 'reserve' do.
    ('IC';(<fvof,Fee,Initial),<".&> ReserveArguments) AllocOnOffRange cn;cv

  case. 'transfer' do.
    ((<fvof,Fee,LoanEquity),(<".&.> ReserveArguments),<".&.> DebtArguments) TranOnOffRange cn;cv

  case. 'borrow' do.
    ((<fvof,Fee,Interest,LoanEquity,YearTerm),(<Schedule),(<".&.> ReserveArguments),<".&> DebtArguments) BorrowOnOffRange cn;cv
    
  case. 'spend' do.
    ('EC';(<fvof,Fee,Initial),<".&.> ReserveArguments) AllocOnOffRange cn;cv
 
  case.do. 'invalid scenario method' assert 0
end.
)


AssumeOnOffRange=:4 : 0

NB.*AssumeOnOffRange v-- set monthly  reserve growth assumptions for period.
NB.
NB. Growth   assumptions   are   set   in   (ondate)   order   by
NB. (ComputeScenario). Rate stays in effect until changed.
NB.
NB. dyad:  (nl ; < blnl) AssumeOnOffRange ilYYYYMM01

'numx rsn'=.x [ Date=. y
'fom value ondate offdate'=. 4 {. numx

if. offdate > fom do.
  'invalid assumptions rates are single numbers' assert 1 = #&> rsn

  rsn=. ;rsn
  rsn=. value (I. 0 = rsn) } rsn  NB. set default rates
  rsn=. ,. >: (rsn%100) % 12      NB. nominal year rates to month rates

  px=. (ondate,offdate) RangeIndexes Date  NB. HARDCODE: locale suffix
  ReserveGrowth_Swag_=: (rsn#"1~#px) (<(>:i.#rsn);px)} ReserveGrowth_Swag_
end.

NoChange
)


BalanceStatistics=:4 : 0

NB.*BalanceStatistics v-- standard statistics for various series.
NB.
NB. dyad:  btcl =. clScn BalanceStatistics btclForecast
NB.
NB.   '-s0' BalanceStatistics bal

dates=. DateFromSheet y
sheet=. FormatStatSheet (x,'Balance') SeriesYearStatistics dates ,. 'BB' ValuesFromSheet y
sheet=. sheet ,. 2 }."1 FormatStatSheet (x,'Networth') SeriesYearStatistics dates ,. 'NW' ValuesFromSheet y
sheet=. sheet ,. 2 }."1 FormatStatSheet (x,'Reserves') SeriesYearStatistics dates ,. 'Rtotal' ValuesFromSheet y
sheet=. sheet ,. 2 }."1 FormatStatSheet (x,'Debts') SeriesYearStatistics dates ,. 'Dtotal' ValuesFromSheet y

NB. equity is excluded from basic balance but can serve as a last resort fund
equity=. XrefSeries 'rsequity'
sheet ,. 2 }."1 FormatStatSheet (x,'Equity') SeriesYearStatistics dates ,. equity ValuesFromSheet y
)


BorrowOnOffRange=:4 : 0

NB.*BorrowOnOffRange v-- borrows value at period start and sets future loan payments.
NB.
NB. dyad:  ((<blcl) ,< nt) =. (nl ; cl ; (<blnl) ,< blnl) BorrowOnOffRange ((<blclSeries) ,< nt)

'numx Schedule rsn dbtn'=.x [ 'cn cv'=. y
optx=. 4 }. numx [ 'fom value ondate offdate'=. 4 {. numx
if. offdate <: fom do. NoChange return. end.

NB. optional borrow arguments !(*)=. DebtArguments ReserveArguments
'Fee Interest LoanEquity YearTerm'=. 4 {. optx
(DebtArguments)=. dbtn
(ReserveArguments)=. rsn

NB. loans are payed from one source and tied to one debt series
darg=. 0 ~: {.@".&> DebtArguments
rarg=. 0 ~: {.@".&> ReserveArguments
if. 0 = +/darg do. darg=. 1 (DebtArguments i. <'DOther')} darg end.
'invalid loan payment and debt series pairing' assert (1 = +/darg) *. (+/rarg) e. 0 1

NB. debt series holds outstanding balances
ds=. cn {~ cn XrefSeries ;(I. darg){DebtSeriesNames

NB. equity series holds principal part of loans
ps=. cn {~ cn XrefSeries 'rsequity'

NB. assign payment reserve series or default to loan expense 
if. 0 = +/rarg do. 
  pcc=. 1 [ pmtn=. 1{cn
else.
  pcc=. _1 [ pmtn=. cn {~ cn XrefSeries ;(I. rarg){ReserveSeriesNames
end.

(cn)=. cv  NB. series in local scope !(*)=. Date U3
px=. (ondate,offdate) RangeIndexes Date

NB. amortization from verb or schedule
if. ischar Schedule=. ,Schedule do.
  ('amortization schedule missing: ',Schedule) assert fexist Schedule
  NB. schedules are numeric tables formated as TAB delimited text with a header
  NB. columns match the (amort) verb: payment, outstanding, interest, principal
  at=. |: BadNumber&".&> }. readtd2 Schedule
  'invalid amortization schedule table' assert -. (BadNumber e. at) +. 4 ~: #at
else.
  NB. monthly level loan payment amortization table 
  if. YearTerm=0 do. YearTerm=. 1 >. -/ 10000 <.@%~ offdate,ondate end.
  at=. |: value * amort 12,(Interest%100),YearTerm
end.

NB. debts start when period starts payments start next month
lb=. _1{(#px){.ob [ 'pp ob'=. 0 1{at

NB. out standing period loan balances added to debt series
dv=. ((px{dv) + (#px){.ob) px} dv=. ".&> ds

NB. payments added to payment series and shifted one month forward
cv=. ((cv {~ >:px) + pcc * (#px){.pp) (>:px)} cv=. ".&> pmtn

NB. mark payments for audit
U3=. (((#px){.pp) + (>:px){U3) (>:px)} U3

pv=. ".&> ps
if. LoanEquity ~: 0 do.
  NB. add principal part of period loan payments to overall equity
  pv=. ((pv {~ >:px) + (#px){. 3{at) (>:px)} pv
end.

NB. if the debt is not paid off in the on,off
NB. period carry outstanding balance forward
if. lb > 0{0{at do.
  px=. I. +./\offdate = Date 
  dv=. (lb + px{dv) px} dv 
end.

NB. changed series 
(<ds,(<'U3'),pmtn,ps),<dv,U3,cv,:pv
)


CheckConfigSheets=:3 : 0

NB.*CheckConfigSheets v-- checks loaded configuration sheets.
NB.
NB. monad:  blcl =. CheckConfigSheets blclSheetNames

nouns=. y

'two config sheets expected' assert 2 = #nouns
'sheets are not all nouns'   assert 0 = nc nouns

dat=. ".&.> nouns
msk=. (<;:'OnDate OffDate') *./@e.&> {.&.> dat
'on/off dates missing from config sheets' assert +./msk
parm=. ; dat #~ msk
xref=. ; dat #~ -.msk
dates=. OnOffDates parm
dymd=.  datefrint ,dates

NB. series methods includes header
'unknown series methods' assert MethodOrder e.~ parm {"1~ (0{parm) i. <'Method'

NB. check scenario dates
'invalid on/off dates' assert valdate dymd
'on/off dates not all first of month' assert */ 1 = {:"1 dymd
'on/off dates out of order' assert </"1 dates

NB. check name cross references
shd=. SheetHeader 0
'sheet header names not unique' assert ~: shd
'total series names not in header' assert TotalSeries e. shd
xnames=. xref {"1~ (0{xref) i. <'Name'
'cross reference names not unique' assert ~: xnames
pnames=. parm {"1~ (0{parm) i. <'Name'
'parameter names not in cross reference' assert pnames e. xnames
snames=. xref {"1~ (0{xref) i. <'SeriesName'
'series names not unique' assert ~: snames
'sheet header names not in cross reference' assert shd e. snames
'debt series long names not in cross reference' assert DebtSeriesNames e. xnames
'reserve series long names not in cross reference' assert ReserveSeriesNames e. xnames

NB. all these name lists must be unique
'total series names not unique'     assert ~: TotalSeries
'income series names not unique'    assert ~: IncomeSeries 
'reserve series names not unique'   assert ~: ReserveSeries
'expense series names not unique'   assert ~: ExpenseSeries
'debt series names not unique'      assert ~: DebtSeries
'debt series long names not unique' assert ~: DebtSeriesNames
'balance series names not unique'   assert ~: BalanceSeries
'utility series names not unique'   assert ~: UtilitySeries
'credit charge series names not unique' assert ~: CreditChargeSeries
'method arguments names not unique' assert ~: MethodArguments

NB. important correspondences
'reserve series names length mismatch' assert (#ReserveSeriesNames) = #ReserveSeries
'debt series names length mismatch'    assert (#DebtSeriesNames) = #DebtSeries

NB. set and check method arguments: HARDCODE: 2 prefix length, 'R' 'D' prefixes
('ReserveArguments_',ModelLocale,'_')=: 'R' ,&.> 2 MargNames ReserveSeriesNames
('DebtArguments_',ModelLocale,'_')=: 'D' ,&.> 2 MargNames DebtSeriesNames
NB. !(*)=. ReserveArguments DebtArguments
'reserve argument names invalid' assert ReserveArguments e. MethodArguments
'debt argument names invalid' assert DebtArguments e. MethodArguments

NB. smoke test method arguments
dat=. CheckMethodArguments parm {"1~ (0{parm) i. <'MethodArguments'

nouns
)


CheckMethodArguments=:3 : 0

NB.*CheckMethodArguments v-- checks method argument syntax.
NB.
NB. The  MethodArguments  column of  the parameters  sheet uses a
NB. restricted  subset  of  J  syntax  to  define mostly optional
NB. arguments to various series methods.
NB.
NB. This verb  detects only bonehead  argument errors. Many lines
NB. of  J  will  pass  these  basic tests  and  still  be invalid
NB. MethodArguments.
NB.
NB. monad:  pa =. CheckMethodArguments blclMarg

NB. attempt parsing and display any bad arguments
pg=. (;: :: _9:)&.> y
if. 1 e. bm=. pg e. <_9: '' do.
  smoutput bm # y
end.
'method arguments do not parse' assert -. bm

NB. detect invalid tokens by removing all valid tokens
NB. assumes any number representations are removed
mt=. MethodTokens,MethodArguments
pg=. a: -.~ WithoutNumerals WithoutQuoted mt -.~ ;pg
if. #pg=. pg -. CustomSeriesVerbs do.
  smoutput pg
end.
'method arguments contain unknown name tokens' assert 0 = #pg

NB. basic tests passed
1
)


CheckSheets=:3 : 0

NB.*CheckSheets v-- checks loaded sheets.
NB.
NB. monad:  blcl =. CheckSheets blclSheetNames

nouns=. y

'sheets are not all nouns' assert 0 = nc nouns

dat=. ".&.> nouns
'sheet data header mismatch' assert (</:~ SheetHeader 0) -:&> /:~&.> 0&{&.> dat
'sheet row count mismatch'   assert 1 = # ~. #&> dat
'sheet date column mismatch' assert 1 = # ~. (0&{"1)&> dat
dymd=. datefrint dates=. ".&> (}.0&{"1 &> [ 0{dat) -.&.> '-'
'invalid sheet dates' assert valdate dymd
'dates out of order'  assert (i.#dates) -: /: dates
'not all first of month' assert */ 1 = {:"1 dymd
months=. (0 {"1 dymd) </. 1 {"1 dymd
'months out of order' assert  (i.@#&.> months) -: /:&.> months
'months have gaps' assert 0 = # 1 -.~ ; (}. - }:) &.> months

nouns
)


ComputeScenario=:4 : 0

NB.*ComputeScenario v-- calculate scenario table.
NB.
NB. dyad:  btclSheet =. (ia ; <btclParameters) ComputeScenario btclActuals
NB.
NB.   (0;<ParametersSheet) ComputeScenario s0ForecastSheet

sl=. ScenarioPrefix,":scn [ 'scn pn'=. x

NB. define argument functions
lfuncs=. FuncArguments ModelLocale

NB. remove any border blanks 
hdp=. (0{pn) -.&.> ' '
hdx=. hdp i. ;:'Name Scenario Method'
pn=. (alltrim&.> (<a:;hdx){pn) (<a:;hdx)} pn

NB. prepare scenario parameters
'no scenario rows selected' assert 0 < #pn=. sl SelectScenario pn
pn=. MethodOrder SortScenario pn
tr=. scn ScenarioTimeRange pn

NB. series visible in local scope !(*)=. Date EC U0
ssn=. 0 {"1 ss=. (1{tr) SeriesFromSheet y
(ssn)=. 1 {"1 ss

NB. all first of month dates must exist in sheet dates
NB. and sheet date range must be large enough for calculations
('scenario dates missing: ',sl) assert Date e.~ , OnOffDates pn
'scenario date range insufficient' assert tr e. Date

NB. reserve growth rate assumption table HARDCODE: locale suffix
ReserveGrowth_Swag_=: Date , 1 $~ (#ReserveSeries),#Date

NB. zero future and retain before changes past
fx=. Date < fom=. FirstOfMonth 0
ssd=. (ssn) -. <'Date'
psd=. fx #"1 ".&>ssd
(ssd)=. (<fx) *&.> ".&.> ssd

NB. restrict series changes to current and future
ifx=. I. -.fx

NB. series names
'sn nn'=. SeriesNameXref 0

rn=. CreditChargeSeries,ReserveSeries,DebtSeries,UtilitySeries

pn=. }. pn
sx=. hdp i. <'Name'
for_sm. pn do.
  cn=. sn {~ nn i. sx { sm        NB. current series name
  cv=. ".&> csn=. ~.'Date';cn,rn  NB. current dated series values                 
  'asn nv'=. (hdp,:sm) ApplyScenarioMethod fom;csn;cv
  if. 0=#asn do. continue. end.
  (asn)=. (ifx{"1 nv) ifx}"1 ".&>asn    
end.

NB. compute basic series period totals preserving past
Itotal=. (ifx { +/ ".&> IncomeSeries)  ifx} Itotal 
Etotal=. (ifx { +/ ".&> ExpenseSeries) ifx} Etotal
Dtotal=. (ifx { +/ ".&> DebtSeries) ifx} Dtotal
BB=. (ifx { Itotal - Etotal) ifx} BB

NB. project rate adjusted reserves over future
px=. (fom>:{.Date) * Date i. fom
for_rs. ReserveSeries do.
  rsv=.  px AccumulateSeries2 (".;rs) ,: (>:rs_index){ReserveGrowth_Swag_
  (rs)=. (ifx{rsv) ifx} rsv
end.
Rtotal=. (ifx { +/ ".&> ReserveSeries) ifx} Rtotal

NB. make past/current future adjustments 
aec=. - +/fx#EC [ rdd=. Rtotal - Dtotal
if. +./fx do.
  NB. scenario has past months adjust for expense charges and Intial~:0 deposits
  rdd=. (aec + ifx{rdd) ifx} rdd
  if. 0=+/fx#U0 do. aec=.0
  elseif. aec=0 do. rdd=. (}. +/\ 0,ifx { 0,(}.-}:) rdd) ifx} rdd 
  end.
end.

NB. estimate net worth and check changes
NW=. (ifx{rdd + (px,aec+(<:px){NW,0) AccumulateSeries3 BB) ifx} NW
'past has changed' assert psd -: fx #"1 ".&>ssd
'debts cannot be negative' assert 0 <: <./ ,".&> DebtSeries

NB. sheet from local scope series
ssn SheetFromSeries ".&.> ssn
)

NB. extract integer YYYYMMDD dates from TAB delimited sheet
DateFromSheet=:[: ".&> [: }. '-' -.&.>~ ] {"1~ (<'Date') i.~ 0 { ]


FirstMonthRange=:3 : 0

NB.*FirstMonthRange v-- forms valid first of month dates.
NB.
NB. monad: ilYYYYMM01 =. FirstMonthRange ilYYYYMMDD
NB.
NB.   timespan=. 20110901 20170301
NB.   FirstMonthRange timespan
NB.
NB.   NB. identity
NB.   timespan -: ({. , {:) FirstMonthRange timespan
NB.
NB. dyad:  blclYYYYMM01 =. pa FirstMonthRange ilYYYYMMDD
NB.
NB.   1 FirstMonthRange timespan
NB.   FirstMonthRange~ timespan

0 FirstMonthRange y
:
'start finish'=. y
'dates out of order' assert start < finish
start=. datefrint start  [ finish=. datefrint finish
'invalid dates' assert valdate start,:finish
dates=. monthdates~ (0{start) + 0:`]@.(0<#)i.>:0{finish-start
start=.  intfrdate 1 ,~ }:start
finish=. intfrdate 1 ,~ }:finish
dates=. dates #~ (start <: dates) *.dates <: finish
FormatSheetDates`]@.(0-:x) dates
)


FirstOfMonth=:3 : 0

NB.*FirstOfMonth v-- returns YYYYMM01 date for current month.
NB.
NB. monad:  iaYYYYMM01 =. FirstOfMonth uuIgnore
NB. 
NB.   FirstOfMonth 0
NB.   FirstOfMonthOverride_Swag_=. 20150801

if. 0 = nc <'FirstOfMonthOverride' do.
  FirstOfMonthOverride  NB. !(*)=. FirstOfMonthOverride 
else.
  0 100 100 #. <. 1 ,~ 2&{.@(6!:0) ''
end.
)

NB. format ilYYYYMM01 integers as blclYYYY-MM-01
FormatSheetDates=:[: <"1 'd<0>q<->,r<0>q<->3.0,r<0>2.0' 8!:2 datefrint


FormatStatSheet=:3 : 0

NB.*FormatStatSheet v-- format standard series statistics.
NB.
NB. dyad:  btclSheet =. FormatStatSheet (<blclHeader),<nt

NB. format as excel oriented sheet
'hd sst'=. y
('Year'; hd) ,.&.|: ('0.0' (8!:0) 2 {."1 sst) ,. 'd<0>' (8!:0) 2 }."1 sst
)


FuncArguments=:3 : 0

NB.*FuncArguments v-- sets various verbs passed as cl arguments in specified locale.
NB.
NB. monad:  blcl =. FuncArguments clLocale
NB.
NB.   FuncArguments 'Swag'  NB. normal use
NB.   FuncArguments 'base'  NB. testing defined verbs

fn=. 0$a: [ loc=. '_',(y -. ' '),'_'

('dFrep',loc)=: [ + 0 * ]   NB. replace old numeric series values with new values
('mFmean',loc)=: mean f.    NB. mean of numeric list 
('dFadd',loc)=: +           NB. add new series values to old values
('mFpass',loc)=: ]          NB. pass series unchanged

(fhist=.    'HistFuncs',loc)=:    ('mFmean';'dFrep') ,&.> <loc
(fhistadd=. 'HistAddFuncs',loc)=: ('mFmean';'dFadd') ,&.> <loc
(fres=.     'ResFuncs',loc)=:     ('mFpass';'dFadd') ,&.> <loc

loc;fhist;fhistadd;fres
)


FuncHistOnOffRange=:4 : 0

NB.*FuncHistOnOffRange v-- (<moFunc> relevant history) <dyFunc> oldvalues over date delimited series.
NB.
NB. dyad:  nl =. (blclFunc ; nlParms) FuncHistOnOffRange ntCurrent

'moFunc dyFunc numx'=. x [ 'Date series'=. y
optx=. 4 }. numx [ 'fom value ondate offdate'=. 4 {. numx
BackPeriods=. 0 { optx

if. fom < ondate do.
  NB. future <dyFunc> value over period
  (dyFunc;numx) FuncOnOffRange y 
elseif. (ondate <: fom) * fom < offdate do.
  NB. relevant history
  rhist=. (ondate,fom) RangeIndexes Date
  if. BackPeriods = _1 do.
    NB. ignore history - do nothing    
  elseif. (BackPeriods > #rhist) * 1 <: #rhist do.
    NB. look at periods that may occur before ondate
    rhist=. (Date i. fom) {. series
    value=. (moFunc~) (-BackPeriods >. #rhist) {. rhist 
  elseif. (1 <: BackPeriods) * BackPeriods <: #rhist do. 
    NB. if enough relevant history is present <moFunc> recent backperiods
    value=. (moFunc~) (-BackPeriods <. #rhist) {. rhist{series
  elseif. (BackPeriods = 0) * 1 <: #rhist do.
    NB. if backperiods is not specified <moFunc> entire relevant history
    value=. (moFunc~) rhist{series
  end.
  NB. pass possibly altered (value) 
  (dyFunc;fom,value,ondate,offdate,optx) FuncOnOffRange y 
elseif. offdate <: fom do.
  NB. past return unaltered 
  series
end.
)


FuncOnOffRange=:4 : 0

NB.*FuncOnOffRange v-- newvalues <dyFunc> oldvalues in time range.
NB.
NB. dyad:  nl =. (clFunc ; nl) FuncOnOffRange ntDateValue

'dyFunc numx'=. x [ 'Date series'=. y 
optx=. 4 }. numx [ 'fom value ondate offdate'=. 4 {. numx

NB. nominal yearly inflation rate
YearInflate=. 1 { optx

if. offdate <: fom do. series NB. do not alter past
else.
  range=. ((fom>.ondate),offdate) RangeIndexes Date
  NB. (VaryHistory) controls the introduction of uniform random noise
  NB. this is mainly used to generate plausible historical test data
  noise=. (#range)#0
  if. VaryHistory ~: 0 do. noise=. VaryHistory * ?.noise end.
  NB. <dyFunc> is generally not commutative proper
  NB. calls follow: newvalues (dyFunc~) oldvalues
  if. YearInflate = 0 do.
    ((noise + value#~#range) (dyFunc~) range{series) range} series
  else.
    NB. inflate monthly values
    value=. (noise + value) * */\ 1,(<:#range) # >: (YearInflate%100) % 12
    (value (dyFunc~) range{series) range} series
  end.
end.
)


FuncSheetSeries=:4 : 0

NB.*FunSheetSeries v-- applies named monadic verb to selected sheet series.
NB.
NB. dyad:  fl =. blSeries FuncSheetSeries (clFunc ; ut)
NB.
NB.   Netw=: -~`+`(-~)`:3"1
NB.  (;:'Dtotal Rtotal Etotal Itotal') FuncSheetSeries 'Netw';ftDat

'func dat'=.y
(func~) (<a:;(SheetHeader 0) i. x){dat
)


FutureScenarios=:3 : 0

NB.*FutureScenarios v-- compute scenarios (y)  as if all dates in
NB. future.
NB.
NB. A good way to vet a scenario is to pretend  all the dates are
NB. in the  future. This is also a good way to generate test data
NB. and to compare model predictions against actuals. Time enters
NB. this  system  through a single  verb (FirstOfMonth). Normally
NB. this verb uses system time but system time can be overridden.
NB.
NB. monad:  blclFiles=. FutureScenarios ilScenarios
NB.
NB.   FutureScenarios 0 1 2 3 4
NB.
NB. dyad:  blclFiles=. blclConfig FutureScenarios ilScenarios
NB.
NB.   TestConfiguration_Swag_ FutureScenarios _1 _30 _53

MainConfiguration_Swag_ FutureScenarios y
:
ModelConfiguration_Swag_=: x

sf=. 0$a:
for_sn. y do.
  sf=. sf , RunTest~ sn,3
end.

sf
)


LoadConfig=:3 : 0

NB.*LoadConfig v-- loads shared configuration sheets.
NB.
NB. monad:  blclSheets =. LoadConfig uuIgnore
NB.
NB.   LoadConfig 0   NB. default sheets
NB.
NB. dyad:   blclSheets =. blclSheetNames LoadConfig uuIgnore
NB.
NB.   NB. test sheets
NB.   (;:'CrossReference TestParameters') LoadConfig 0
NB.   LoadConfig~ ;:'CrossReference TestParameters'

ConfigSheetNames LoadConfig y
:
'model configuration not set' assert 0<#x
files=. (<TABSheetPath) ,&.> x ,&.> <SheetExt
'missing configuration files' assert *./fexist files
(sheets=. x ,&.> <SheetSuffix)=: readtd2&.> files
CheckConfigSheets sheets
)


LoadSheets=:3 : 0

NB.*LoadSheets v-- loads TAB delimited scenario actuals and forecast sheets.
NB.
NB. monad:  LoadSheets iaScenario
NB.
NB.   LoadSheets _66   NB. forecast sheet from actuals
NB.
NB. dyad:  zlIgnore LoadSheets iaScenario
NB.
NB.   LoadSheets~ _66  NB. load without forecast changes

(i.0) LoadSheets y
:
nouns=. SheetNames y [ files=. SheetFiles y
nouns=. nouns ,&.> <SheetSuffix
emsg=. 'missing sheet file(s)'
aix=. DataSheetNames i. <'Actuals'

if. (i.0)-:x do.
  NB. scenarios are derived from actuals going forward
  emsg assert fexist aix{files
  (nouns)=: 2 # <readtd2 ;aix{files 
else.
  NB. load sheets without reseting any
  emsg assert *./fexist files
  (nouns)=: readtd2&.> files
end.

CheckSheets nouns
)

NB. method argument names from descriptive series names
MargNames=:([: toupper@(0&{)&.> }.&.>) ,&.> ] }.&.>~ [: >: [

NB. extract on/off YYYYMMDD dates from sheet table
OnOffDates=:[: ".@(-.&'-')&> [: }. ] {"1~ (<;._1 ' OnDate OffDate') i.~ 0 { ]


RangeIndexes=:4 : 0

NB.*RangeIndexes v-- indexes in on to off times period interval is [on,off).
NB.
NB. dyad:  il =. ilOnOff RangeIndexes ilYYYYMMDD 

y=. <. y [ x=. <.x 
I. (+./\ 1 (y i. 0{x) } 0 #~ #y) * *./\ 0 (y i. 1{x) } 1 #~ #y
)


RepeatScenario=:4 : 0

NB.*RepeatScenario v-- repeats scenario n times into future.
NB.
NB. Used to generate stress test  cases. Scenario method rows are
NB. repeated  n times into the  future and given  a new  scenario
NB. number. On and Off dates are adjusted for entire time range.
NB.
NB. dyad:  btcl =. ilRepSn RepeatScenario btclScenario
NB.
NB.   pn=. 's_100' SelectScenario TestParametersSheet
NB.
NB.   NB. redo life scenario 20 times
NB.   immortal=. 20 _200 RepeatScenario pn

'minimum replications >: 2' assert 2 <: 0{x
hd=. 0{y

NB. scenario on and off dates
didx=.  hd i. ;:'OnDate OffDate'
onoff=. didx {"1 }. y
onoff=. BadNumber&".&> onoff -.&.> '-'
'invalid dates' assert -.BadNumber e. ,onoff

NB. min and max scenario years
fly=. <. 10000 %~ (<./ , >./) , onoff

NB. all future on off dates
offsets=. onoff - 10000 * 0{fly
dates=. ,/ offsets +"2 0 [ 10000 * (0{fly) + +/\ (<:0{x) # >: -/ |.fly
dates=. FormatSheetDates"_1 dates

NB. replicate scenario rows sans header
fr=. ;(<:0{x) # <}.y

NB. replace dates and attach original scenario
fr=. y , dates didx}"1 fr

NB. replace scenario number
(<ScenarioPrefix,":1{x) (<(>:i.<:#fr);hd i.<'Scenario')} fr
)


RunTest=:3 : 0

NB.*RunTest v-- run test scenario.
NB.
NB. monad:  blclFiles =. RunTest iaScenario
NB.
NB.   NB. set configuration
NB.   ModelConfiguration_Swag_ =: TestConfiguration_Swag_
NB.
NB.   RunTest _5
NB.
NB. dyad:  blclFiles =. iaIgnore RunTest iaScenario
NB.
NB.   NB. create initial test files before test
NB.   RunTest~ _5
NB.   
NB.   NB. zero history
NB.   0 RunTest _5 1
NB.
NB.   NB. compute as if all dates in future
NB.   0 RunTest _66 2
NB.
NB.   NB. first compute as if all dates in future then recompute with system time
NB.   0 RunTest _66 3
NB.
NB.   NB. can run main forecast model as well 
NB.   ModelConfiguration_Swag_ =: MainConfiguration_Swag_
NB.   RunTest~ 0 2

a: RunTest y
:
LoadConfig~ ModelConfiguration
parms=. ".(;1{ModelConfiguration),SheetSuffix
opt=. (2<.1{opt) 1} opt=. 2 {. y

NB. dyad calls create new test sheets
NB. options 2 & 3 set (FirstOfMonthOverride_Swag_)
if. -. x -: a: do. parms SwagTest opt end.

NB. load test sheets and run scenario
LoadSheets 0{y
NB. smoutput 'test: ',":0{y
files=. parms Swag 0{y

if. 2 = {:2{.y do. 
  erase 'FirstOfMonthOverride_Swag_'
  smoutput 'first of month restored'
elseif. 3 = {:2{.y do.
  erase 'FirstOfMonthOverride_Swag_'
  smoutput 'first of month restored'
  NB. rerun scenario using first run's forecast as actuals
  (read ;0{files) write TABSheetPath,(ScenarioPrefix,":0{y),'Actuals',SheetExt
  VaryHistory_Swag_=: 0 [ vh=. VaryHistory_Swag_
  LoadSheets 0{y
  VaryHistory_Swag_=: vh [ files=. parms Swag 0{y
end.

files
)


RunTheNumbers=:3 : 0

NB.*RunTheNumbers v-- compute all scenarios on list (y).
NB.
NB. monad:  blclFiles =. RunTheNumbers ilScenarios
NB.
NB.   RunTheNumbers 0 1 2 3 4

NB. parameters sheet is the last config sheet
ModelConfiguration_Swag_=:MainConfiguration_Swag_
parms=. ".;{:LoadConfig 0
scfx=. ScenarioPrefix

ac=. toHOST fmttd ActualSheet 0
ac write TABSheetPath,'MainActuals',SheetExt

sf=. 0$a:
for_sn. y do.
  ac write TABSheetPath,scfx,(":sn),'Actuals',SheetExt
  sf=. sf , parms Swag sn [ LoadSheets sn
end.

sf 
)


ScenarioTimeRange=:4 : 0

NB.*ScenarioTimeRange v-- determines scenario time span.
NB.
NB. dyad:  ilYYYYMMDD =. iaScenario ScenarioTimeRange btclParameters
NB.
NB.   LoadConfig~ ;:'CrossReference TestParameters'
NB.   _2 ScenarioTimeRange TestParametersSheet 
NB.   _5 ScenarioTimeRange TestParametersSheet

sdates=. ((0 { y) i. ;:'Scenario OnDate OffDate') {"1 y
sdates=. 1 2 {"1 }. (alltrim ScenarioPrefix,":x) SelectScenario alltrim&.> sdates
'no scenario time range' assert 0 < #sdates 
sdates=. (<./ , >./) , ".&> sdates -.&.> '-'

NB. add two months to maximum date for model series shifts
ld=. datefrint {:sdates
({.sdates),intfrdate 1>.((0{ld) + 12 <.@%~ 2 + 1{ld),(12|2 + 1{ld),2{ld
)

NB. select rows pertaining to a scenario
SelectScenario=:] #~ (1) 0} ([: < [) = ] {"1~ (<'Scenario') i.~ 0 { ]


SeriesFromSheet=:4 : 0

NB.*SeriesFromSheet v-- extract numeric series from TAB delimited sheet.
NB.
NB. dyad:  bt =. iaYYYYMM01 SeriesFromSheet btclSheet
NB.
NB.   20300101 SeriesFromSheet s_3ActualsSheet
NB.   20320202 SeriesFromSheet s_3ForecastSheet

st=. }. y [ hd=. 0{y
dx=. hd i. <'Date'  NB. dates are 'YYYY-MM-DD' 
sd=. |: BadNumber&".&> ((dx {"1 st) -.&.> '-') (<a:;dx)} st
'invalid dates/numbers in sheet' assert -. BadNumber e. ,sd
sd=. <"1 sd

NB. fill future months if necessary
if. x > ld=. {: ymd=. ;dx{sd do.
  ymd=. ymd , }. FirstMonthRange ld,x
  sd=. (#ymd) {.&.> sd
  sd=. (<ymd) dx} sd 
end.

hd ,. sd
)


SeriesNameXref=:3 : 0

NB.*SeriesNameXref v-- series name cross reference.
NB.
NB. monad:  btcl =. SeriesNameXref uuIgnore

<"1 |: }. ((0{CrossReferenceSheet) i. ;:'SeriesName Name') {"1 CrossReferenceSheet
)


SeriesYearStatistics=:4 : 0

NB.*SeriesYearStatistics v-- standard statistics of series partitioned by years.
NB.
NB. dyad:  ((<blclStatHead),<ntStats) =. clSfx SeriesYearStatistics ntDateSeries
NB.
NB.    st=. s_99ForecastSheet
NB.    rt=. (DateFromSheet st) ,. 'Rtotal' ValuesFromSheet st
NB.   'hd stats'=. '-s_99Rtotal' SeriesYearStatistics rt

NB. split into years 
years=. <. (0 {"1 y) % 10000
sst=.   years </. 1 {"1 y

NB. statistics
hd=. ;:'Min Max Q1 Q2 Q3 Mean StdDev Skew Kurt'
hd=. 'MonthCount' ; hd ,&.> <x
sv=. $ , (<./) , (>./) , q1 , median , q3 , mean , stddev , skewness , kurtosis
(<hd),<(~.years) ,. sv&> sst
)


SheetFiles=:3 : 0

NB.*SheetFiles v-- TAB delimited sheet filenames.
NB.
NB. monad:  blclFiles =. SheetFiles iaScenario

(<TABSheetPath) ,&.> (SheetNames y) ,&.> <SheetExt
)


SheetFromSeries=:4 : 0

NB.*SheetFromSeries v-- sheet table from series values.
NB.
NB. dyad:  btclSheet =. blclName SheetFromSeries blulSeries
NB.
NB.   ss=. SeriesFromSheet s_99ForecastSheet
NB.   st=. (0 {"1 ss) SheetFromSeries ".&.> 0 {"1 ss
NB.   st -: s_99ForecastSheet

NB. format dates as YYYY-MM-DD characters
p=. x i. <'Date'
d=. FormatSheetDates ; p {"1 y

NB. format all series handles J negatives
t=. |: 'd<0>'&(8!:0)&> y

NB. adjust dates attach header
x , d (<a:;p) } t
)


SheetHeader=:3 : 0

NB.*SheetHeader v-- forecast/actuals header names.
NB.
NB. monad:  blcl =. SheetHeader uuIgnore

'Date';ExpenseSeries,'Etotal';IncomeSeries,'Itotal';ReserveSeries,'Rtotal';DebtSeries,'Dtotal';BalanceSeries,UtilitySeries
)


SheetNames=:3 : 0

NB.*SheetNames v-- locale sheet names.
NB.
NB. monad:  blclNames=. SheetNames iaScenario

/:~ (<ScenarioPrefix,":y) ,&.> DataSheetNames
)


SortScenario=:4 : 0

NB.*SortScenario v-- sorts scenario rows by ondate and method.
NB.
NB. monad:  btcl =. blclMethodOrder SortScenario btclScenario

scn=. }. y [ hd=. 0{y
'on date method'=. <"1 |: (hd i. ;:'On OnDate Method') {"1 scn

NB. remove rows that are not on 
bm=. (a: = on ) +. (<'on') = tolower&.> on -.&.> ' '
scn=. bm # scn [ date=. bm # date [ method=. bm # method
'no active scenario rows' assert 0 < #scn

NB. sort by 'YYYY-MM-DD' date and method 
hd , scn {~ /: ((/:~ ~.date) i. date) ,. x i. method
)


Swag=:4 : 0

NB.*Swag v-- compute Silly Wild Ass Guess forecast TAB delimited sheets.
NB.
NB. dyad: blclFiles =. btclSheet Scenario iaScenario
NB.
NB.   LoadConfig 0
NB.   LoadSheets _66
NB.   ParametersSheet Swag _66

NB. file and spreadsheet prefixes
scfx=. ScenarioPrefix,":y [ sspx=. SSpreadPrefix,":y

NB. forecast scenario
scn=. scfx,'Forecast',SheetSuffix
('scenario not loaded: ',scn) assert 0 = nc <scn
bal=. (y;<x) ComputeScenario ".scn
bst=. sspx BalanceStatistics bal

NB. write TAB delimited sheet files
(toHOST fmttd bal) write f0=. TABSheetPath,scfx,'Forecast',SheetExt
(toHOST fmttd bst) write f1=. TABSheetPath,scfx,'Stats',SheetExt

NB. return file names
f0;f1
)


SwagTest=:4 : 0

NB.*SwagTest v-- generates simulated scenario test sheets.
NB.
NB. dyad:  blclFiles =. btclParameters SwagTest iaScenario
NB.
NB.   LoadConfig 0
NB.   ParametersSheet SwagTest _99
NB.   ParametersSheet SwagTest _66
NB.
NB.   LoadConfig~ ;:'CrossReference TestParameters'
NB.
NB.   NB. generate with zero history 
NB.   TestParametersSheet SwagTest _3 1 
NB.
NB.   NB. compute as if all dates in future
NB.   TestParametersSheet SwagTest _3 2

NB. scenario number and generation option
'scn opt'=. 2 {. y

strg=. scn ScenarioTimeRange x
if. fomover=. opt=2 do.
  NB. compute as if all dates are in the future by setting
  NB. the month clock to a time before the first model date
  FirstOfMonthOverride_Swag_=: _10000 + {. scn ScenarioTimeRange x
  smoutput 'first of month set to: ',":FirstOfMonthOverride_Swag_
end.

opt=. opt=0

dates=. FirstMonthRange strg
past=.  dates < FirstOfMonth 0
shd=.   SheetHeader 0

bnm=. ((#dates),#shd)$0 

NB. simulated income 
bnm=. (opt * 2000>.?.8000) (i0=. shd XrefSeries 'salary')}"1 bnm    
bnm=. (opt * 2>.?.10) (i1=. shd XrefSeries 'dividends')}"1 bnm  

NB. simulated reserves     
bnm=. (opt * 5000>.?.200000) (shd XrefSeries 'rssavings')}"1 bnm
bnm=. (opt * 15000>.?.50000) (shd XrefSeries 'rsinvest')}"1 bnm 

NB. simulated expenses 
bnm=. (opt * 600>.?.2000) (e0=. shd XrefSeries 'house')}"1 bnm  
bnm=. (opt * 2000>.?.4000) (e1=. shd XrefSeries 'living')}"1 bnm  
bnm=. (opt * 100>.?.200) (e2=. shd XrefSeries 'insurance')}"1 bnm

NB. zero out future
bnm=. past*"0 1 bnm

NB. randomize past income and expense series
inc=. inx { bnm [ inx=. <a:;i0,i1
bnm=. (inc + (]`?.)@.(0 < [)"0 [ 500 <. >. inc) inx} bnm
exp=. exx { bnm [ exx=. <a:;e0,e1,e2
bnm=. (exp + (]`?.)@.(0 < [)"0 [ 500 <. >. exp) exx} bnm

NB. sum up income/expenses/reserves/debt HARDCODE: local suffix
fadd=.  'CAdd_Swag_'
(fadd)=: +/"1 
bnm=. (IncomeSeries  FuncSheetSeries fadd;bnm) (<a:;shd i. <'Itotal')} bnm
bnm=. (ExpenseSeries FuncSheetSeries fadd;bnm) (<a:;shd i. <'Etotal')} bnm
bnm=. (ReserveSeries FuncSheetSeries fadd;bnm) (<a:;shd i. <'Rtotal')} bnm
bnm=. (DebtSeries    FuncSheetSeries fadd;bnm) (<a:;shd i. <'Dtotal')} bnm

NB. compute basic balance
fsub=.  'CSub_Swag_'
(fsub)=: -/"1
bnm=. ((;:'Itotal Etotal') FuncSheetSeries fsub;bnm) (<a:;shd i. <'BB')} bnm

NB. net period worth: (((I - E) + R) - D) iversonized D -~ R + E ~- I
fnw=. 'Netw_Swag_'
(fnw)=: -~`+`(-~)`:3"1
bnm=. ((;:'Dtotal Rtotal Etotal Itotal') FuncSheetSeries fnw;bnm) (<a:;shd i. <'NW')} bnm

NB. format for excel
bal=. 'd<0>' (8!:0) bnm
bal=. shd , (FormatSheetDates dates) (<a:;shd i. <'Date')} bal

NB. if. fomover do. erase 'FirstOfMonthOverride_Swag_' end.

NB. write TAB delimited sheets
ppfx=. TABSheetPath,ScenarioPrefix,":scn
(toHOST fmttd bal) write f0=. ppfx,'Forecast',SheetExt
(toHOST fmttd bal) write f1=. ppfx,'Actuals',SheetExt
f0;f1
)


TranOnOffRange=:4 : 0

NB.*TranOnOffRange v-- reallocate reserve funds to reserve or debt series.
NB.
NB. dyad:  ((<blcl) ,< nt) =. (nl ; blnl ,< blnl) TranOnOffRange ((<blclSeries) ,< nt)

'numx rsn dbtn'=. x [ 'cn cv'=. y
optx=. 4 }. numx [ 'fom value ondate offdate'=. 4 {. numx
if. offdate <: fom do. NoChange return. end.

NB. optional transfer arguments !(*)=. DebtArguments ReserveArguments 
'Fee LoanEquity'=. 2 {. optx
(ReserveArguments)=. rsn
(DebtArguments)=. dbtn

NB. reserve/debt allocation tables
ralloc=. AllocTable |&.> ".&.> ReserveArguments
asn=. cn {~ cn XrefSeries ReserveSeriesNames
dalloc=. 0 AllocTable |&.> ".&.> DebtArguments
dsn=. cn {~ cn XrefSeries DebtSeriesNames
'reserve allocation length mismatch' assert (#ReserveSeriesNames)={:$ralloc
'debt allocation length mismatch' assert (#DebtSeriesNames)={:$dalloc

NB. legitimate transfers: reserves to reserves and reserves to debts
rtr=. (1 1 -: +/"1 ralloc) * 0 = +/ , dalloc
rtd=. (1 = 0 { +/"1 ralloc) * 1 = 0 { +/"1 dalloc
'invalid transfer allocation' assert 1 = rtr + rtd

(cn)=. cv  NB. local series !(*)=. Date U2  

NB. period indexes and relevant reserve allocation 
rfx=. <a:;px=. (ondate,offdate) RangeIndexes Date
sie=. ".&> asn

NB. apply transfer fees
EF=. (Fee + px{EF) px} EF

if. rtr do.
  NB. transfer value from first reserve allocation to second
  sie=. ((rfx{sie) -"1 0 value * 0{ralloc) rfx} sie
  sie=. ((rfx{sie) +"1 0 value * 1{ralloc) rfx} sie
  NB. mark payback for audit
  U2=. (value + px{U2) px} U2
  (<'EF';'U2';asn) ,< EF,U2,sie
else.
  NB. transfer value from reserve allocation to debt allocation
  hcm=. ".&> dsn
  NB. do not overpay loans
  pp=. (rfx{hcm) <."1 0 value * 0{dalloc
  pp=. value <. ({."1 pp) ,. }:"1 spp * 0 < spp=. (rfx{hcm) - +/\"1 pp
  NB. allocate total period loan payments back to reserves
  sie=.((rfx{sie) -"1 (+/pp) *"1 0 [ 0{ralloc) rfx} sie
  NB. mark actual payback for audit
  U2=. ((+/pp) + px{U2) px} U2
  NB. adjust outstanding loan balances going forward
  px2=. Date i. offdate
  fb=. (px2 }."1 hcm) -"1 0 +/"1 pp
  fb=. (0 < fb) * fb
  NB. adjust debt allocation loan balances within period
  hcm=. ((rfx { hcm) - (0{dalloc) */ +/\ +/ |rfx { sie) rfx} hcm
  hcm=. (px2 {."1 hcm) ,. fb
  'debts cannot be negative' assert 0 <: <./,hcm
  if. LoanEquity ~: 0 do.
    rqv=. cv {~ cn XrefSeries 'rsequity'  
    NB. loan balance is not always equity it can be scaled 
    rqv=. ((LoanEquity * +/,pp) + px{rqv) px} rqv
    sie=. rqv (asn XrefSeries 'rsequity')} sie
  end.
  (<'EF';'U2';asn,dsn) ,< EF,U2,sie,hcm 
end.
)

NB. extract numeric series from TAB delimited sheets: (;:'I0 E2') ValuesFromSheet y
ValuesFromSheet=:[: |: [: ".&> [: }. ] {"1~ (0 { ]) i. [: boxopen [

NB. remove number representation characters from blcl
WithoutNumerals=:(<'-0123456789. ') -.&.>~ ]

NB. removes quoted strings from blcl: WithoutQuoted ;:'boo hoo ''you'''
WithoutQuoted=:] #~ (<'''''') ~: ({. , {:)&.>


XrefSeries=:3 : 0

NB.*XrefSeries v-- lookup series names and positions.
NB.
NB. monad:  clSeriesName   =. XrefSeries clName
NB.         blclSeriesName =. XrefSeries blclName
NB.
NB.   XrefSeries 'rssavings'
NB.   XrefSeries ;:'rssavings salary insurance'
NB.   XrefSeries ;:'bad missing boys'
NB.   
NB. dyad:  iaIndex =. blclSeries XrefSeries clName
NB.
NB.   (SheetHeader 0) XrefSeries 'salary'
NB.   (SheetHeader 0) XrefSeries ;:'salary insurance car'

(0$a:) XrefSeries y
:
try.
  'sn nn'=. SeriesNameXref 0
  xn=. sn {~ nn i. bn=. boxopen y
  if. #x do. x i. xn else. ]`;@.(1=#) xn end.
catch.
  ('names not in series cross reference: ', ;(~.bn) ,&.> ' ') assert 0
end.
)

NB. trims all leading and trailing blanks
alltrim=:] #~ [: -. [: (*./\. +. *./\) ' '&=


amort=:3 : 0

NB.*amort v-- generates an amortization table for a loan of 1.00.
NB.
NB. This  amortization  verb  comes  from  the  (finance)  addon.
NB. Payments are assumed to be made in arrears.
NB.
NB. verbatim:
NB.
NB. y has 3 elements:
NB.   frq  =  payment frequency (e.g. 1=annual, 12=monthly)
NB.   int  =  decimal interest rate per annum.
NB.   yrs  =  number of years of loan
NB.
NB. result is a matrix:  pay osb ip pp
NB.   psy  =  level payment necessary to amortize the loan
NB.   osb  =  outstanding balance before each payment
NB.   ip   =  interest portion of each payment
NB.   pp   =  principal portion of each payment
NB.
NB.
NB. monad:  nt =. amort nl
NB.
NB.   amort 12 0.125 25  NB. 25 year loan payable monthly at 12.5%
NB.
NB.   150000 * amort 12 0.05 15  NB. $150,000 15 year mortgage at 5.0%

if. 3 ~: #y do.
  'frq int yrs' return. end.
'f i y'=. y
len=. f*y
i=. <:(>:i)^%f
vn=. */\1,len$%>:i
osb=. osb%{.osb=. |.-.}.vn
pay=. %+/}.vn
pp=. pay-ip=. osb*i
pay,.osb,.ip,.pp
)

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))

NB. boxes open nouns
boxopen=:<^:(L. = 0:)

NB. YYYYMMDD to YYYY MM DD lists
datefrint=:0 100 100&#:@<.

NB. deviation about mean
dev=:-"_1 _ mean

NB. erase words
erase=:[: 4!:55 ;: ::]

NB. boxes UTF8 names
fboxname=:([: < 8 u: >) ::]

NB. 1 if file exists 0 otherwise
fexist=:1:@(1!:4) ::0:@(fboxname&>)@boxopen

NB. format tables as TAB delimited LF terminated text - see long document
fmttd=:[: (] , ((10{a.)"_ = {:) }. (10{a.)"_) [: }.@(,@(1&(,"1)@(-.@(*./\."1@(=&' '@])))) # ,@((10{a.)&(,"1)@])) [: }."1 [: ;"1 (9{a.)&,@":&.>

NB. YYYY MM DD lists to YYYYMMDD integers
intfrdate=:0 100 100&#.@:<.

NB. tests for character data
ischar=:2&=@(3!:0)

NB. kurtosis
kurtosis=:# * +/@(^&4)@dev % *:@ssdev

NB. mean value of a list
mean=:+/ % #

NB. median value of a list
median=:-:@(+/)@((<. , >.)@midpt { /:~) ::_:

NB. mid-point
midpt=:-:@<:@#


monthdates=:3 : 0

NB.*monthdates v-- returns all valid first of month dates  for  n
NB. calendar years.
NB.
NB. The monad returns  an integer table with YYYY MM 01 rows. The
NB. dyad returns dates as a list of YYYYMM01 integers.
NB.
NB. monad:  itYYYYMM01 =. monthdates ilYears
NB.
NB.   monthdates 2000
NB.
NB.   monthdates 2001 + i. 100  NB. all first of months in 21st century
NB.
NB.
NB. dyad:  ilYYYYMM01 =. uu monthdates ilYears
NB.
NB.   0 monthdates 2001
NB.
NB.   monthdates~  1999 2000 2001   NB. useful idiom

NB. generate all first of month dates in years
days =. ,/ (,y) ,"0 1/ ,/ (>: i. 12) ,"0/ ,1
:
NB. convert to YYYYMM01 format
0 100 100 #. monthdates y
)

NB. J name class
nc=:4!:0

NB. first quartile
q1=:median@((median > ]) # ]) ::_:

NB. third quartile
q3=:median@((median < ]) # ]) ::_:

NB. reads a file as a list of bytes
read=:1!:1&(]`<@.(32&>@(3!:0)))

NB. read TAB delimited table files - faster than (readtd) - see long document
readtd2=:[: <;._2&> (9{a.) ,&.>~ [: <;._2 [: (] , ((10{a.)"_ = {:) }. (10{a.)"_) (13{a.) -.~ 1!:1&(]`<@.(32&>@(3!:0)))

NB. skewness
skewness=:%:@# * +/@(^&3)@dev % ^&1.5@ssdev

NB. session manager output
smoutput=:0 0 $ 1!:2&2

NB. sum of square deviations (2)
ssdev=:+/@:*:@dev

NB. standard deviation (alternate spelling)
stddev=:%:@:var

NB. converts character strings to CRLF delimiter
toCRLF=:2&}.@:;@:((13{a.)&,&.>@<;.1@((10{a.)&,)@toJ)

NB. converts character strings to host delimiter
toHOST=:toCRLF

NB. converts character strings to J delimiter LF
toJ=:((10{a.) I.@(e.&(13{a.))@]} ])@:(#~ -.@((13 10{a.)&E.@,))


tolower=:3 : 0

NB.*tolower v-- convert to lower case.
NB.
NB. monad: cl =. tolower cl

x=. I. 26 > n=. ((65+i.26){a.) i. t=. ,y
($y) $ ((x{n) { (97+i.26){a.) x}t
)


toupper=:3 : 0

NB.*toupper v-- convert to upper case
NB.
NB. monad:  cl =. toupper cl

x=. I. 26 > n=. ((97+i.26){a.) i. t=. ,y
($y) $ ((x{n) { (65+i.26){a.) x}t
)


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

NB. var
var=:ssdev % <:@#

NB. writes a list of bytes to file
write=:1!:2 ]`<@.(32&>@(3!:0))


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

