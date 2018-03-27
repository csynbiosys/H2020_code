      SUBROUTINE STKDMP
C
C  THIS PROCEDURE PROVIDES A DUMP OF THE PORT STACK.
C
C  WRITTEN BY D. D. WARNER.
C
C  MOSTLY REWRITTEN BY P. A. FOX, OCTOBER 13, 1982
C  AND COMMENTS ADDED.
C
C  ALLOCATED REGIONS OF THE STACK ARE PRINTED OUT IN THE APPROPRIATE
C  FORMAT, EXCEPT IF THE STACK APPEARS TO HAVE BEEN OVERWRITTEN.
C  IF OVERWRITE SEEMS TO HAVE HAPPENED, THE ENTIRE STACK IS PRINTED OUT
C  IN UNSTRUCTURED FORM, ONCE FOR EACH OF THE POSSIBLE
C  (LOGICAL, INTEGER, REAL, DOUBLE PRECISION, OR COMPLEX) FORMATS.
C
      COMMON /CSTAK/ DSTAK
      DOUBLE PRECISION DSTAK(500)
      REAL RSTAK(1000)
C/R
C     REAL CMSTAK(2,500)
C/C
      COMPLEX CMSTAK(500)
C/
      INTEGER ISTAK(1000)
      LOGICAL LSTAK(1000)
C
      INTEGER LOUT, LNOW, LUSED, LMAX, LBOOK
      INTEGER LLOUT, BPNTR
      INTEGER IPTR, ERROUT, MCOL, NITEMS
      INTEGER WR, DR, WD, DD, WI
      INTEGER LNG(5), ISIZE(5)
      INTEGER I, LNEXT, ITYPE, I1MACH
C
      LOGICAL INIT, TRBL1, TRBL2
C
      EQUIVALENCE (DSTAK(1), ISTAK(1))
      EQUIVALENCE (DSTAK(1), LSTAK(1))
      EQUIVALENCE (DSTAK(1), RSTAK(1))
C/R
C     EQUIVALENCE (DSTAK(1), CMSTAK(1,1))
C/C
      EQUIVALENCE (DSTAK(1), CMSTAK(1))
C/
      EQUIVALENCE (ISTAK(1), LOUT)
      EQUIVALENCE (ISTAK(2), LNOW)
      EQUIVALENCE (ISTAK(3), LUSED)
      EQUIVALENCE (ISTAK(4), LMAX)
      EQUIVALENCE (ISTAK(5), LBOOK)
      EQUIVALENCE (ISTAK(6), ISIZE(1))
C
      DATA MCOL/132/
      DATA INIT/.TRUE./
C
C  I0TK00 CHECKS TO SEE IF THE FIRST TEN, BOOKKEEPING, LOCATIONS OF
C  THE STACK HAVE BEEN INITIALIZED (AND DOES IT, IF NEEDED).
C
      IF (INIT) CALL I0TK00(INIT, 500, 4)
C
C
C  I1MACH(4) IS THE STANDARD ERROR MESSAGE WRITE UNIT.
C
      ERROUT = I1MACH(4)
      WRITE (ERROUT,  9901)
 9901   FORMAT (11H1STACK DUMP)
C
C
C  FIND THE MACHINE-DEPENDENT FORMATS FOR PRINTING - BUT ADD 1 TO
C  THE WIDTH TO GET SEPARATION BETWEEN ITEMS, AND SUBTRACT 1 FROM
C  THE NUMBER OF DIGITS AFTER THE DECIMAL POINT TO ALLOW FOR THE
C  1P IN THE DUMP FORMAT OF 1PEW.D
C
C  (NOTE, THAT ALTHOUGH IT IS NOT NECESSARY, 2 HAS BEEN ADDED TO
C   THE INTEGER WIDTH, WI, TO CONFORM WITH DAN WARNERS PREVIOUS
C   USAGE - SO PEOPLE CAN COMPARE DUMPS WITH ONES THEY HAVE HAD
C   AROUND FOR A LONG TIME.)
C
       CALL FRMATR(WR,DR)
       CALL FRMATD(WD,DD)
       CALL FRMATI(WI)
