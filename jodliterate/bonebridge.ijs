bonebridge=:3 : 0

NB.*bonebridge  v--  lists  totem  symbol  permutations for  bone
NB. bridge.
NB.
NB. The  solution to  this MYST IV puzzle is similiar to the book
NB. shelf puzzle in Tomanha but requires far more  exploration of
NB. the age.
NB.
NB. You are confronted with  5  bones on the lock.  All the bones
NB. move independently. You can see the settings for 4 bones. One
NB. bone  has a  broken display.  The four  visible bones  have 8
NB. symbols on them in the  same order.  The  5th bone also has 8
NB. symbols and you can "safely" infer they are in the same order
NB. as the visible bones.
NB.
NB. Four  bone  symbols   match  symbols  found  on  totem  poles
NB. distributed around the  age. There is a  5th  totem pole  but
NB. fruit eating mangrees  obscure  the  totem symbol and  I have
NB. never  seen it.  The  totem  poles are  associated  with  age
NB. animals. In addition to the totem poles  there is  a chart in
NB. the  mangree  observation  hut  that  displays  a  triangular
NB. pattern  of paw  prints.  The  paw  prints  define an  animal
NB. ordering. The order  seems to be how  dangerous a  particular
NB. animal is;  big scary animals  are at the top and vegetarians
NB. are at the bottom.
NB.
NB. Putting the clues together you infer:
NB.
NB. a)  the  bridge  combination  is  some  permutation  of  five
NB. different symbols
NB.
NB. b) two possible symbol orders are given by the paw chart
NB.
NB. c) you know 5 symbols and the 4th is one of the remaining 4
NB.
NB. If this is  the  case  the number of  possible  lock settings
NB. shrinks from 32768 to the ones listed by this verb.
NB.
NB. monad:  bonebridge uuIgnore
NB.
NB.   bonebridge 0

NB. known in paw order
known=.    s: ' square triangle hourglass yingyang'
unknown=.  s: ' clover cross xx yy'

NB. all possible lock permutations
settings=. ~. 5 {."1 tapl known,unknown
assert. ((!8)%!8-5) = #settings

NB. possible ordering - we don't know
NB. what the fifth symbol is but it
NB. occurs in the 3rd slot
order=. 8#s:<''
order=. known (0 1 6 7)} order
order=. unknown (2 3 4 5)} order

NB. keep unknown only in 3rd slot
settings=. settings #~ -. +./"1 (0 1 3 4{"1 settings) e. unknown
settings=. settings #~ (2 {"1 settings) e. unknown

NB. strict row sequence adverb
srsm=. {{ *./"1 u/&> 2 <\"1 y }} 

NB. retain strictly increasing and strictly decreasing rows
grade=. order i. settings
settings #~ ((< srsm)"1 grade) +. (> srsm)"1 grade
)
