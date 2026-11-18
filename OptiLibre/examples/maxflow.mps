*<meta creator='lp_solve v5.5'>
*<meta origin='maxflow.net'>
*<meta rows=6>
*<meta columns=8>
*<meta equalities=4>
*<meta integers=0>
*<meta origsense='MAX'>
*
NAME          maxflow
ROWS
 N  R0      
 L  R1      
 E  R2      
 E  R3      
 E  R4      
 E  R5      
 G  R6      
COLUMNS
    C1        R0        -1.000000000   R1        1.0000000000
    C1        R2        -1.000000000
    C2        R0        -1.000000000   R1        1.0000000000
    C2        R3        -1.000000000
    C3        R0        -1.000000000   R2        1.0000000000
    C3        R4        -1.000000000
    C4        R0        -1.000000000   R2        1.0000000000
    C4        R5        -1.000000000
    C5        R0        -1.000000000   R3        1.0000000000
    C5        R4        -1.000000000
    C6        R0        -1.000000000   R3        1.0000000000
    C6        R5        -1.000000000
    C7        R0        -1.000000000   R4        1.0000000000
    C7        R6        -1.000000000
    C8        R0        -1.000000000   R5        1.0000000000
    C8        R6        -1.000000000
RHS
    RHS       R1        715827882.00   R6        -715827882.0
RANGES
    RGS       R6        715827882.00
BOUNDS
 UP BND       C1        5.0000000000
 UP BND       C2        15.000000000
 UP BND       C3        5.0000000000
 UP BND       C4        5.0000000000
 UP BND       C5        5.0000000000
 UP BND       C6        5.0000000000
 UP BND       C7        15.000000000
 UP BND       C8        5.0000000000
ENDATA