C
       WR = WR+1
       WD = WD+1
       WI = WI+2
       DR = DR-1
       DD = DD-1
C
C  CHECK, IN VARIOUS WAYS, THE BOOKKEEPING PART OF THE STACK TO SEE
C  IF THINGS WERE OVERWRITTEN.
C
C  LOUT  IS THE NUMBER OF CURRENT ALLOCATIONS
C  LNOW  IS THE CURRENT ACTIVE LENGTH OF THE STACK
C  LUSED IS THE MAXIMUM VALUE OF LNOW ACHIEVED
C  LMAX  IS THE MAXIMUM LENGTH OF THE STACK
C  LBOOK IS THE NUMBER OF WORDS USED FOR BOOK-KEEPING
C
      TRBL1 = LBOOK .NE. 10
      IF (.NOT. TRBL1) TRBL1 = LMAX .LT. 12
      IF (.NOT. TRBL1) TRBL1 = LMAX .LT. LUSED
      IF (.NOT. TRBL1) TRBL1 = LUSED .LT. LNOW
      IF (.NOT. TRBL1) TRBL1 = LNOW .LT. LBOOK
      IF (.NOT. TRBL1) TRBL1 = LOUT .LT. 0
      IF (.NOT. TRBL1) GO TO 10
C
         WRITE (ERROUT,  9902)
 9902      FORMAT (29H0STACK HEADING IS OVERWRITTEN)
         WRITE (ERROUT,  9903)
 9903      FORMAT (47H UNSTRUCTURED DUMP OF THE DEFAULT STACK FOLLOWS)
C
C  SINCE INFORMATION IS LOST, SIMPLY SET THE USUAL DEFAULT VALUES FOR
C  THE LENGTH OF THE ENTIRE STACK IN TERMS OF EACH (LOGICAL, INTEGER,
C  ETC.,) TYPE.
C
      LNG(1) = 1000
      LNG(2) = 1000
      LNG(3) = 1000
      LNG(4) = 500
      LNG(5) = 500
C
C
         CALL U9DMP(LNG, MCOL, WI, WR, DR, WD, DD)
         GO TO  110
C
C  WRITE OUT THE STORAGE UNITS USED BY EACH TYPE OF VARIABLE
C
   10    WRITE (ERROUT,  9904)
 9904      FORMAT (19H0STORAGE PARAMETERS)
         WRITE (ERROUT,  9905) ISIZE(1)
 9905      FORMAT (18H LOGICAL          , I7, 14H STORAGE UNITS)
         WRITE (ERROUT,  9906) ISIZE(2)
 9906      FORMAT (18H INTEGER          , I7, 14H STORAGE UNITS)
         WRITE (ERROUT,  9907) ISIZE(3)
 9907      FORMAT (18H REAL             , I7, 14H STORAGE UNITS)
         WRITE (ERROUT,  9908) ISIZE(4)
 9908      FORMAT (18H DOUBLE PRECISION , I7, 14H STORAGE UNITS)
         WRITE (ERROUT,  9909) ISIZE(5)
 9909      FORMAT (18H COMPLEX          , I7, 14H STORAGE UNITS)
C
C  WRITE OUT THE CURRENT STACK STATISTICS (I.E. USAGE)
C
         WRITE (ERROUT,  9910)
 9910      FORMAT (17H0STACK STATISTICS)
         WRITE (ERROUT,  9911) LMAX
 9911      FORMAT (23H STACK SIZE            , I7)
         WRITE (ERROUT,  9912) LUSED
 9912      FORMAT (23H MAXIMUM STACK USED    , I7)
         WRITE (ERROUT,  9913) LNOW
 9913      FORMAT (23H CURRENT STACK USED    , I7)
         WRITE (ERROUT,  9914) LOUT
 9914      FORMAT (23H NUMBER OF ALLOCATIONS , I7)
