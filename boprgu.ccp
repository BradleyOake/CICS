        IDENTIFICATION DIVISION.
        PROGRAM-ID.  BOPRGU.
        AUTHOR. OAKE.

        ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
        SOURCE-COMPUTER. RS-6000.
        OBJECT-COMPUTER. RS-6000.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        
        COPY 'BOMAP2'.
        COPY 'DFHBMSCA'.
        COPY 'ORDFILE-LAYOUT'.
        
		01 WS-PC-ERROR              PIC X VALUE 'N'.
		01 WS-VALID-PART-COUNT		PIC 9 VALUE 0.
        01 WS-SAVEAREA.
            05 WS-UPD-SW          PIC XXX VALUE 'UPD'.
            05 SAVE-PROD1-1       PIC X(4).
            05 SAVE-PROD1-2       PIC X(4).
            05 SAVE-PROD2-1       PIC X(4).
            05 SAVE-PROD2-2       PIC X(4).
            05 SAVE-PROD3-1       PIC X(4).
            05 SAVE-PROD3-2       PIC X(4).
            05 SAVE-PROD4-1       PIC X(4).
            05 SAVE-PROD4-2       PIC X(4).
            05 SAVE-PROD5-1       PIC X(4).
            05 SAVE-PROD5-2       PIC X(4).
            05 SAVE-NAME          PIC X(20).
            05 SAVE-ADDLN1        PIC X(20).
            05 SAVE-ADDLN2        PIC X(20).
            05 SAVE-ADDLN3        PIC X(20).
            05 SAVE-POSTAL1       PIC X(3).
            05 SAVE-POSTAL2       PIC X(3).
            05 SAVE-ARCODE        PIC X(3).
            05 SAVE-EXCHNO        PIC X(3).
            05 SAVE-PHONNUM       PIC X(4).
        01 WS-SAVE-LENGTH            PIC S9(4) COMP VALUE 139.
        
        01 WS-TRANSFER-FIELD    PIC X(3).
        01 WS-TRANSFER-LENGTH   PIC S9(4) COMP VALUE 3.
        
		01 WS-POSTAL-CODE.
			05 WS-POSTAL-1.
				10 WS-POSTAL-CHAR-1		PIC X.
				10 WS-POSTAL-CHAR-2		PIC X.
				10 WS-POSTAL-CHAR-3		PIC X.
			05 WS-POSTAL-2.
				10 WS-POSTAL-CHAR-4		PIC X.
				10 WS-POSTAL-CHAR-5		PIC X.
				10 WS-POSTAL-CHAR-6		PIC X.

        01 WS-TRIM-DATA   PIC X(20).
        01 WS-TRIM-SPACES PIC 9(4) VALUE 0.
        01 WS-TRIM-LEN    PIC 9(4) VALUE 0.
		
		01 WS-CURSOR-POS            PIC 9999 VALUE 285.
		
		01 WS-PART-EDIT.
           05 WS-CODE             PIC X(8).
           05 WS-DESCRIPTION      PIC X(17).            
        01 WS-PART-EDIT-LENGTH    PIC S9(4) COMP VALUE 25.
		
        01 WS-PART-TABLE OCCURS 5 TIMES INDEXED BY PART-INDEX.
            05 WS-PROD-1 PIC X(4).
            05 WS-PROD-2 PIC X(4).
        01 PART-INDEX-2 PIC 9 VALUE 0.    
        
        01 WS-PRODUCT-TABLE.
            05 WS-PRODUCT-CODE OCCURS 5 TIMES INDEXED BY WS-COUNTER.
                10 WS-PRODUCT-CODE-1    PIC X(4).
                10 WS-PRODUCT-CODE-2    PIC X(4).
            
        LINKAGE SECTION.      
            01  DFHCOMMAREA.
                05  LK-SAVE                 PIC X(139).

        PROCEDURE DIVISION.
            
            EXEC CICS HANDLE AID 
                PF4 (999-EXIT) 
                PF8 (800-DELETE)
            END-EXEC.
            
            EXEC CICS HANDLE CONDITION 
                MAPFAIL(100-FIRST-TIME)
            END-EXEC.
            
