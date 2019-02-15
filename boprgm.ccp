        IDENTIFICATION DIVISION.
        PROGRAM-ID.  BOPRGM.
        AUTHOR. OAKE.

        ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
        SOURCE-COMPUTER. RS-6000.
        OBJECT-COMPUTER. RS-6000.

        DATA DIVISION.
        WORKING-STORAGE SECTION.

        COPY 'BOMAP1'.
        
        01 WS-TRANSFER-FIELD    PIC X(3).
        01 WS-TRANSFER-LENGTH   PIC S9(4) COMP VALUE 3.

        LINKAGE SECTION.
            01 DFHCOMMAREA.
                05 LK-TRANSFER    PIC X(3).        

        PROCEDURE DIVISION.
        000-START-LOGIC.
* DECLARE PARAGRAPH TO BE USED FOR HANDLING SITUATIONS WHERE
* WE ATTEMPT TO RECIEVE A MAP THAT HAS NOT BEEN SENT
            
            EXEC CICS HANDLE AID
                PF1(300-CHOICE-1)
                PF2(400-CHOICE-2)
                PF3(500-CHOICE-3)
                PF4(600-CHOICE-4)
            END-EXEC.
            
            EXEC CICS HANDLE CONDITION 
                MAPFAIL(100-FIRST-TIME) 
            END-EXEC.
            
            IF EIBCALEN = 3
                GO TO 100-FIRST-TIME
            END-IF.
            
            EXEC CICS RECEIVE 
                MAP('MAP1')
                MAPSET('BOMAP1') 
            END-EXEC.
            
            GO TO 200-MAIN-LOGIC.
            
        100-FIRST-TIME.
            MOVE LOW-VALUES TO MAP1O.
            
* IF YOU DID NOT PUT AN INITIAL IN YOUR BMS AND WANT A STARTING VALUE IN MSG IT
* WOULD GO HERE

        EXEC CICS SEND MAP('MAP1') MAPSET('BOMAP1') ERASE END-EXEC.

        EXEC CICS RETURN TRANSID('BO01') END-EXEC.

        200-MAIN-LOGIC.

            IF CHOICEI IS EQUAL TO '1'
                GO TO 300-CHOICE-1
            ELSE IF CHOICEI IS EQUAL TO '2'
                GO TO 400-CHOICE-2
            ELSE IF CHOICEI IS EQUAL TO '3'
                GO TO 500-CHOICE-3
            ELSE IF CHOICEI IS EQUAL TO '4'
                GO TO 600-CHOICE-4
            ELSE
                GO TO 999-SEND-ERROR-MSG
            END-IF.
            
        300-CHOICE-1.          
            EXEC CICS XCTL
                PROGRAM('BOPRGE')
                COMMAREA(WS-TRANSFER-FIELD)
                LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.

        400-CHOICE-2.
            EXEC CICS XCTL
                PROGRAM('BOPRGU')
                COMMAREA(WS-TRANSFER-FIELD)
                LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.

        500-CHOICE-3.
            EXEC CICS XCTL
                PROGRAM('BOPRGB')
                COMMAREA(WS-TRANSFER-FIELD)
                LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.
            
        600-CHOICE-4.
            MOVE LOW-VALUES TO MAP1O.
            MOVE 'YOU ENTERED 4 - PROGRAM ENDING' TO MSGO.
            EXEC CICS SEND MAP('MAP1') MAPSET('BOMAP1') END-EXEC.
            EXEC CICS RETURN END-EXEC.

        999-SEND-ERROR-MSG.
            MOVE LOW-VALUES TO MAP1O.
            MOVE 'PLEASE ENTER A VALUE BETWEEN 1 AND 4' TO MSGO.
            EXEC CICS SEND MAP('MAP1') MAPSET('BOMAP1') END-EXEC.
            EXEC CICS RETURN TRANSID('BO01') END-EXEC.    