C
C  HERE AT LEAST THE BOOKKEEPING PART OF THE STACK HAS NOT BEEN
C  OVERWRITTEN.
C
C  STACKDUMP WORKS BACKWARDS FROM THE END (MOST RECENT ALLOCATION) OF
C  THE STACK, PRINTING INFORMATION, BUT ALWAYS CHECKING TO SEE IF
C  THE POINTERS FOR AN ALLOCATION HAVE BEEN OVERWRITTEN.
C
C  LLOUT COUNTS THE NUMBER OF ALLOCATIONS STILL LEFT TO PRINT
C  SO LLOUT IS INITIALLY LOUT OR ISTAK(1).
C
C  THE STACK ALLOCATION ROUTINE PUTS, AT THE END OF EACH ALLOCATION,
C  TWO EXTRA SPACES - ONE FOR THE TYPE OF THE ALLOCATION AND THE NEXT
C  TO HOLD A BACK POINTER TO THE PREVIOUS ALLOCATION.
C  THE BACK POINTER IS THEREFORE INITIALLY LOCATED AT THE INITIAL END,
C  LNOW, OF THE STACK.
C  CALL THIS LOCATION BPNTR.
C
          LLOUT = LOUT
          BPNTR = LNOW
C
C  IF WE ARE DONE, THE BACK POINTER POINTS BACK INTO THE BOOKKEEPING
C  PART OF THE STACK.
C
C  IF WE ARE NOT DONE, OBTAIN THE NEXT REGION TO PRINT AND GET ITS TYPE.
C
   20    IF (BPNTR .LE. LBOOK) GO TO  110
C
            LNEXT = ISTAK(BPNTR)
            ITYPE = ISTAK(BPNTR-1)
C
C  SEE IF ANY OF THESE NEW DATA ARE INCONSISTENT - WHICH WOULD SIGNAL
C  AN OVERWRITE.
C
            TRBL2 = LNEXT .LT. LBOOK
            IF (.NOT. TRBL2) TRBL2 = BPNTR .LE. LNEXT
            IF (.NOT. TRBL2) TRBL2 = ITYPE .LT. 0
            IF (.NOT. TRBL2) TRBL2 = 5 .LT. ITYPE
            IF (.NOT. TRBL2) GO TO 40
C
C  HERE THERE SEEMS TO HAVE BEEN A PARTIAL OVERWRITE.
C  COMPUTE THE LENGTH OF THE ENTIRE STACK IN TERMS OF THE VALUES GIVEN
C  IN THE BOOKKEEPING PART OF THE STACK (WHICH, AT LEAST, SEEMS NOT TO
C  HAVE BEEN OVERWRITTEN), AND DO AN UNFORMATTED DUMP, AND RETURN.
C
               WRITE (ERROUT,  9915)
 9915            FORMAT (28H0STACK PARTIALLY OVERWRITTEN)
               WRITE (ERROUT,  9916)
 9916          FORMAT (45H UNSTRUCTURED DUMP OF REMAINING STACK FOLLOWS)
C
         DO  30 I = 1, 5
            LNG(I) = (BPNTR*ISIZE(2)-1)/ISIZE(I)+1
   30    CONTINUE
C
               CALL U9DMP(LNG, MCOL, WI, WR, DR, WD, DD)
               GO TO  110
