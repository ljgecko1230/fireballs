'Screen
screenx = 800
screeny = 400
SCREEN _NEWIMAGE(screenx, screeny, 32)

'Randomize random numbers
RANDOMIZE TIMER

'Start
start:

'Score Variable
score = 0

'Set Player X to screen X divided by 2
px = screenx / 2
CLS

'Title Screen
_PRINTSTRING (330, 50), "FIREBALLS V1.5"
_PRINTSTRING (330, 90), "  PRESS  ANY"
_PRINTSTRING (330, 110), "KEY         TO"
_PRINTSTRING (330, 130), "     BEGIN"
fireball 390, 250
loops:
IF INKEY$ <> "" THEN
    CLS
    GOTO level1load
END IF
GOTO loops

level1load:
'Get player movement method
INPUT "Would you like to use mouse (1) or AD keys (2) to control the player? ", key$
IF key$ = "2" THEN
    keyinput = 1
ELSEIF key$ = "1" THEN
    keyinput = 0
ELSE
    CLS
    PRINT "Please select a valid option (1/2)"
    GOTO level1load
END IF

'Fireball Variable Arrays
DIM minspeed(4)
startminspeed = 0.5
FOR i = 0 TO LEN(minspeed)
    minspeed(i) = startminspeed
NEXT i
DIM y(4)
CLS
PRINT "Loading..."
y(0) = -1000
y(1) = -10
y(2) = -10
y(3) = 0
y(4) = -300

'Get save data (if any)
IF _FILEEXISTS("fireballs") THEN
    OPEN "fireballs" FOR INPUT AS #1
    INPUT #1, high
    CLOSE #1
ELSE
    high = 0
END IF
DIM x(4)
FOR i = 0 TO LEN(x)
    x(i) = (RND * screenx - 60) + 60
NEXT i
CLS
DIM s(4)
FOR i = 0 TO LEN(s)
    s(i) = (RND * 0.5) + minspeed(i)
NEXT i
PRINT "Loading complete"
PRINT "Press any key to begin"
loopss:
IF INKEY$ <> "" THEN
    CLS
    GOTO countdown
END IF
GOTO loopss

'Countdown before game starts
countdown:
_PRINTSTRING (screenx / 2, screeny / 2), "3"
SLEEP 1
CLS
_PRINTSTRING (screenx / 2, screeny / 2), "2"
SLEEP 1
CLS
_PRINTSTRING (screenx / 2, screeny / 2), "1"
SLEEP 1
CLS

level1:
'Score handling
PRINT "Local High Score:"; high
PRINT "Score:"; score
percent = _ROUND(score / high * 100)
PRINT "Percent of High Score:"; percent; "%"
amfs = (minspeed(0) + minspeed(1) + minspeed(2) + minspeed(3) + minspeed(4)) / 5
PRINT "Avg Min Fall Speed:"; amfs
IF score > high THEN
    high = score
    OPEN "fireballs" FOR OUTPUT AS #1
    WRITE #1, high
    CLOSE #1
END IF

'Fireball movement
FOR i = 0 TO LEN(y)
    y(i) = y(i) + s(i)
NEXT i
FOR i = 0 TO LEN(x)
    fireball x(i), y(i)
NEXT i

'Check if the player is dead
deadcheck y(0), y(1), y(2), y(3), y(4), x(0), x(1), x(2), x(3), x(4), px, score, high

'Reset fireball if offscreen
FOR i = 0 TO LEN(y)
    IF y(i) > screeny + 60 THEN
        score = score + 100
        y(i) = -60
        x(i) = (RND * screenx - 60) + 60
        s(i) = (RND * 0.5) + minspeed(i)
        minspeed(i) = minspeed(i) + (RND * 0.008) + 0.008
    END IF
NEXT i

'Player handling
IF keyinput = 0 THEN
    DO WHILE _MOUSEINPUT
        px = _MOUSEX
    LOOP
ELSEIF keyinput = 1 THEN
    keypress$ = UCASE$(INKEY$)
    SELECT CASE keypress$
        CASE "A": px = px - 10 'Left
        CASE "D": px = px + 10 'Right
    END SELECT
END IF
IF INKEY$ = CHR$(27) THEN
    GOTO pause
END IF
player px, 335
_DISPLAY
CLS
GOTO level1

pause:
_PRINTSTRING (screenx / 2, screeny / 2), "Game Paused"

'Draw Fireballs
SUB fireball (x, y)
CIRCLE (x, y), 25, _RGB(255, 200, 0)
LINE (x, y - 30)-(x, y - 80), _RGB(255, 200, 0)
LINE (x - 20, y - 30)-(x - 20, y - 70), _RGB(255, 200, 0)
LINE (x + 20, y - 30)-(x + 20, y - 70), _RGB(255, 200, 0)
PAINT (x, y), _RGB(255, 200, 0)
END SUB

'Draw Player
SUB player (x, y)
CIRCLE (x, y), 30, _RGB(160, 32, 240)
PAINT (x, y), _RGB(160, 32, 240)
END SUB

'Check for collisions
SUB deadcheck (y1, y2, y3, y4, y5, x1, x2, x3, x4, x5, px, s, h)
DIM y(4)
y(0) = y1
y(1) = y2
y(2) = y3
y(3) = y4
y(4) = y5
DIM x(4)
x(0) = x1
x(1) = x2
x(2) = x3
x(3) = x4
x(4) = x5
FOR i = 0 TO LEN(y)
    IF y(i) + 20 > 335 - 20 AND y(i) - 20 < 335 + 20 AND x(i) - 20 < px + 20 AND x(i) + 20 > px - 20 THEN
        dead s, h
    END IF
NEXT i
END SUB

'Death message
SUB dead (s, h)
CLS
PRINT "You were burnt to a flaming crisp!"
PRINT "You are dead!"
PRINT
percent = _ROUND(s / h * 100)
PRINT "SCORE:"; s
PRINT "HIGHSCORE:"; h
PRINT "PERCENT OF HIGHSCORE:"; percent; "%"
INPUT "", enter$
CLS
SYSTEM
END SUB
