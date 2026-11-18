/* Converted from maxflow.net*/

/* Objective function */
max: +C1 +C2 +C3 +C4 +C5 +C6 +C7 +C8;

/* Constraints */
+C1 +C2 <= 715827882;
-C1 +C3 +C4 = 0;
-C2 +C5 +C6 = 0;
-C3 -C5 +C7 = 0;
-C4 -C6 +C8 = 0;
+0 >= -C7 -C8 >= -715827882;

/* Variable bounds */
C1 <= 5;
C2 <= 15;
C3 <= 5;
C4 <= 5;
C5 <= 5;
C6 <= 5;
C7 <= 15;
C8 <= 5;