C
C
C  COMES HERE EACH TIME TO PRINT NEXT (BACK) ALLOCATION.
C
C  AT THIS POINT BPNTR POINTS TO THE END OF THE ALLOCATION ABOUT TO
C  BE PRINTED, LNEXT = ISTAK(BPNTR) POINTS BACK TO THE END OF THE
C  PREVIOUS ALLOCATION, AND ITYPE = ISTAK(BPNTR-1) GIVES THE TYPE OF
C  THE ALLOCATION ABOUT TO BE PRINTED.
C
C  THE PRINTING ROUTINES NEED TO KNOW THE START OF THE ALLOCATION AND
C  THE NUMBER OF ITEMS.
C  THESE ARE COMPUTED FROM THE EQUATIONS USED WHEN THE FUNCTION ISTKGT
C  COMPUTED THE ORIGINAL ALLOCATION - THE POINTER TO THE
C  START OF THE ALLOCATION WAS COMPUTED BY ISTKGT FROM THE (THEN)
C  END OF THE PREVIOUS ALLOCATION VIA THE FORMULA,
C
C           ISTKGT = (LNOW*ISIZE(2)-1)/ISIZE(ITYPE) + 2
C
   40       IPTR   = (LNEXT*ISIZE(2)-1)/ISIZE(ITYPE) + 2
C
C  THE FUNCTION ISTKGT THEN FOUND NEW END OF THE STACK, LNOW, FROM THE
C  FORMULA
C
C          I = ( (ISTKGT-1+NITEMS)*ISIZE(ITYPE) - 1 )/ISIZE(2) + 3
C
C  HERE WE SOLVE THIS FOR NITEMS TO DETERMINE THE NUMBER OF LOCATIONS
C  IN THIS ALLOCATION.
C
            NITEMS = 1-IPTR + ((BPNTR-3)*ISIZE(2)+1)/ISIZE(ITYPE)
C
C
C  USE THE TYPE (INTEGER, REAL, ETC.) TO DTERMINE WHICH PRINTING
C  ROUTINE TO USE.
C
               IF (ITYPE .EQ. 1) GO TO  50
               IF (ITYPE .EQ. 2) GO TO  60
               IF (ITYPE .EQ. 3) GO TO  70
               IF (ITYPE .EQ. 4) GO TO  80
               IF (ITYPE .EQ. 5) GO TO  90
C
   50          WRITE (ERROUT,  9917) LLOUT, IPTR
 9917            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =,
     1            I7, 23H,          TYPE LOGICAL)
               CALL A9RNTL(LSTAK(IPTR), NITEMS, ERROUT, MCOL)
               GO TO  100
C
   60          WRITE (ERROUT,  9918) LLOUT, IPTR
 9918            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =,
     1            I7, 23H,          TYPE INTEGER)
               CALL A9RNTI(ISTAK(IPTR), NITEMS, ERROUT, MCOL, WI)
               GO TO  100
C
   70          WRITE (ERROUT,  9919) LLOUT, IPTR
 9919            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =,
     1            I7, 20H,          TYPE REAL)
               CALL A9RNTR(RSTAK(IPTR), NITEMS, ERROUT, MCOL, WR, DR)
               GO TO  100
C
   80          WRITE (ERROUT,  9920) LLOUT, IPTR
 9920            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =,
     1            I7, 32H,          TYPE DOUBLE PRECISION)
               CALL A9RNTD(DSTAK(IPTR), NITEMS, ERROUT, MCOL, WD, DD)
               GO TO  100
C
   90          WRITE (ERROUT,  9921) LLOUT, IPTR
 9921            FORMAT (13H0ALLOCATION =, I7, 20H,          POINTER =,
     1            I7, 23H,          TYPE COMPLEX)
C/R
C              CALL A9RNTC(CMSTAK(1,IPTR), NITEMS, ERROUT, MCOL, WR,DR)
C/C
               CALL A9RNTC(CMSTAK(IPTR), NITEMS, ERROUT, MCOL, WR, DR)
C/
C
 100        BPNTR = LNEXT
            LLOUT = LLOUT-1
            GO TO 20
C
  110  WRITE (ERROUT,  9922)
 9922   FORMAT (18H0END OF STACK DUMP)
      RETURN
      END
