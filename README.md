# zk-implementation
Implementation of Zero-Knowledge proof based on discrete log problem in Sage

Peggy proves to know the value of x (for example her password).

#Peggy calculates first for one time the value <math>y = g^x \bmod{p}</math> and transfer the value to Victor.
#Peggy repeatedly calculates a random value <math>r</math> and <math>C = g^r \bmod{p}</math>. She tranfers the value <math>C </math> to Victor.
#Victor asks Peggy to calculate and transfer the value <math>(x + r) \bmod{(p-1)}</math> or simply to transfer the value <math> r </math>. in the first case Victor verifies <math>C \cdot y \equiv g^{(x + r) \bmod{(p - 1)}} \bmod{p} </math>. In the second case he verifies <math> C \equiv g^{r} \bmod{p}</math>.

The value <math>(x + r) \bmod (p-1)</math> can be seen as the encrypted value of <math>x \bmod (p-1)</math>. If <math>r</math> is true random, equally distributed between zero and <math>(p-1)</math>, this does not leak any information about <math>x</math> (see [[one-time pad]]).
