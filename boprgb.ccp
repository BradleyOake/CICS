        IDENTIFICATION DIVISION.
        PROGRAM-ID.  BOPRGB.
        AUTHOR. OAKE.

        ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
        SOURCE-COMPUTER. RS-6000.
        OBJECT-COMPUTER. RS-6000.

        DATA DIVISION.
        WORKING-STORAGE SECTION.

        COPY 'BOMAP3'.
        COPY 'DFHBMSCA'.
        COPY 'ORDFILE-LAYOUT'.

        01 RECORD-LINE.
           05 FILLER           PIC X(10)    VALUE SPACES.
           05 RL-LINE          PIC 99.
           05 FILLER           PIC X(4)     VALUE SPACES.
           05 RL-NUM           PIC X(7).
		   05 FILLER           PIC X(4)     VALUE SPACES.
           05 RL-NAME          PIC X(20).
           05 FILLER           PIC X        VALUE '('.
           05 RL-AREA          PIC XXX.
           05 FILLER           PIC XX       VALUE ') '.
           05 RL-EXCH          PIC XXX.
           05 FILLER           PIC X        VALUE '-'.
           05 RL-PHONE         PIC XXXX.
           05 FILLER           PIC X(18)    VALUE SPACES.

        01 LINE-NO              PIC 99 VALUE ZERO.
        01 WS-TRANSFER-FIELD    PIC X(7).
        01 WS-TRANSFER-LENGTH   PIC S9(4) COMP VALUE 7.

        01 TS-RECORD.
          05 TS-PREFIXES        PIC X(3) OCCURS 10 TIMES.

        01 TS-RECORD-LENGTH     PIC S9(4) COMP VALUE 30.

        01 TS-NAME.
           05 TS-TERMID                      PIC XXXX.
           05 TS-ID                          PIC XXXX.

* LINKAGE SECTION.
*     01 DFHCOMMAREA.
*         05 LK-TRANSFER    PIC X(3).

        PROCEDURE DIVISION.

		000-START-LOGIC.
            EXEC CICS HANDLE AID
                PF4 (999-EXIT)
                PF7 (250-HOTKEY-BROWSE-BACK)
                PF8 (240-HOTKEY-BROWSE-FORWARD)
            END-EXEC.

            MOVE EIBTRMID TO TS-TERMID.

            EXEC CICS IGNORE CONDITION DUPKEY END-EXEC.

            EXEC CICS IGNORE CONDITION NOTFND END-EXEC.

            EXEC CICS HANDLE CONDITION
                MAPFAIL(100-FIRST-TIME)
                ENDFILE(800-ENDFILE)
            END-EXEC.

