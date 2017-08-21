runoncepath("lib_maneuvers.ks").

clearscreen.
if shipname:startswith("Duna Explorer") {
  runoncepath("lib_ui.ks").

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
  lock throttle to 0.02.
  wait 3.
  unlock throttle.
  sas on.

  print "Waiting for safe distance...".
  wait until mothership:distance > 8.

  panels on.
  set omni to ship:partsnamed("longAntenna")[0].
  omni:getmodule("ModuleRTAntenna"):doaction("activate", true).
  set dish to ship:partsnamed("mediumDishAntenna")[0].
  dish:getmodule("ModuleRTAntenna"):doaction("activate", true).
  dish:getmodule("ModuleRTAntenna"):setfield("target", mothershipname).
  sun_expose().

  uiWarning("Warning", "Switch vessel NOW").
  
} else {
  runoncepath("lib_list_dialog").
  
  set action to "".
  set actions TO list("Sun orient","SCAN multispectral info","SCAN alti info","SCAN radar","Imaging platform info","Exit").
  
  until 0 {
    set action to open_list_dialog("Select action", actions).

    if actions[action] = "Exit" { break. }
    if actions[action] = "Sun orient" { sun_expose(). }
	if actions[action] = "SCAN multispectral info" { print "250 km". wait 5. }
	if actions[action] = "SCAN alti info" { print "750 km". wait 5. }
	if actions[action] = "SCAN radar" { print "<500 km". wait 5. }
	if actions[action] = "Imaging platform info" { print "250 km". wait 5. }
  }
}

run dunaProbe.