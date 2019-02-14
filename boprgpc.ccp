        $SET DB2 (DB=INFOSYS,UDB-VERSION=V8)
        IDENTIFICATION DIVISION.
        PROGRAM-ID.     BOPRGPC.
        AUTHOR.         OAKE.

        ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
        SOURCE-COMPUTER. RS-6000.
        OBJECT-COMPUTER. RS-6000.
        
        DATA DIVISION.
        WORKING-STORAGE SECTION.
        
        EXEC SQL INCLUDE SQLCA END-EXEC.
        
        01 WS-SQL-CODE          PIC -9(8).
        
        EXEC SQL BEGIN DECLARE SECTION END-EXEC.   
            01  SQL-PRODUCT-CODE            PIC X(8).
            01  SQL-PRODUCT-DESC            PIC X(17).
        EXEC SQL END DECLARE SECTION END-EXEC.
        
        LINKAGE SECTION.
            01  DFHCOMMAREA.
                05  LK-PRODUCT  PIC X(8).
                05  LK-DESC     PIC X(17).
        
        PROCEDURE DIVISION.
        
            EXEC SQL 
                WHENEVER NOT FOUND GO TO 10-CODE-ERR 
            END-EXEC.
            
            EXEC SQL 
                WHENEVER SQLERROR GO TO 99-SQL-ERR 
            END-EXEC.
            
            EXEC SQL
                WHENEVER SQLWARNING CONTINUE
            END-EXEC.
            
            PERFORM 10-CHECK-PART THRU 10-EXIT.
            
            EXEC CICS RETURN END-EXEC.
            
        10-CHECK-PART.
            MOVE LK-PRODUCT TO SQL-PRODUCT-CODE.
            
            EXEC SQL SELECT PART_DESC INTO :SQL-PRODUCT-DESC
                FROM BILLM.PART_CODES
                WHERE PART_CODE = :SQL-PRODUCT-CODE
            END-EXEC.
            
            MOVE SQL-PRODUCT-DESC TO LK-DESC.
            
            GO TO 10-EXIT.
            
            10-CODE-ERR.
                MOVE 'PART NOT FOUND' TO LK-DESC.
                
            10-EXIT.
                EXIT.
                
            99-SQL-ERR.
                MOVE SQLCODE TO WS-SQL-CODE.
                MOVE WS-SQL-CODE TO LK-DESC.
                EXEC CICS RETURN END-EXEC.