* WHENEVER NOT FOUND            
            
            EXEC CICS 
                RECEIVE MAP('MAP2') MAPSET('BOMAP2') 
            END-EXEC.
            
            MOVE LK-SAVE TO WS-SAVEAREA.
                
            IF WS-UPD-SW = 'INQ'
                  GO TO 500-INQUIRY
            ELSE
                  GO TO 600-UPDATE
            END-IF.            
           
            
            100-FIRST-TIME.
               
               PERFORM 700-PROTECT-FOR-INQUIRY.
               
                EXEC CICS
                    SEND MAP('MAP2') MAPSET('BOMAP2') ERASE
                END-EXEC.
                
                EXEC CICS RETURN TRANSID ('BO04')
                        COMMAREA(WS-SAVEAREA)
                        LENGTH(WS-SAVE-LENGTH)
                END-EXEC.        
                
            500-INQUIRY.
                   
                IF INVNUML IS NOT EQUAL TO 7
                    MOVE 'INVOICE NUMBER MUST BE 7 DIGITS' TO MSGO
                    MOVE -1 TO INVNUML
                    
                    MOVE DFHUNIMD TO INVNUMA
                    
                    GO TO 910-SEND-MAP-ERR           
                END-IF.
                
                IF INVNUMI IS NOT NUMERIC
                    MOVE 'INVOICE NUMBER MUST BE NUMERIC' TO MSGO
                    
                    MOVE -1 TO INVNUML
                    MOVE DFHUNIMD TO INVNUMA
                    
                    GO TO 910-SEND-MAP-ERR              
                END-IF.   
                   
                MOVE INVNUMI TO ORDFILE-INVOICE-NO.
                
                EXEC CICS READ FILE('ORDFILE')
                    INTO (ORDFILE-RECORD)
                    LENGTH (ORDFILE-LENGTH)
                    RIDFLD (ORDFILE-KEY)
                END-EXEC. 

                MOVE ORDFILE-ADDR-LINE1 TO WS-TRIM-DATA.
                PERFORM 510-TRIM-SPACES.
                MOVE WS-TRIM-DATA TO ORDFILE-ADDR-LINE1.
                
                MOVE ORDFILE-ADDR-LINE2 TO WS-TRIM-DATA.
                PERFORM 510-TRIM-SPACES.
                MOVE WS-TRIM-DATA TO ORDFILE-ADDR-LINE2.
                
                MOVE ORDFILE-ADDR-LINE3 TO WS-TRIM-DATA.
                PERFORM 510-TRIM-SPACES.
                MOVE WS-TRIM-DATA TO ORDFILE-ADDR-LINE3.
                
                MOVE ORDFILE-NAME TO WS-TRIM-DATA.
                PERFORM 510-TRIM-SPACES.
                MOVE WS-TRIM-DATA TO ORDFILE-NAME.
                
                MOVE LOW-VALUES TO MAP2O.
                MOVE ORDFILE-P1A TO PROD1-1O, SAVE-PROD1-1.
                MOVE ORDFILE-P1B TO PROD1-2O, SAVE-PROD1-2. 
                MOVE ORDFILE-P2A TO PROD2-1O, SAVE-PROD2-1.
                MOVE ORDFILE-P2B TO PROD2-2O, SAVE-PROD2-2.
                MOVE ORDFILE-P3A TO PROD3-1O, SAVE-PROD3-1.
                MOVE ORDFILE-P3B TO PROD3-2O, SAVE-PROD3-2.
                MOVE ORDFILE-P4A TO PROD4-1O, SAVE-PROD4-1.
                MOVE ORDFILE-P4B TO PROD4-2O, SAVE-PROD4-2.
                MOVE ORDFILE-P5A TO PROD5-1O, SAVE-PROD5-1.
                MOVE ORDFILE-P5B TO PROD5-2O, SAVE-PROD5-2.
                
                MOVE ORDFILE-NAME TO NAMEO, SAVE-NAME.
                MOVE ORDFILE-ADDR-LINE1 TO ADDLN1O, SAVE-ADDLN1.
                MOVE ORDFILE-ADDR-LINE2 TO ADDLN2O, SAVE-ADDLN2.
                MOVE ORDFILE-ADDR-LINE3 TO ADDLN3O, SAVE-ADDLN3.
                MOVE ORDFILE-POSTAL-1 TO POSTAL1O, SAVE-POSTAL1.
                MOVE ORDFILE-POSTAL-2 TO POSTAL2O, SAVE-POSTAL2.
                
                MOVE ORDFILE-AREA-CODE TO ARCODEO, SAVE-ARCODE.
                MOVE ORDFILE-EXCHANGE TO EXCHNOO, SAVE-EXCHNO.
                MOVE ORDFILE-PHONE-NUM TO PHONNUMO, SAVE-PHONNUM.
                    
                MOVE ORDFILE-INVOICE-NO TO INVNUMO.
                MOVE DFHBMPRO TO INVNUMA.
                               
                PERFORM 800-UNPROTECT-FOR-UPDATE.
                
                EXEC CICS
                    SEND MAP('MAP2') MAPSET('BOMAP2') ERASE
                END-EXEC.
                
                EXEC CICS RETURN TRANSID('BO04') 
                        COMMAREA(WS-SAVEAREA)
                        LENGTH(WS-SAVE-LENGTH) 
               END-EXEC.
               
            510-TRIM-SPACES.

                INSPECT FUNCTION REVERSE(WS-TRIM-DATA)                  X
                  TALLYING WS-TRIM-SPACES FOR LEADING SPACES.

                COMPUTE WS-TRIM-LEN =
                        LENGTH OF WS-TRIM-DATA - WS-TRIM-SPACES.

                IF WS-TRIM-LEN = 0
                    MOVE LOW-VALUES TO WS-TRIM-DATA
                ELSE
                    MOVE WS-TRIM-DATA(1:WS-TRIM-LEN) TO WS-TRIM-DATA
                END-IF.    
                
            600-UPDATE.

                       
                IF PROD1-1I <> SAVE-PROD1-1 
                   OR PROD1-2I <> SAVE-PROD1-2
                   OR PROD2-1I <> SAVE-PROD2-1
                   OR PROD2-2I <> SAVE-PROD2-2
                   OR PROD3-1I <> SAVE-PROD3-1
                   OR PROD3-2I <> SAVE-PROD3-2
                   OR PROD4-1I <> SAVE-PROD4-1
                   OR PROD4-2I <> SAVE-PROD4-2
                   OR PROD5-1I <> SAVE-PROD5-1
                   OR PROD5-2I <> SAVE-PROD5-2
                   OR NAMEI <> SAVE-NAME
                   OR ADDLN1I <> SAVE-ADDLN1
                   OR ADDLN2I <> SAVE-ADDLN2
                   OR ADDLN3I <> SAVE-ADDLN3
                   OR POSTAL1I <> SAVE-POSTAL1
                   OR POSTAL2I <> SAVE-POSTAL2
                   OR ARCODEI <> SAVE-ARCODE
                   OR EXCHNOI <> SAVE-EXCHNO
                   OR PHONNUMI <> SAVE-PHONNUM
        
        IF NAMEI(1:6) EQUALS 'DELETE'
            MOVE LOW-VALUES TO MAP2O
            MOVE 'PLEASE PRESS F8 TO DELETE THE FILE' TO MSGO

            GO TO 910-SEND-MAP-ERR    
        END-IF        
        
        IF INVNUML IS NOT EQUAL TO 7
            MOVE LOW-VALUES TO MAP2O
            MOVE 'INVOICE NUMBER MUST BE 7 DIGITS' TO MSGO
            MOVE -1 TO INVNUML
            MOVE 285 TO WS-CURSOR-POS
                
            MOVE DFHUNIMD TO INVNUMA
                
            GO TO 910-SEND-MAP-ERR           
        END-IF
            
        IF INVNUMI IS NOT NUMERIC
            MOVE LOW-VALUES TO MAP2O
            MOVE 'INVOICE NUMBER MUST BE NUMERIC' TO MSGO
                
            MOVE -1 TO INVNUML
            MOVE 285 TO WS-CURSOR-POS
            MOVE DFHUNIMD TO INVNUMA
                
            GO TO 910-SEND-MAP-ERR                        
        END-IF
            
        IF NAMEL IS LESS THAN 4
            MOVE LOW-VALUES TO MAP2O
            MOVE 'CONTACT NAME MUST BE AT LEAST 4 LONG' 
                TO MSGO

            MOVE 919 TO WS-CURSOR-POS
            MOVE -1 TO NAMEL
            MOVE DFHUNIMD TO NAMEA

            GO TO 910-SEND-MAP-ERR           
        END-IF
        
        IF ADDLN1L IS LESS THAN 3
            MOVE LOW-VALUES TO MAP2O
            MOVE 'ADDRESS LINE 1 MUST BE AT LEAST 3 LONG' 
				TO MSGO
                
            MOVE 1079 TO WS-CURSOR-POS    
            MOVE -1 TO ADDLN1L    
            MOVE DFHUNIMD TO ADDLN1A
             
			GO TO 910-SEND-MAP-ERR           
        END-IF
        
        IF ADDLN2L IS LESS THAN 3
            MOVE LOW-VALUES TO MAP2O
            MOVE 'ADDRESS LINE 2 MUST BE AT LEAST 3 LONG' 
				TO MSGO
                
            MOVE 1159 TO WS-CURSOR-POS
            MOVE -1 TO ADDLN2L    
            MOVE DFHUNIMD TO ADDLN2A
            
			GO TO 910-SEND-MAP-ERR           			
        END-IF
		
		IF ADDLN3L > 0 AND < 3
            MOVE LOW-VALUES TO MAP2O
			MOVE 'ADDRESS LINE 3 MUST BE AT LEAST 3 LONG' 
				TO MSGO
			
			MOVE 1239 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO ADDLN3A
			
			GO TO 910-SEND-MAP-ERR           
		END-IF
		
		MOVE POSTAL1I TO WS-POSTAL-1
		MOVE POSTAL2I TO WS-POSTAL-2
		
		IF WS-POSTAL-CHAR-1 IS NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'INVALID POSTAL CODE' 
				TO MSGO
			
			MOVE 1319 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO POSTAL1A
			
			GO TO 910-SEND-MAP-ERR           
		END-IF
		
		IF WS-POSTAL-CHAR-2 IS NOT NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'INVALID POSTAL CODE' 
				TO MSGO
			
			MOVE 1319 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO POSTAL1A
			
			GO TO 910-SEND-MAP-ERR           
		END-IF
		
		IF WS-POSTAL-CHAR-3 IS NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'INVALID POSTAL CODE' 
				TO MSGO
			
			MOVE 1319 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO POSTAL1A
			
			GO TO 910-SEND-MAP-ERR           
		END-IF
		
		IF WS-POSTAL-CHAR-4 IS NOT NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'INVALID POSTAL CODE' 
				TO MSGO
			
			MOVE 1323 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO POSTAL2A
			
			GO TO 910-SEND-MAP-ERR           
		END-IF
		
		IF WS-POSTAL-CHAR-5 IS NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'INVALID POSTAL CODE' 
				TO MSGO
            MOVE LOW-VALUES TO MAP2O
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 439 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD1-1A
			
            GO TO 910-SEND-MAP-ERR
			
		ELSE IF PROD1-2I IS NOT NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 444 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD1-2A
			
            GO TO 910-SEND-MAP-ERR
		ELSE
			ADD 1 TO WS-VALID-PART-COUNT
		END-IF
		
		IF PROD2-1L EQUALS ZERO
            MOVE LOW-VALUES TO MAP2O
			MOVE 'A PRODUCT MUST BE ENTERED' TO MSGO
		ELSE IF PROD2-1I IS NUMERIC
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 519 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD2-1A
			
            GO TO 910-SEND-MAP-ERR
			
		ELSE IF PROD2-2I IS NOT NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 524 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD2-2A
			
            GO TO 910-SEND-MAP-ERR
		ELSE
			ADD 1 TO WS-VALID-PART-COUNT
		END-IF
		
		IF PROD3-1L EQUALS ZERO
            MOVE LOW-VALUES TO MAP2O
			MOVE 'A PRODUCT MUST BE ENTERED' TO MSGO
		ELSE IF PROD3-1I IS NUMERIC
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 599 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD3-1A
			
            GO TO 910-SEND-MAP-ERR
			
		ELSE IF PROD3-2I IS NOT NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 604 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD3-2A
            
			GO TO 910-SEND-MAP-ERR
            
		ELSE
			ADD 1 TO WS-VALID-PART-COUNT
		END-IF
		
		IF PROD4-1L EQUALS ZERO
            MOVE LOW-VALUES TO MAP2O
			MOVE 'A PRODUCT MUST BE ENTERED' TO MSGO
		ELSE IF PROD4-1I IS NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 679 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD4-1A
			
			GO TO 910-SEND-MAP-ERR
            
		ELSE IF PROD4-2I IS NOT NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 684 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD4-2A
			
            GO TO 910-SEND-MAP-ERR
            
		ELSE
			ADD 1 TO WS-VALID-PART-COUNT
		END-IF
		
		IF PROD5-1L EQUALS ZERO
            MOVE LOW-VALUES TO MAP2O
			MOVE 'A PRODUCT MUST BE ENTERED' TO MSGO
		ELSE IF PROD5-1I IS NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 759 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD5-1A
            
            GO TO 910-SEND-MAP-ERR	
            
		ELSE IF PROD5-2I IS NOT NUMERIC
            MOVE LOW-VALUES TO MAP2O
			MOVE 'PRODUCTS MUST FOLLOW FORMAT (XXXX 9999)' 
				TO MSGO
			
			MOVE 764 TO WS-CURSOR-POS
			MOVE DFHUNIMD TO PROD5-2A
            
			GO TO 910-SEND-MAP-ERR
            
		ELSE
			ADD 1 TO WS-VALID-PART-COUNT
		END-IF
        
	    IF WS-VALID-PART-COUNT < 1
            MOVE LOW-VALUES TO MAP2O
			MOVE 'AT LEAST 1 PART REQUIRED' TO MSGO
			MOVE 439 TO WS-CURSOR-POS
			
			GO TO 910-SEND-MAP-ERR           
		END-IF
	
        IF PROD1-1L = 0 AND PROD1-2L = 0
            MOVE LOW-VALUES TO WS-PROD-1(1)
            MOVE LOW-VALUES TO WS-PROD-2(1)
        ELSE
            MOVE PROD1-1I TO WS-PROD-1(1)
            MOVE PROD1-2I TO WS-PROD-2(1)
        END-IF
        
        IF PROD2-1L = 0 AND PROD2-2L = 0
            MOVE LOW-VALUES TO WS-PROD-1(2)
            MOVE LOW-VALUES TO WS-PROD-2(2)
        ELSE
            MOVE PROD2-1I TO WS-PROD-1(2)
            MOVE PROD2-2I TO WS-PROD-2(2)
        END-IF
        
        IF PROD3-1L = 0 AND PROD3-2L = 0
            MOVE LOW-VALUES TO WS-PROD-1(3)
            MOVE LOW-VALUES TO WS-PROD-2(3)
        ELSE
            MOVE PROD3-1I TO WS-PROD-1(3)
            MOVE PROD3-2I TO WS-PROD-2(3)
        END-IF
        
        IF PROD4-1L = 0 AND PROD4-2L = 0
            MOVE LOW-VALUES TO WS-PROD-1(4)
            MOVE LOW-VALUES TO WS-PROD-2(4)
        ELSE
            MOVE PROD4-1I TO WS-PROD-1(4)
            MOVE PROD4-2I TO WS-PROD-2(4)
        END-IF
        
        IF PROD5-1L = 0 AND PROD5-2L = 0
            MOVE LOW-VALUES TO WS-PROD-1(5)
            MOVE LOW-VALUES TO WS-PROD-2(5)
        ELSE
            MOVE PROD5-1I TO WS-PROD-1(5)
            MOVE PROD5-2I TO WS-PROD-2(5)
        END-IF
        
        MOVE PROD1-1I TO WS-PRODUCT-CODE-1(1)
        MOVE PROD1-2I TO WS-PRODUCT-CODE-2(1)
        MOVE PROD2-1I TO WS-PRODUCT-CODE-1(2)
        MOVE PROD2-2I TO WS-PRODUCT-CODE-2(2)
        MOVE PROD3-1I TO WS-PRODUCT-CODE-1(3)
        MOVE PROD3-2I TO WS-PRODUCT-CODE-2(3)
        MOVE PROD4-1I TO WS-PRODUCT-CODE-1(4)
        MOVE PROD4-2I TO WS-PRODUCT-CODE-2(4)
        MOVE PROD5-1I TO WS-PRODUCT-CODE-1(5)
        MOVE PROD5-2I TO WS-PRODUCT-CODE-2(5)
        
        PERFORM VARYING WS-COUNTER FROM 1 BY 1 
            UNTIL WS-COUNTER > 4
                SET PART-INDEX UP BY 1
                
                PERFORM VARYING PART-INDEX-2 FROM 2 BY 1
                    UNTIL PART-INDEX-2 > 5
                    
            EVALUATE TRUE
            WHEN WS-PART-TABLE(PART-INDEX) = LOW-VALUES
            CONTINUE
            WHEN WS-PART-TABLE(PART-INDEX) = WS-PART-TABLE(PART-INDEX-2)
                    
                    IF PART-INDEX-2 = 2
                        MOVE DFHUNIMD TO PROD2-1A
                        MOVE DFHUNIMD TO PROD2-2A
                        MOVE DFHRED TO PROD1-1A
                        MOVE DFHRED TO PROD2-2A
                        
                        MOVE 'DUPLICATE ERROR - PRODUCT 2' TO MSGO
                        GO TO 910-SEND-MAP-ERR
                    
                    IF PART-INDEX-2 = 3
                        MOVE DFHUNIMD TO PROD3-1A
                        MOVE DFHUNIMD TO PROD3-2A
                        MOVE DFHRED TO PROD3-1A
                        MOVE DFHRED TO PROD3-2A
                        
                        MOVE 'DUPLICATE ERROR - PRODUCT 3' TO MSGO
                        GO TO 910-SEND-MAP-ERR
                    
                    IF PART-INDEX-2 = 4
                        MOVE DFHUNIMD TO PROD4-1A
                        MOVE DFHUNIMD TO PROD4-2A
                        MOVE DFHRED TO PROD4-1A
                        MOVE DFHRED TO PROD4-2A
                        
                        MOVE 'DUPLICATE ERROR - PRODUCT 4' TO MSGO
                        GO TO 910-SEND-MAP-ERR
                    IF PART-INDEX-2 = 5
                        MOVE DFHUNIMD TO PROD5-1A
                        MOVE DFHUNIMD TO PROD5-2A
                        MOVE DFHRED TO PROD5-1A
                        MOVE DFHRED TO PROD5-2A
                        
                        MOVE 'DUPLICATE ERROR - PRODUCT 5' TO MSGO
                        GO TO 910-SEND-MAP-ERR                        
                    END-EVALUATE
                    
                SET PART-INDEX UP BY 1
                
                END-PERFORM
        END-PERFORM
        
            MOVE WS-PRODUCT-CODE(WS-COUNTER) TO WS-CODE
            
            EXEC CICS LINK
                PROGRAM('BOPRGPC')
                COMMAREA(WS-PART-EDIT)
                LENGTH(WS-PART-EDIT-LENGTH)
            END-EXEC
            IF WS-DESCRIPTION IS NUMERIC
                MOVE 'SQL ERROR' TO MSGO
                MOVE 'Y' TO WS-PC-ERROR
                SET WS-COUNTER TO 6
            ELSE IF WS-DESCRIPTION EQUALS 'PART NOT FOUND'
                MOVE WS-DESCRIPTION TO MSGO
                MOVE 'Y' TO WS-PC-ERROR
                IF WS-COUNTER EQUALS 1
                    MOVE DFHUNIMD TO PROD1-1A
                    MOVE DFHUNIMD TO PROD1-2A
                    SET WS-COUNTER TO 6
                ELSE IF WS-COUNTER EQUALS 2
                    MOVE DFHUNIMD TO PROD2-1A
                    MOVE DFHUNIMD TO PROD2-2A
                    SET WS-COUNTER TO 6
                ELSE IF WS-COUNTER EQUALS 3
                    MOVE DFHUNIMD TO PROD3-1A
                    MOVE DFHUNIMD TO PROD3-2A
                    SET WS-COUNTER TO 6
                ELSE IF WS-COUNTER EQUALS 4
                    MOVE DFHUNIMD TO PROD4-1A
                    MOVE DFHUNIMD TO PROD4-2A
                    SET WS-COUNTER TO 6
                ELSE IF WS-COUNTER EQUALS 5
                    MOVE DFHUNIMD TO PROD5-1A
                    MOVE DFHUNIMD TO PROD5-2A
                    SET WS-COUNTER TO 6
                END-IF
            END-IF              

        IF WS-PC-ERROR EQUALS 'Y' 
            MOVE LOW-VALUES TO MAP2O
            MOVE WS-DESCRIPTION TO MSGO
            GO TO 910-SEND-MAP-ERR
		END-IF				
				
                MOVE INVNUMI TO ORDFILE-INVOICE-NO
                EXEC CICS READ FILE('ORDFILE')
                    RIDFLD(ORDFILE-KEY)
                    LENGTH(ORDFILE-LENGTH)
                    INTO(ORDFILE-RECORD)
                    UPDATE
                END-EXEC
                
                MOVE PROD1-1I TO ORDFILE-P1A
				MOVE PROD1-2I TO ORDFILE-P1B
                MOVE PROD2-1I TO ORDFILE-P2A
				MOVE PROD2-2I TO ORDFILE-P2B
                MOVE PROD3-1I TO ORDFILE-P3A
				MOVE PROD3-2I TO ORDFILE-P3B
                MOVE PROD4-1I TO ORDFILE-P4A
				MOVE PROD4-2I TO ORDFILE-P4B
                MOVE PROD5-1I TO ORDFILE-P5A
				MOVE PROD5-2I TO ORDFILE-P5B	
				MOVE NAMEI TO ORDFILE-NAME
				MOVE ADDLN1I TO ORDFILE-ADDR-LINE1
				MOVE ADDLN2I TO ORDFILE-ADDR-LINE2
				MOVE ADDLN3I TO ORDFILE-ADDR-LINE3
				MOVE POSTAL1I TO ORDFILE-POSTAL-1
				MOVE POSTAL2I TO ORDFILE-POSTAL-2
				MOVE ARCODEI TO ORDFILE-AREA-CODE
				MOVE EXCHNOI TO ORDFILE-EXCHANGE
				MOVE PHONNUMI TO ORDFILE-PHONE-NUM

                EXEC CICS REWRITE FILE('ORDFILE')
                LENGTH(ORDFILE-LENGTH)
                FROM(ORDFILE-RECORD)
                END-EXEC
                
                MOVE 'FILE UPDATED.' TO MSGO
                PERFORM 700-PROTECT-FOR-INQUIRY
                
                EXEC CICS
                    SEND MAP('MAP2') MAPSET('BOMAP2') ERASE
                END-EXEC
                    
                EXEC CICS RETURN TRANSID ('BO04')
                        COMMAREA(WS-SAVEAREA)
                        LENGTH(WS-SAVE-LENGTH)
                END-EXEC
                   
                ELSE
                    PERFORM 700-PROTECT-FOR-INQUIRY
                    EXEC CICS
                        SEND MAP('MAP2') MAPSET('BOMAP2') ERASE
                    END-EXEC
                        
                    EXEC CICS RETURN TRANSID ('BO04')
                            COMMAREA(WS-SAVEAREA)
                            LENGTH(WS-SAVE-LENGTH)
                    END-EXEC
                END-IF.  
            
            700-PROTECT-FOR-INQUIRY.
                MOVE 'I N Q U I R Y' TO TITLEO.
                
                MOVE DFHBMPRF TO PROD1-1A.
                MOVE DFHBMPRF TO PROD1-2A.
                MOVE DFHBMPRF TO PROD2-1A.
                MOVE DFHBMPRF TO PROD2-2A.
                MOVE DFHBMPRF TO PROD3-1A.
                MOVE DFHBMPRF TO PROD3-2A.
                MOVE DFHBMPRF TO PROD4-1A.
                MOVE DFHBMPRF TO PROD4-2A.
                MOVE DFHBMPRF TO PROD5-1A.
                MOVE DFHBMPRF TO PROD5-2A.

                MOVE DFHBMPRF TO NAMEA.
                MOVE DFHBMPRF TO ADDLN1A.
                MOVE DFHBMPRF TO ADDLN2A.
                MOVE DFHBMPRF TO ADDLN3A.
                MOVE DFHBMPRF TO POSTAL1A.
                MOVE DFHBMPRF TO POSTAL2A.
                
                MOVE DFHBMPRF TO ARCODEA.
                MOVE DFHBMPRF TO EXCHNOA.
                MOVE DFHBMPRF TO PHONNUMA.
                
                MOVE 'INQ' TO WS-UPD-SW.
                
            800-UNPROTECT-FOR-UPDATE.
                MOVE DFHBMPRF TO INVNUMA.
                MOVE DFHBMFSE TO PROD1-1A.
                MOVE DFHBMFSE TO PROD1-2A.
                MOVE DFHBMFSE TO PROD2-1A.
                MOVE DFHBMFSE TO PROD2-2A.
                MOVE DFHBMFSE TO PROD3-1A.
                MOVE DFHBMFSE TO PROD3-2A.
                MOVE DFHBMFSE TO PROD4-1A.
                MOVE DFHBMFSE TO PROD4-2A.
                MOVE DFHBMFSE TO PROD5-1A.
                MOVE DFHBMFSE TO PROD5-2A.

                MOVE DFHBMFSE TO NAMEA.
                MOVE DFHBMFSE TO ADDLN1A.
                MOVE DFHBMFSE TO ADDLN2A.
                MOVE DFHBMFSE TO ADDLN3A.
                MOVE DFHBMFSE TO POSTAL1A.
                MOVE DFHBMFSE TO POSTAL2A.
                
                MOVE DFHBMFSE TO ARCODEA.
                MOVE DFHBMFSE TO EXCHNOA.
                MOVE DFHBMFSE TO PHONNUMA.
                
                MOVE 'UPD' TO WS-UPD-SW.
                MOVE '  U P D A T E' TO TITLEO.
			
            800-DELETE.
                IF WS-UPD-SW EQUALS 'INQ'
                    MOVE 'PLEASE ENTER AN INVOICE NUMBER TO DELETE' 
                        TO MSGO
                    GO TO 910-SEND-MAP-ERR
                ELSE IF WS-UPD-SW EQUALS 'UPD'
                    IF NAMEI(1:6) <> 'DELETE' AND NAMEI(1:6) <> 'delete'
                        MOVE 'PLEASE ENTER DELETE INTO THE NAME FIELD' 
                            TO MSGO
                        GO TO 910-SEND-MAP-ERR
                    ELSE
                        MOVE INVNUMI TO ORDFILE-INVOICE-NO
                        EXEC CICS DELETE FILE('ORDFILE')
                            RIDFLD(ORDFILE-KEY)
                        END-EXEC
                        MOVE LOW-VALUES TO MAP2O
                        MOVE 'FILE DELETED' TO MSGO
                    END-IF
                    
                    EXEC CICS
                        SEND MAP('MAP2') MAPSET('BOMAP2') ERASE
                    END-EXEC
                        
                    EXEC CICS RETURN TRANSID ('BO04')
                            COMMAREA(WS-SAVEAREA)
                            LENGTH(WS-SAVE-LENGTH)
                    END-EXEC
                
                ELSE
                    MOVE 'NOTHING' TO MSGO
                    GO TO 910-SEND-MAP-ERR
                END-IF.
            
			910-SEND-MAP-ERR.       
			EXEC CICS 
				SEND MAP('MAP2') MAPSET('BOMAP2') CURSOR(WS-CURSOR-POS) 
			END-EXEC.
		
			EXEC CICS 
				RETURN TRANSID('BO04') 
                COMMAREA(LK-SAVE)
			END-EXEC.
            
            999-EXIT.
                EXEC CICS XCTL
                    PROGRAM('BOPRGM')
                    COMMAREA(WS-TRANSFER-FIELD)
                    LENGTH(WS-TRANSFER-LENGTH)
                END-EXEC.