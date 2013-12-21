NB. J examples for the blog post:
NB. Turn your iPhone into a jPhone
NB. http://bakerjd99.wordpress.com/2012/06/23/turn-your-iphone-into-a-jphone-2/

NB. generate one million random numbers and average them
(+/ % #) ? 1000000#10000
   
NB. generate a 50 50 random matrix, invert it and multiply with the 
NB. original - rounding to the nearest 0.0001 to form an identity matrix 
round=: [ * [: <. 0.5 + %~
matrix=: ? 50 50 $ 10000
invmat=: %. matrix
identity=: 0.0001 round matrix +/ . * invmat
   
NB. sum of the diagonal elements of matrix (identity) is 50 
50 = +/ (<0 1) |: identity
   
NB. multiply two polynomials with complex number coefficients
polyprod=:  +//.@(*/) 

NB. complex number coefficients - AjB is J's notation for A + Bi
poly0=: 2j5 3j7 0 1
poly1=: 1j2 0 3j7 0 0 2
poly0 polyprod poly1

NB. prime factorization table of 50 random integers less than one billion
(<"0 nums) ,: -.&0 &.> <"1 q: nums=.50?1e9