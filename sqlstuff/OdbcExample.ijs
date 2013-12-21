NB. odbc interface
require 'dd'
 
NB. read CTE query
HistoryAgeSQL=. read 'c:/temp/HistoryAge.sql'
 
NB. connect sqlserver database
ch =. ddcon 'dsn=history'
 
NB. select with CTE query
sh =. HistoryAgeSQL ddsel ch
 
NB. fetch results
data=. ddfet sh,_1