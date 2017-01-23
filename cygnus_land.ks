SAS on.
WAIT 1.
STAGE.
WAIT 1.
STAGE.
WAIT 1.
STAGE.
WAIT 1.
set SASMODE to "RETROGRADE".
WAIT 30.

set vdest to GROUNDSPEED - 60.
WHEN GROUNDSPEED < vdest AND GROUNDSPEED > 100 THEN {
	PRINT "End deorbit burn.".
    set ship:control:mainthrottle to 0.
}

PRINT "Deorbit burn...".
set ship:control:mainthrottle to 0.1.

set panels to false.
SHIP:PARTSDUBBED("antenna")[0]:GETMODULE("ModuleRTAntenna"):doaction("deactivate", true).

set mybrakes to SHIP:PARTSDUBBED("brake").

PRINT "Extending brakes...".
for mybrake in mybrakes {
  mybrake:GETMODULE("ModuleAeroSurface"):doaction("extend", true).
}

WHEN ALT:RADAR < 50000 THEN {
  PRINT "Retracting brakes...".
  for mybrake in mybrakes {
    mybrake:GETMODULE("ModuleAeroSurface"):doaction("retract", true).
  }
}

WHEN ALT:RADAR < 15000 THEN {
  PRINT "Extending brakes...".
  for mybrake in mybrakes {
    mybrake:GETMODULE("ModuleAeroSurface"):doaction("extend", true).
  }
}

WHEN GROUNDSPEED < 5 AND VERTICALSPEED < 10 THEN {
  SHIP:PARTSDUBBED("antenna")[0]:GETMODULE("ModuleRTAntenna"):doaction("activate", true).
}

WHEN ALT:RADAR < 100 THEN {
  PRINT "Final burn...".
  LOCK THROTTLE to 0.03.
}

wait until STATUS = "LANDED".

set ship:control:mainthrottle to 0.
