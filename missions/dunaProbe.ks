runoncepath("lib_list_dialog").
runoncepath("lib_ui.ks").

clearscreen.
print "Waiting for launch message...".

wait until not core:messages:empty.
print "Launch initiated.".
set msg to core:messages:pop.
set myname to msg:content.

set mothershipname to msg:sender:name.
set mothership to vessel(mothershipname).

// separate from mothership
set separator to ship:partstagged(myname)[0].
separator:getmodule("ModuleDecouple"):doaction("decouple", true).

set vessel(mothershipname+" Probe"):shipname to myname.

uiWarning("Warning", "Switch vessel NOW").
wait 10.
// move away
sas off.
ship:partsnamed("liquidEngineMini")[0]:getmodule("ModuleEnginesFX"):doaction("activate engine", true).
wait 1.
sas on.
lock throttle to 0.1.
wait 3.
unlock throttle.
sas on.

print "Waiting for safe distance...".
wait until mothership:distance > 20.

panels on.
set omni to ship:partsnamed("longAntenna")[0].
omni:getmodule("ModuleRTAntenna"):doaction("activate", true).
set dish to ship:partsnamed("mediumDishAntenna")[0].
dish:getmodule("ModuleRTAntenna"):doaction("activate", true).
dish:getmodule("ModuleRTAntenna"):setfield("target", mothershipname).

uiWarning("Warning", "Switch vessel NOW").
