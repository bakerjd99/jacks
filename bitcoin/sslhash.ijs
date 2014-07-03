NB.*sslhash s-- hash algorithms from OpenSSL.
NB.
NB. Makes  various  hash  algorithms  available  in  the  OpenSSL
NB. binaries installed with jqt 8.0x available. From an  original
NB. demo script by Pascal Jasmin with adjustments by Bill Lam.
NB.
NB. verbatim: see http://www.openssl.org/
NB. 
NB. http://www.jsoftware.com/jwiki/PascalJasmin/SHA%201%2C%202%20and%20MD5%20for%20windows
NB.
NB. interface word(s):
NB.
NB.  s256  - SHA256 hash from OpenSSL
NB.  s512  - SHA512 hash from OpenSSL
NB.  sha1  - SHA1 hash from OpenSSL
NB.  sr160 - RIPEMD-160 hash from OpenSSL
NB.
NB. created: 2014Jun28
NB. changes: -----------------------------------------------------
NB. 14jun30 changed to run on 32 bit systems
NB. 14jul03 added to jacks repository

coclass 'sslhash'

NB.*dependents

NB. profile & require words !(*)=. IFIOS IFWIN IF64 UNAME jpath

NB. dll/so path is machine/os specific - assumes jqt 8.02 is installed
sslp=. ;IFWIN { '/usr/lib/';jpath '~bin/'
OPENSSL=: sslp , ;(IFIOS + (;:'Win Linux Android Darwin') i. <UNAME) { 'libeay32.dll '; (2 $ <'libssl.so '); (2 $ <'libssl.dylib ')

NB. call dll
cd=:15!:0

sslsha256=:    (OPENSSL , ;IF64{' SHA256 > + x *c x *c';' SHA256 i *c l *c')&cd
sslsha512=:    (OPENSSL , ;IF64{' SHA512 > + x *c x *c';' SHA512 i *c l *c')&cd
sslsha1=:      (OPENSSL , ;IF64{' SHA1 > + x *c x *c';' SHA1 i *c l *c')&cd
sslRIPEMD160=: (OPENSSL , ;IF64{' RIPEMD160 > + x *c x *c';' RIPEMD160 i *c l *c')&cd

NB.*enddependents
NB.*end-header

NB. interface words (IFACEWORDSsslhash) group
IFACEWORDSsslhash=:<;._1 ' sr160 sha1 s256 s512'

NB. root words (ROOTWORDSsslhash) group
ROOTWORDSsslhash=:<;._1 ' IFACEWORDSsslhash OPENSSL ROOTWORDSsslhash s256 s512 sha1 sr160'


s256=:3 : 0

NB.*s256 v-- SHA256 hash from OpenSSL.
NB.
NB. monad:  clHash =. s256 cl
NB.
NB.   s256 'dont hash with me'
NB.
NB.   s256 10000 $ 'hash it up cowboy'

sslsha256 (y);(# y);hash=. 32#' '
hash
)


s512=:3 : 0

NB.*s512 v-- SHA512 hash from OpenSSL.
NB.
NB. monad:  clHash =. s512 cl
NB.
NB.   s512 'my what big hashes you have'
NB.
NB.   s512 10000 $ 'collisions are rare'

sslsha512 (y);(# y);hash=. 64#' '
hash
)


sha1=:3 : 0

NB.*sha1 v-- SHA1 hash from OpenSSL.
NB.
NB. monad:  clHash =. sha1 cl
NB.
NB.   sha1 'this is a fine mess'
NB.
NB.   sha1 10000 $ 'a bigger mess '

sslsha1 (y);(# y);hash=. 20#' '
hash
)


sr160=:3 : 0

NB.*sr160 v-- RIPEMD-160 hash from OpenSSL.
NB.
NB. monad:  clHash =. sr160 cl
NB.
NB.   sr160 'go ahead hash my day - result is 20 byte hash'
NB.
NB.   sr160 30000 $ 'yada yada yada et cetera byte me '

sslRIPEMD160 (y);(# y);hash=. 20#' '
hash
)

NB.POST_sslhash post processor 

smoutput 0 : 0
NB. interface word(s):
NB.   s256   NB. SHA256 hash from OpenSSL
NB.   s512   NB. SHA512 hash from OpenSSL
NB.   sha1   NB. SHA1 hash from OpenSSL
NB.   sr160  NB. RIPEMD-160 hash from OpenSSL
)

cocurrent 'base'
coinsert  'sslhash'