NB.*ParseGenesisBlock s-- Bitcoin genesis block check and parse example.
NB.  
NB. author:  John D. Baker
NB. created: 2014jul01
NB. changes: -----------------------------------------------------
NB. 12jul03 added to jacks repository

require 'sslhash'
NB.*end-header

NB. first Bitcoin challenge script - contains ECDSA public key
GenesisBlockChallengeScript=:'4104678AFDB0FE5548271967F1A67130B7105CD6A828E03909A67962E0EA1F61DEB649F6BC3F4CEF38C4F35504E51EC112DE5C384DF7BA0B8D578A4C702B6BF11D5FAC'

NB. first Bitcoin base 58 output address
GenesisBlockOutputAddress=:'1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa'

NB. Bitcoin base 58 address format
Base58Check=:('1' #~ [: +/ (0{a.) = ]) , [: b58fd 256x #. a. i. ]


Base58frKey65=:3 : 0

NB.*Base58frKey65 v-- 65 byte public Bitcoin key bytes to base 58 format.
NB.
NB. monad:  clB58 =. Base58frKey65 clBytes
NB.
NB.  b65=. bfh '0450863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B23522CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6'
NB.  '16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM' -: Base58frKey65 b65

NB. require 'sslhash' !(*)=. sr160 s256
ekey=. (0{a.) , sr160 s256 y
csum=. 4 {. s256 s256 ekey
Base58Check ekey,csum
)


ParseGenesisBlock=:3 : 0

NB.*ParseGenesisBlock v-- parse and check Bitcoin genesis block.
NB.
NB. This verb parses  and checks the raw binary data of the first
NB. or genesis Bitcoin block.
NB.
NB. verbatim: see the blog posts:
NB.
NB. How to Parse the Bitcoin BlockChain
NB. http://codesuppository.blogspot.com/2014/01/how-to-parse-bitcoin-blockchain.html
NB.
NB. Bitcoin: 285 bytes that changed the world
NB. http://james.lab6.com/2012/01/12/bitcoin-285-bytes-that-changed-the-world/
NB.
NB. monad:  clMsg =. ParseGenesisBlock clBlockFile
NB.
NB.   file=. 'c:/bitjddata/blocks/blk00000.dat'
NB.   ParseGenesisBlock file

NB. j profile nouns !(*)=. IF64

NB. nouns set by this verb
NB. !(*)=. BlockLength ChallengeScript ChallengeScriptLength InputScript
NB. !(*)=. InputScriptLength MagicID MerkleRoot Nonce
NB. !(*)=. OutputAddress OutputCount OutputSatoshis PreviousBlockHash
NB. !(*)=. SequenceNumber TargetDifficulty TimeStamp TransactionCount
NB. !(*)=. TransactionHash TransactionIndex TransactionInputNumber TransactionLockTime
NB. !(*)=. TransactionVersionNumber VersionNumber

NB. fetch genesis block data
dat=. read y

NB. first 4 bytes are "sort of" block delimiters
MagicID=: (i. offset=. 4) { dat
'MagicID mismatch' assert 'F9BEB4D9' -: ,hfd a. i. MagicID

NB. next 4 bytes gives following block length
offset=. offset + 4 [ BlockLength=: _2 ic (offset + i. 4) { dat
'BlockLength mismatch' assert 285 = BlockLength

NB. next 4 bytes block format version - has changed
offset=. offset + 4 [ VersionNumber=: _2 ic (offset + i. 4) { dat

NB. next 32 bytes is previous block hash - genesis block
NB. has no previous hash and all bytes are set to 0
offset=. offset + 32 [ PreviousBlockHash=: (offset + i. 32) { dat
'PreviousBlockHash mismatch' assert (32#0) -: a. i. PreviousBlockHash

NB. next 32 bytes is the Merkle tree root hash
offset=. offset + 32 [ MerkleRoot=: (offset + i. 32) { dat
grh=. '3BA3EDFD7A7B12B27AC72C3E67768F617FC81BC3888A51323A9FB8AA4B1E5E4A'
'MerkleRoot mismatch' assert grh -: ,hfd a. i. MerkleRoot

NB. next 4 bytes is a unix epoch timestamp - rolls over 7th feb 2106
NB. there is no timezone information - it is interpreted as utc
offset=. offset + 4 [ TimeStamp=: _2 ic (offset + i. 4) { dat
'TimeStamp mismatch' assert 2009 1 3 18 15 5 -: ,tsfrunixsecs TimeStamp

NB. next 4 bytes represents block target difficulty
offset=. offset + 4 [ TargetDifficulty=: _2 ic (offset + i. 4) { dat
'TargetDifficulty mismatch' assert 486604799 = TargetDifficulty

NB. next 4 bytes is a random number nonce
offset=. offset + 4 [ Nonce=: (offset + i. 4) { dat
'Nonce mismatch' assert '1DAC2B7C' -: ,hfd a. i. Nonce

NB. next 1 to 9 bytes is the transaction count stored as a variable length integer
NB. see:  https://en.bitcoin.it/wiki/Protocol_specification#Variable_length_integer
offset=. offset + vlen [ 'vlen TransactionCount'=: vint (offset + i. 9) { dat
'TransactionCount mismatch' assert TransactionCount = 1  NB. (*)=. vlen

NB. next 4 bytes transaction version number
offset=. offset + 4 [ TransactionVersionNumber=: _2 ic (offset + i.4) { dat
'TransactionVersionNumber mismatch' assert 1 = TransactionVersionNumber

NB. next 1 to 9 bytes is the number of transaction inputs
offset=. offset + vlen [ 'vlen TransactionInputNumber'=: vint (offset + i. 9) { dat

NB. next 32 bytes is the hash of the input transaction
offset=. offset + 32 [ TransactionHash=: (offset + i. 32) { dat
'TransactionHash mismatch' assert (32#0) -: a. i. TransactionHash

NB. next 4 bytes is the input transaction index
offset=. offset + 4 [ TransactionIndex=: _2 ic (offset + i. 4) { dat
'TransactionIndex mismatch' assert _1 = TransactionIndex

NB. input script length is next
offset=. offset + vlen [ 'vlen InputScriptLength'=: vint (offset + i. 9) { dat
'InputScriptLength mismatch' assert 77 = InputScriptLength

NB. script data
offset=. offset + InputScriptLength [ InputScript=: (offset + i. InputScriptLength) { dat

NB. sequence number 4 bytes
offset=. offset + 4 [ SequenceNumber=: ,hfd a. i. (offset + i. 4) { dat
'SequenceNumber mismatch' assert 'FFFFFFFF' -: SequenceNumber

NB. output count 1 to 9 bytes
offset=. offset + vlen [ 'vlen OutputCount'=: vint (offset + i.9) { dat

NB. output value - number of satoshis sent
offset=. offset + 8 [ OutputSatoshis=: (offset + i.8) { dat  NB. 64 bit unsigned integer
'OutputSatoshis mismatch' assert '00F2052A01000000' -: ,hfd a. i. OutputSatoshis
OutputSatoshis=: ]`(_3&ic)@.IF64 OutputSatoshis

NB. challenge script length
offset=. offset + vlen [ 'vlen ChallengeScriptLength'=: vint (offset + i.9) { dat
'ChallengeScriptLength mismatch' assert 67 = ChallengeScriptLength

NB. challenge script - contains elliptic curve signatures
offset=. offset + ChallengeScriptLength [ ChallengeScript=: (offset + i. ChallengeScriptLength) { dat
'ChallengeScript mismatch' assert GenesisBlockChallengeScript -: ,hfd a. i. ChallengeScript

NB. challenge script is 67 bytes drop first and last byte to
NB. compute the familiar Bitcoin base 58 address - compare with block explorer
NB. http://blockexplorer.com/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f
OutputAddress=: Base58frKey65 }. }: ChallengeScript
'Genesis Block address mismatch' assert GenesisBlockOutputAddress -: OutputAddress

NB. last 4 bytes lock time
TransactionLockTime=: (offset + i.4) { dat
'TransactionLockTime mismatch' assert 0 0 0 0 -: a. i. TransactionLockTime

'Genesis Block Parsed and Checked'
)

NB. signal with optional message
assert=:0 0"_ $ 13!:8^:((0: e. ])`(12"_))

NB. Bitcoin base 58 from extended decimal - see long document
b58fd=:'123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz' {~ 58x #.^:_1 ]

NB. bytes from hex: cl =. bfh clHex
bfh=:a. {~ [: dfh _2 ]\ ]

NB. decimal from hex - supports upper and lower case
dfh=:16 #. 16 | '0123456789ABCDEF0123456789abcdef' i. ]

NB. hex from decimal
hfd=:16&#.@('0123456789ABCDEF'&i.)^:_1

NB. index origin one i.
i1=:>:@i.

NB. integer/character conversion
ic=:3!:4

NB. reads a file as a list of bytes
read=:1!:1&(]`<@.(32&>@(3!:0)))


todate=:3 : 0

NB.*todate v-- convert (todayno) integers to dates.
NB.
NB. WARNING:  valid only for Gregorian dates after  and including
NB. 1800 1 1.
NB.
NB. monad:  todate ilYYYYMMDD
NB.
NB.   dates=. 19530702 19520820 20000101 20000229
NB.   todate todayno 0 100 100 #: dates
NB.
NB. dyad:  pa todayno itYYYYMMDD
NB.
NB.   dates -: 1 todate todayno 0 100 100 #: dates  NB. identity

0 todate y
:
s=. $y
a=. 657377.75 +, y
d=. <. a - 36524.25 * c=. <. a % 36524.25
d=. <.1.75 + d - 365.25 * y=. <. (d+0.75) % 365.25
r=. (1+12|m+2) ,: <. 0.41+d-30.6* m=. <. (d-0.59) % 30.6
r=. s $ |: ((c*100)+y+m >: 10) ,r
if. x do. r=. 100 #. r end.
r
)


tsfrunixsecs=:3 : 0

NB.*tsfrunixsecs v-- (yyyy mm dd hh nn ss) timestamp from unix seconds.
NB.
NB. monad:  tsfrunixsecs ilSeconds
NB. 
NB.   tsfrunixsecs 1126531243
NB.
NB.   tsfrunixsecs 1126531243 + 10000?5e8 NB. 10000 random future timestamps


NB. second count cannot be negative
assert. 0 <: <./y

NB. 86400 seconds per day; 62091 unix day zero for (todayno)
'days daysecs'=.  y (<.@% ,: |~) 86400
(todate 62091 + days) ,. 24 60 60 #: daysecs
)


vint=:3 : 0

NB.*vint v-- variable length integer byte count and value.
NB.
NB. Decodes Bitcoin variable length integers and returns the byte
NB. count and value.
NB.
NB. verbatim: for more see
NB.
NB. https://en.bitcoin.it/wiki/Protocol_specification#Variable_length_integer
NB.
NB. monad:  il =. vint cl9bytes

'not nine bytes' assert 9 = #y

iv=. a. i. 0 { y

if.     iv < 253 do. 1, iv
elseif. iv = 253 do. 3, _1 ic (i1 2) { y
elseif. iv = 254 do. 5, _2 ic (i1 4) { y
elseif. iv = 255 do. 9, _3 ic (i1 8) { y  NB. 64 bit only
elseif.do. 'invalid variable length integer' assert 0
end.
)