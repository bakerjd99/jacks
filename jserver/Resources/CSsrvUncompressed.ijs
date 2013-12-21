NB.*CSsrv s-- utilities called by C# utilities.
NB.
NB. This group creates a j locale that is used when communicating
NB. with functions in the C# JServer class. All the words in this
NB. locale are called with direct fully qualified locale names:
NB.
NB. verbatim:
NB.
NB.   testDataTable_CSsrv_  'DATATABLE'
NB.
NB. interface word(s):
NB. ---------------------------------------------------------
NB.  dtColumnInfo        - returns j DataTable column information
NB.  dtDataTableFrTrdata - j DataTable from transferred column and data
NB.  dtTableData         - returns j DataTable data
NB.  isDataTable         - is (y) the name of a DataTable representation
NB.  testDataTable       - generate random test DataTable representation
NB.
NB. created: 2009dec15
NB. author:  bakerjd99@gmail.com
NB. ---------------------------------------------------------
NB. 2010feb24 DataTable utilites added - converted to class group
NB. 2010mar04 j internal representation hidden from C#
NB. 2010mar06 DataTable set added 
NB. 2010may10 now generated/distributed by (make_CSsrv)

coclass 'CSsrv'

NB. embedding certain charaters (like ") in C# strings is
NB. a nuisance.  These alias verbs permit easy access to
NB. some frequently used J verbs.

Afmt=: ":  NB. format alias
Aex=:  ".  NB. execute alias
NB.*end-header

NB. C# boolean values
CSBOOLS=:<;._1 ' False True'

NB. CSsrv supported C# DataTable column types
CSTYPES=:2 5$<;._1 ' string int double bool datetime System.String System.Int32 System.Double System.Boolean System.DateTime'

NB. bad CSsrv integer return code
CSsrvBADRC=:_777

NB. interface words for (CSsrv) group
IFACEWORDSCSsrv=:<;._1 ' dtColumnInfo dtTableData isDataTable testDataTable dtDataTableFrTrdata'

NB. DataTable representation integer code
ISDATATABLECODE=:31

NB. root words for (CSsrv) group
ROOTWORDSCSsrv=:<;._1 ' IFACEWORDSCSsrv ROOTWORDSCSsrv box0 dtColumnInfo dtDataTableFrTrdata dtTableData isDataTable scatter testDataTable'

NB. test string data
TESTWORDS=:<;._1 ' these are the words that we test by they are pure and good and devoid of the badness that is wrong'

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))