* IF EIBCALEN = 3
*     GO TO 100-FIRST-TIME
* END-IF.

            EXEC CICS
                RECEIVE MAP('MAP3') MAPSET('BOMAP3')
            END-EXEC.

            GO TO 200-MAIN-LOGIC.

        100-FIRST-TIME.
            EXEC CICS
              IGNORE CONDITION QIDERR
            END-EXEC.

            EXEC CICS
              DELETEQ QUEUE(TS-NAME)
            END-EXEC.

            MOVE LOW-VALUES TO MAP3O.

            GO TO 900-SEND-MAP.

        200-MAIN-LOGIC.
            IF XFERI IS NUMERIC
                IF XFERL EQUALS 1
                  CONTINUE
                ELSE IF XFERL EQUALS 2
                  CONTINUE
                IF XFERI IS NOT NUMERIC
                    MOVE 'TRANSFER FIELD MUST BE NUMERIC'
                    GO TO 910-SEND-MAP-ERR
                END-IF
            END-IF

                MOVE XFERI TO LINE-NO
                MOVE LINEI(LINE-NO) TO RECORD-LINE
                MOVE RL-NUM TO WS-TRANSFER-FIELD

                EXEC CICS XCTL
                    PROGRAM('BOPRGU')
                    COMMAREA(WS-TRANSFER-FIELD)
                    LENGTH(WS-TRANSFER-LENGTH)
                END-EXEC
            ELSE IF SEARCHA EQUALS DFHBMPRO
                MOVE 'HELLO' TO MSGO
                GO TO 910-SEND-MAP-ERR
            END-IF.

            IF SEARCHI IS ALPHABETIC
                AND SEARCHI IS NOT EQUAL TO SPACES
                AND SEARCHL > 3

                MOVE SEARCHI TO ORDFILE-NAME

                EXEC CICS STARTBR FILE('ORDNAME')
                    RIDFLD(ORDFILE-NAME)
                END-EXEC

                MOVE LOW-VALUES TO MAP3O

                PERFORM 220-BROWSE-FORWARD
                    VARYING LINE-NO FROM 1 BY 1
                    UNTIL LINE-NO > 10

                EXEC CICS ENDBR
                    FILE('ORDNAME')
                END-EXEC

                MOVE DFHBMPRO TO SEARCHA
                MOVE DFHBMFSE TO XFERA
                GO TO 900-SEND-MAP

            ELSE
                MOVE 'THAT IS NOT A VALID NAME - TRY AGAIN' TO MSGO

                GO TO 910-SEND-MAP-ERR
            END-IF.

            EXEC CICS
				SEND MAP('MAP3') MAPSET('BOMAP3')
			END-EXEC.

			EXEC CICS
				RETURN TRANSID('BO05')
			END-EXEC.

        220-BROWSE-FORWARD.

            EXEC CICS READNEXT FILE('ORDNAME')
                INTO(ORDFILE-RECORD)
                RIDFLD(ORDFILE-NAME)
                LENGTH(ORDFILE-LENGTH)
            END-EXEC.

            MOVE LINE-NO TO RL-LINE.
            MOVE ORDFILE-INVOICE-NO TO RL-NUM.
            MOVE ORDFILE-NAME TO RL-NAME.
            MOVE ORDFILE-AREA-CODE TO RL-AREA.
            MOVE ORDFILE-EXCHANGE TO RL-EXCH.
            MOVE ORDFILE-PHONE-NUM TO RL-PHONE.

            MOVE RECORD-LINE TO LINEO(LINE-NO).

        230-BROWSE-BACK.

            EXEC CICS READPREV FILE('ORDNAME')
                INTO(ORDFILE-RECORD)
                RIDFLD(ORDFILE-NAME)
                LENGTH(ORDFILE-LENGTH)
            END-EXEC.

            MOVE LINE-NO TO RL-LINE.
            MOVE ORDFILE-INVOICE-NO TO RL-NUM.
            MOVE ORDFILE-NAME TO RL-NAME.
            MOVE ORDFILE-AREA-CODE TO RL-AREA.
            MOVE ORDFILE-EXCHANGE TO RL-EXCH.
            MOVE ORDFILE-PHONE-NUM TO RL-PHONE.

            MOVE RECORD-LINE TO LINEO(LINE-NO).

        240-HOTKEY-BROWSE-FORWARD.

            EXEC CICS
                HANDLE CONDITION ENDFILE(800-ENDFILE)
            END-EXEC.

            MOVE LINEI(10) TO RECORD-LINE.
            MOVE RL-NAME TO ORDFILE-NAME.

            EXEC CICS STARTBR FILE('ORDNAME')
                RIDFLD(ORDFILE-NAME)
            END-EXEC.

            PERFORM 220-BROWSE-FORWARD
                VARYING LINE-NO FROM 1 BY 1
                UNTIL LINE-NO > 10.

            EXEC CICS ENDBR
                FILE('ORDNAME')
            END-EXEC.

            GO TO 900-SEND-MAP.

        250-HOTKEY-BROWSE-BACK.

            EXEC CICS
                HANDLE CONDITION ENDFILE(800-ENDFILE)
            END-EXEC.

            MOVE LINEI(10) TO RECORD-LINE.
            MOVE RL-NAME TO ORDFILE-NAME.

            EXEC CICS STARTBR FILE('ORDNAME')
                RIDFLD(ORDFILE-NAME)
            END-EXEC.

            PERFORM 230-BROWSE-BACK
                VARYING LINE-NO FROM 10 BY -1
                UNTIL LINE-NO < 1.

            EXEC CICS ENDBR
                FILE('ORDNAME')
            END-EXEC.

            GO TO 900-SEND-MAP.

        800-ENDFILE.
            MOVE 'AYY LMAO' TO SEARCHO.

        900-SEND-MAP.

            EXEC CICS
                SEND MAP('MAP3') MAPSET('BOMAP3')
            END-EXEC.

            EXEC CICS
                RETURN TRANSID('BO05')
            END-EXEC.

        910-SEND-MAP-ERR.
            EXEC CICS
                SEND MAP('MAP3') MAPSET('BOMAP3') CURSOR
            END-EXEC.

            EXEC CICS
                RETURN TRANSID('BO05')
            END-EXEC.

        999-EXIT.
            EXEC CICS RETURN END-EXEC.
