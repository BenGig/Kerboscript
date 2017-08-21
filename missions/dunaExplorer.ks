runoncepath("lib_list_dialog").
runoncepath("lib_maneuvers").

//set maneuvers to list("Launch","KomSat release orbit","Sun expose","Exit").
set komSats TO list("DunaKomSat1","DunaKomSat2","DunaKomSat3","DunaKomSat4","IkeKomSat1","IkeKomSat2","IkeKomSat3","Exit").

function gatherParts {
  parameter rootPart.
  parameter satParts.

  if rootPart:name = "commDish" or rootPart:name = "longAntenna" or rootPart:name = "batteryBank" or rootPart:name = "toroidalFuelTank" or rootPart:name = "mediumDishAntenna" or rootPart:name = "solarPanels4" {
    satParts:add(rootPart).
  }
  for item in rootPart:children() {
    gatherParts(item, satParts).
  }
}

function do_komSat_undock {
  parameter komSat.
  clearscreen.
  print "Launch sequence for " + komSats[komSat] + " initiated.".
  
  set satParts to list().
  set satRoot to ship:partstagged(komSats[komSat])[0].  // separator
  if not satRoot:istype("PART") {
    print "Satellite already launched.".
    komSats:remove(komSat).
    wait 5.
    return.
  }
  
  print "Retracting core panels".
  for panel in ship:partsdubbed("corePanel") {
    panel:getmodule("ModuleDeployableSolarPanel"):doaction("retract solar panel", true).
  }
  wait 10.
  
  print "Preparing launch".
  set separator to satRoot.
  gatherParts(satRoot, satParts).

  for item in satParts {
    if item:name = "commDish" {
      set dish to item.
    }
	if item:name = "mediumDishAntenna" {
	  set miniDish to item.
	}
    if item:name = "longAntenna" {
      set omni to item.
    }
    if item:name = "batteryBank" {
      set battery to item.
    }
    if item:name = "toroidalFuelTank" {
      set tank to item.
    }
  }  

  if battery:resources[0]:amount < 0.9 * battery:resources[0]:capacity {
    print "Battery not charged, aborting".
    wait 5.
    return.
  }
  if tank:resources[0]:amount < tank:resources[0]:capacity or tank:resources[1]:amount < tank:resources[1]:capacity {
    print "Fuel tanks not full, aborting".
    wait 5.
    return.
  }
  print "Ressources ok, activating systems".
//  for item in satParts {
//    if item:name = "solarPanels4" and item:tag <> "delayed" {
//	  item:getmodule("ModuleDeployableSolarPanel"):doaction("extend solar panel", true).
//	}
//  }
  omni:getmodule("ModuleRTAntenna"):doaction("activate", true).
  miniDish:getmodule("ModuleRTAntenna"):doaction("activate", true).
  dish:getmodule("ModuleRTAntenna"):doaction("activate", true).
  dish:getmodule("ModuleRTAntenna"):setfield("target", "Kerbin").
  wait 10.
  print "Ready for separation.".
//  separator:getmodule("ModuleDecouple"):doaction("decouple", true).
  
  print "Sending message to " + komSats[komSat] + "CPU".
  set proc to processor(komSats[komSat] + "CPU").
  set msg to komSats[komSat].
  print "Message: " + komSats[komSat].
  if proc:connection:sendmessage(msg) {
    print "Launch initiated.".
  }
  
  wait 60.
  
  for panel in ship:partsdubbed("corePanel") {
    panel:getmodule("ModuleDeployableSolarPanel"):doaction("extend solar panel", true).
  }
  print "Activating mothership dish " + komSats[komSat] + "Kom".
  set dish to ship:partstagged(komSats[komSat] + "Kom")[0].
  dish:getmodule("ModuleRTAntenna"):doaction("activate", true).
  dish:getmodule("ModuleRTAntenna"):setfield("target", komSats[komSat]).

  komSats:remove(komSat).
}

function launch_scisat {
  parameter scisat.
  
  clearscreen.
  print "Retracting core panels".
  for panel in ship:partsdubbed("corePanel") {
    panel:getmodule("ModuleDeployableSolarPanel"):doaction("retract solar panel", true).
  }
  wait 10.
  set proc to processor(scisat + "CPU").
  set msg to scisat.
  if proc:connection:sendmessage(msg) {
    print "SciSat launch initiated.".
  }
  wait 30.
  set dish to ship:partstagged(scisat + "Kom")[0].
  dish:getmodule("ModuleRTAntenna"):doaction("activate", true).
  dish:getmodule("ModuleRTAntenna"):setfield("target", scisat).
  for panel in ship:partsdubbed("corePanel") {
    panel:getmodule("ModuleDeployableSolarPanel"):doaction("extend solar panel", true).
  }
}

set action to "".
set actions TO list("KomSat launch","KomSat Duna release orbit","KomSat Ike release orbit","SciSat1","SciSat2","Exit").
  
until 0 {
  set action to open_list_dialog("Select action", actions).

  if actions[action] = "Exit" { break. }
  if actions[action] = "KomSat launch" {
    until 0 {
      set komSat to open_list_dialog("Select satellite", komSats).
      if komSats[komSat] = "Exit" {
        break.
      }
      do_komSat_undock(komSat).
	  }
  }
  if actions[action] = "KomSat Duna release orbit" { ejection_orbit(4). terminal:input:getchar(). }
  if actions[action] = "KomSat Ike release orbit" { ejection_orbit(3). terminal:input:getchar(). }
  if actions[action] = "SciSat1" or actions[action] = "SciSat2" { launch_scisat(actions[action]). }
}