SAS on.
set SASMODE to "RETROGRADE".

set panels to false.
SHIP:PARTSDUBBED("antenna")[0]:GETMODULE("ModuleRTAntenna"):doaction("deactivate", true).

set mybrakes to SHIP:PARTSDUBBED("brake").

WHEN ALT:RADAR < 50000 THEN {
  for mybrake in mybrakes {
    mybrake:GETMODULE("ModuleAeroSurface"):doaction("retract", true).
  }
}
WHEN ALT:RADAR < 15000 THEN {
  for mybrake in mybrakes {
    mybrake:GETMODULE("ModuleAeroSurface"):doaction("extend", true).
  }
}

WHEN ALT:RADAR < 30 THEN {
  set ship:control:mainthrottle to 0.03.
}


wait until false.