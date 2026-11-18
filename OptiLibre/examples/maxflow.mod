/* Converted from maxflox.net */

/* Variable definitions */
var C1 >= 0 <= 5;
var C2 >= 0 <= 15;
var C3 >= 0 <= 5;
var C4 >= 0 <= 5;
var C5 >= 0 <= 5;
var C6 >= 0 <= 5;
var C7 >= 0 <= 15;
var C8 >= 0 <= 5;


/* Objective function */
maximize obj: +C1 +C2 +C3 +C4 +C5 +C6 +C7 +C8;

/* Constraints */
R1: +C1 +C2 <= 715827882;
R2: -C1 +C3 +C4 = 0;
R3: -C2 +C5 +C6 = 0;
R4: -C3 -C5 +C7 = 0;
R5: -C4 -C6 +C8 = 0;
R6: +0 >= -C7 -C8 >= -715827882;
