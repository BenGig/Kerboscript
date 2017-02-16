runoncepath("lib_list_dialog").

clearscreen.
print "Waiting for launch message...".

wait until not core:messages:empty.
print "Launch initiated.".
set msg to core:messages:pop.
set myname to msg:split(":")[0].

set mothershipname to msg:split(":")[1].
set mothership to vessel(mothershipname).

// separate from mothership
set separator to ship:partstagged(myname)[0].
separator:getmodule("ModuleDecouple"):doaction("decouple", true).
set ship:shipname to myname.

// move away
set ship:control:fore to 0.2.
wait 3.
set ship:control:fore to 0.0.

print "Waiting for safe distance...".
wait until mothership:distance > 20.

panels on.
set omni to ship:partsnamed("longAntenna")[0].
omni:getmodule("ModuleRTAntenna"):doaction("activate", true).
set dish to ship:partsnamed("commDish")[0].
dish:getmodule("ModuleRTAntenna"):doaction("activate", true).
dish:getmodule("ModuleRTAntenna"):setfield("target", mothershipname).