NB. box 0-cells and format as cl
box0=:[: ":&.> <"0

NB. returns j DataTable column information
dtColumnInfo=:>@:(0&{)


dtDataTableFrTrdata=:4 : 0

NB.*dtDataTableFrTrdata v-- j DataTable from transferred column and table data. 
NB.
NB. dyad:  (iaRc;<bl) =. (iaRowcnt;clTrcols) dtDataTableFrTrdata clTrdata


'rowcnt headstr'=. x

NB. no column or row data from C#
if. (rowcnt=0) *. 0=#headstr do. ISDATATABLECODE;<testDataTable 0 0 return. end.

cols=. |: dtTableDataFrStr headstr
ncols=. {:$cols

if. (rowcnt=0) +. 0=#y do. data=. (0,ncols)$<'' else. data=. dtTableDataFrStr y  end.

NB. if column and row counts are not what is expected
NB. delimiters are unbalanced. This is a sufficient but
NB. not necessary condition for proper rows and columns
if. (rowcnt,ncols) -: $data do.

  cnames=.  (<'Column') ,&.>  'r<0>4.0' (8!:0)  i. ncols
  jtypes=. ncols$<'literal'
  cstypes=. 1{cols

  pos=. (1{CSTYPES) i. cstypes
  if. ({:$CSTYPES) > >./pos do.
    cstypes=. pos{0{CSTYPES

    NB. header
    hd=. cnames , (0{cols) , jtypes ,: cstypes

    NB. current representation
    ISDATATABLECODE;<(<hd),<data
  else.
    NB. WARNING unsupported column typeS are tested in C# we should never
    NB. get here - if we do the interface will raise a misleading error
    CSsrvBADRC;<y
  end.

else.
  NB. error return - leaving transfer string intact for debugging
  CSsrvBADRC;<y
end.
)

NB. returns j DataTable data
dtTableData=:>@:(1&{)

NB. j datatable data from transfer string
dtTableDataFrStr=:<;._1&>@:(<;._1)


isDataTable=:3 : 0

NB.*isDataTable   v--   is   (y)   the   name   of  a   DataTable
NB. representation.
NB.
NB. THIS:  determines  if  (y)  is  the   name   of  a J  DataTable
NB. representation. The DataTable is a .Net  object that  is used
NB. to represent database like data tables. DataTable objects can
NB. be easily loaded  into  .Net gridview  controls  so there are
NB. significant benefits  to getting  and  setting J data in this
NB. format.
NB.
NB. monad:  iaRc =. isDataTable clName
NB.
NB.   dt=: testDataTable 8 200
NB.   isDataTable 'dt'
NB.
NB. dyad:  clLocaleSfx isDataTable clName
NB.
NB.   dt_boo_=: testDataTable 189 7
NB.   dt_boo_=: '_boo_' isDataTable 'dt'

'_base_' isDataTable y
:
NB. simple necessary but hardly sufficient tests
rc=. CSsrvBADRC
dn=. y,x
if.      0 ~: nc <dn       do. rc
elseif.  dat=. ". dn
         -.(,2) -: $dat    do. rc
elseif.  0 e. $>1{dat      do. 
  NB. no row data - column counts must match
  if. ~:/ {:@:$&.> dat do. rc return. end.
  ISDATATABLECODE return.
elseif.  -.1 1 -: L.&> dat do. rc
elseif.  shps=. $&.> dat
         -.2 2 -: #&> shps do. rc
elseif.  4 ~: {. ; 0{shps  do. rc
elseif.  ~:/{:&> shps      do. rc
elseif.do.
  ISDATATABLECODE
end.

)

NB. J name class
nc=:4!:0

NB. random cell coordinates from array shape
rndcoords=:] $ ([: ?~ */) { [: , [: { [: i.&.> <"0

NB. random shuffle of array elements
scatter=:] {~ [: rndcoords $


testDataTable=:3 : 0

NB.*testDataTable v-- generate random test DataTable representation.
NB.
NB. monad:  bl=. testDataTable ilColsRows

'nrows ncols'=. y

NB. C# and supported J column types 
jtypes=. ncols$<'literal'

NB. csallowed=. CSTYPES -. <'datetime'
csallowed=. 0{CSTYPES
cstypes=. csallowed {~ ?ncols##csallowed

NB. test column names and titles 
cnames=.  (<'Column') ,&.>  'r<0>4.0' (8!:0)  i. ncols
ctitles=. cstypes ,&.> ' ' ,&.> 'r<0>4.0' (8!:0)  i. ncols

NB. header
hd=. cnames , ctitles , jtypes ,: cstypes

NB. column data
if. 0 < nrows do. data=. |: nrows testDataTableColumn"0 cstypes else. data=. (0,ncols)$<'' end.

NB. current DataTable representation
(<hd),<data
)


testDataTableColumn=:4 : 0

NB.*testColumn v-- generate random column of formatted type.
NB.
NB. dyad:  iaNrows testColumn clType

select. y
case. 'string' do. TESTWORDS {~ ? x ##TESTWORDS
case. 'int'    do. ":&.> <"0 ? x #10000
case. 'double' do. '0.2' (8!:0) 239 %~ ? x #613
case. 'bool'   do. (?x # 2) { CSBOOLS
case. 'datetime' do.
 NB. random future dates in YYYY/MM/DD HR:MN:SS format
 dt=.  1 tsrep (1e9 * ? x # 200) + tsrep (6!:0) ''
 ymd=. (<"1 ('q</>,q</>,q<>' (8!:2) 3 {."1 dt)) -.&.> ' '
 hns=. (<"1 'q<:>,q<:>,q<>' (8!:2) <. 3 }."1 dt) -.&.> ' '
 ymd ,&.> ' ' ,&.> hns
case.do.
  'invalid j DataTable column type' assert 0
end.
)


testDataTableMatch=:4 : 0

NB.*testDataTableMatch v-- test j databasel representation match.
NB.
NB. THIS: verb is useful testing the "round tripping" of the datatable interface.
NB.
NB. dyad:  pa =. blDataTableA testDataTableMatch blDataTableB

if. x -: y do. 1  
else.
  NB. floating point columns may differ in some characters due to
  NB. number formatting - convert these columns and retest
  'colA datA'=. x
  'colB datB'=. y
  if. colA -: colB do.
    if. *./0 < (#datA),#datB do.
      pos=. (I. (<'double') = 3 { colA) {"1 datA

      bds=. 10j10  
      datA=. bds&".&> datA
      datB=. bds&".&> datB

      NB. complex numbers do not occur in double representations 
      NB. if found it indicates that nondouble representations are present
      if. (bds e. datA) +. bds e. datB do. 0 else. datA -: datB end.
    else.
      0 NB. column match for at least one null but data does not 
    end.

  else.
    0
  end.
end.
)


tsrep=:3 : 0

NB.*tsrep v-- timestamp representation as a single number.
NB.
NB. verbatim: 
NB. [opt] timerep times
NB.   opt=0  convert timestamps to numbers (default)
NB.       1  convert numbers to timestamps
NB.
NB. timestamps are in 6!:0 format, or matrix of same.
NB.
NB. examples:
NB.    tsrep 1800 1 1 0 0 0
NB. 0
NB.    ":!.13 tsrep 1995 5 23 10 24 57.24
NB. 6165887097240

0 tsrep y
:
if. x do.
  r=. $y
  'w n t'=. |: 0 86400 1000 #: ,y
  w=. w + 657377.75
  d=. <. w - 36524.25 * c=. <. w % 36524.25
  d=. <.1.75 + d - 365.25 * w=. <. (d+0.75) % 365.25
  s=. (1+12|m+2) ,: <. 0.41+d-30.6* m=. <. (d-0.59) % 30.6
  s=. |: ((c*100)+w+m >: 10) ,s
  r $ s,. (_3{. &> t%1000) +"1 [ 0 60 60 #: n
else.
  a=. ((*/r=. }: $y) , {:$y) $, y
  'w m d'=. <"_1 |: 3{."1 a
  w=. 0 100 #: w - m <: 2
  n=. +/ |: <. 36524.25 365.25 *"1 w
  n=. n + <. 0.41 + 0 30.6 #. (12 | m-3),"0 d
  s=. 3600000 60000 1000 +/ .*"1 [ 3}."1 a
  r $ s+86400000 * n - 657378
end.
)

NB.*POST_CSsrv s-- CSsrv postprocessor.

NB. utilities in this locale are called by direct fully qualified names

cocurrent 'base'
