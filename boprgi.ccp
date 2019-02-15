        IDENTIFICATION DIVISION.
        PROGRAM-ID.  BOPRGI.
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
        
        01 WS-TRANSFER-FIELD    PIC X(3).
        01 WS-TRANSFER-LENGTH   PIC S9(4) COMP VALUE 3.
        
        LINKAGE SECTION.
            01 DFHCOMMAREA.
                05 LK-TRANSFER    PIC X(3).

        PROCEDURE DIVISION.
        
        000-START-LOGIC.
        
            EXEC CICS HANDLE AID 
                PF4 (999-EXIT) 
            END-EXEC.
        
* DECLARE PARAGRAPH TO BE USED FOR HANDLING SITUATIONS WHERE
* WE ATTEMPT TO RECIEVE A MAP THAT HAS NOT BEEN SENT
            EXEC CICS HANDLE CONDITION 
                MAPFAIL(100-FIRST-TIME) 
                NOTFND(400-RECORD-NOT-FOUND)
            END-EXEC.
            
            IF EIBCALEN = 3
                GO TO 100-FIRST-TIME
            END-IF.
            
            EXEC CICS 
                RECEIVE MAP('MAP2') MAPSET('BOMAP2') 
            END-EXEC.

            GO TO 200-MAIN-LOGIC.
            
        100-FIRST-TIME.
            MOVE LOW-VALUES TO MAP2O.
            
            GO TO 900-SEND-MAP.
            
* IF YOU DID NOT PUT AN INITIAL IN YOUR BMS AND WANT A STARTING VALUE IN MSG IT
* WOULD GO HERE
        200-MAIN-LOGIC.
        
*        PERFORM 500-UNPROTECT-MAP.
        
        MOVE INVNUMI TO ORDFILE-INVOICE-NO.
        
            IF INVNUML IS NOT EQUAL TO 7
                MOVE 'INVOICE NUMBER MUST BE 7 DIGITS' TO MSGO
                MOVE -1 TO INVNUML
                
                MOVE DFHUNIMD TO INVNUMA
                
                GO TO 900-SEND-MAP           
            END-IF.
            
            IF INVNUMI IS NOT NUMERIC
                MOVE 'INVOICE NUMBER MUST BE NUMERIC' TO MSGO
                
                MOVE -1 TO INVNUML
                MOVE DFHUNIMD TO INVNUMA
                
                GO TO 900-SEND-MAP              
            END-IF.
            
            MOVE 'RECORD FOUND!' TO MSGO.
           
            MOVE INVNUMI TO ORDFILE-INVOICE-NO. 

            EXEC CICS READ FILE('ORDFILE')
                INTO (ORDFILE-RECORD)
                LENGTH (ORDFILE-LENGTH)
                RIDFLD (ORDFILE-KEY)
            END-EXEC.            
            
            MOVE ORDFILE-P1A TO PROD1-1O.
            MOVE ORDFILE-P1B TO PROD1-2O.
            MOVE ORDFILE-P2A TO PROD2-1O.
            MOVE ORDFILE-P2B TO PROD2-2O.
            MOVE ORDFILE-P3A TO PROD3-1O.
            MOVE ORDFILE-P3B TO PROD3-2O.
            MOVE ORDFILE-P4A TO PROD4-1O.
            MOVE ORDFILE-P4B TO PROD4-2O.
            MOVE ORDFILE-P5A TO PROD5-1O.
            MOVE ORDFILE-P5B TO PROD5-2O.
            
            MOVE ORDFILE-NAME TO NAMEO.
            MOVE ORDFILE-ADDR-LINE1 TO ADDLN1O.
            MOVE ORDFILE-ADDR-LINE2 TO ADDLN2O.
            MOVE ORDFILE-ADDR-LINE3 TO ADDLN3O.
            MOVE ORDFILE-POSTAL-1 TO POSTAL1O.
            MOVE ORDFILE-POSTAL-2 TO POSTAL2O.
            
            MOVE ORDFILE-AREA-CODE TO ARCODEO.
            MOVE ORDFILE-EXCHANGE TO EXCHNOO.
            MOVE ORDFILE-PHONE-NUM TO PHONNUMO.
            
            EXEC CICS SEND MAP('MAP2') MAPSET('BOMAP2') END-EXEC.
            EXEC CICS RETURN TRANSID('BO02') END-EXEC.
            
        400-RECORD-NOT-FOUND.
            MOVE LOW-VALUES TO MAP2O.
            MOVE 'INVOICE NOT FOUND' TO MSGO.
            
            GO TO 900-SEND-MAP.
        
        900-SEND-MAP.
            EXEC CICS 
                SEND MAP('MAP2') MAPSET('BOMAP2') ERASE
            END-EXEC.

            EXEC CICS 
                RETURN TRANSID('BO02') 
            END-EXEC.

        999-EXIT.
            EXEC CICS XCTL
                PROGRAM('BOPRGM')
                COMMAREA(WS-TRANSFER-FIELD)
                LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.