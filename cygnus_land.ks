// Start program over island in center of crater

SET burnspeed TO 60.
set cygnus075 TO SHIP:PARTSTAGGED("cygnus-075").
//IF cygnus075:LENGTH > 0 
//  { SET burnspeed TO 60. }
//ELSE
//  { SET burnspeed TO 60. }

SAS on.
WAIT 2.
STAGE.
WAIT 2.
STAGE.
WAIT 2.
STAGE.
WAIT 2.
set SASMODE to "RETROGRADE".
WAIT 30.

set vdest to GROUNDSPEED - burnspeed.
WHEN GROUNDSPEED < vdest AND GROUNDSPEED > 100 THEN {
	PRINT "End deorbit burn.".
    set ship:control:mainthrottle to 0.
}

PRINT "Deorbit burn...".
set ship:control:mainthrottle to 0.1.

WAIT UNTIL ALTITUDE < 70000.

PRINT "Retracting panels and antenna...".
set panels to false.
SHIP:PARTSDUBBED("antenna")[0]:GETMODULE("ModuleRTAntenna"):doaction("deactivate", true).

set mybrakes to SHIP:PARTSDUBBED("brake").
PRINT "Extending brakes...".
for mybrake in mybrakes {
  mybrake:GETMODULE("ModuleAeroSurface"):doaction("extend", true).
}

WAIT UNTIL ALTITUDE < 50000.
PRINT "Retracting brakes...".
for mybrake in mybrakes {
  mybrake:GETMODULE("ModuleAeroSurface"):doaction("retract", true).
}

WAIT UNTIL ALTITUDE < 16000.
PRINT "Extending brakes...".
for mybrake in mybrakes {
  mybrake:GETMODULE("ModuleAeroSurface"):doaction("extend", true).
}

WAIT UNTIL GROUNDSPEED < 5 AND VERTICALSPEED < 10.
PRINT "Extending antenna...".
SHIP:PARTSDUBBED("antenna")[0]:GETMODULE("ModuleRTAntenna"):doaction("activate", true).

WAIT UNTIL ALT:RADAR < 50.
PRINT "Final burn...".
// LOCK THROTTLE to 0.04.
set ship:control:mainthrottle to 0.04.

wait until STATUS <> "FLYING".

set ship:control:mainthrottle to 0.
