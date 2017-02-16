runoncepath("lib_list_dialog").
runoncepath("lib_komsat").

set maneuvers to list("Launch","KomSat release orbit","Exit").
set komSats TO list("KomSat1","KomSat2","KomSat3","KomSat4","KomSat5","KomSat6","KomSat7","Exit").

function gatherParts {
  parameter rootPart.
  parameter satParts.

  if rootPart:name = "commDish" or rootPart:name = "longAntenna" or rootPart:name = "batteryBank" or rootPart:name = "toroidalFuelTank" {
    satParts:add(rootPart).
  }
  for item in rootPart:children() {
    gatherParts(item, satParts).
  }
}

function do_komSat_undock {
  parameter komSat.
  clearscreen.
  set satParts to list().
  set satRoot to ship:partstagged(komSats[komSat])[0].  // separator
  if not satRoot:istype("PART") {
    print "Satellite already launched.".
    wait 5.
    return.
  }
  
  for panel in ship:partsdubbed("corePanel") {
    panel:getmodule("ModuleDeployableSolarPanel"):doaction("retract solar panel", true).
  }
  set separator to satRoot.
  gatherParts(satRoot, satParts).

  for item in satParts {
    if item:name = "commDish" {
      set dish to item.
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
  omni:getmodule("ModuleRTAntenna"):doaction("activate", true).
  dish:getmodule("ModuleRTAntenna"):doaction("activate", true).
  dish:getmodule("ModuleRTAntenna"):setfield("target", "Kerbin").
  print "Ready for separation.".
  separator:getmodule("ModuleDecouple"):doaction("decouple", true).
  komSats:remove(komSat).
  wait 30.
  for panel in ship:partsdubbed("corePanel") {
    panel:getmodule("ModuleDeployableSolarPanel"):doaction("extend solar panel", true).
  }
}

function launch_scisat {
  parameter scisat.
  
  clearscreen.
  set proc to processor(scisat + "CPU").
  set msg to scisat+":"+ship:shipname.
  if proc:connection:sendmessage(msg) {
    print "SciSat launch initiated.".
  }
  wait 10.
  set dish to ship:partsnamed(scisat + "Kom").
  dish:getmodule("ModuleRTAntenna"):doaction("activate", true).
  dish:getmodule("ModuleRTAntenna"):setfield("target", scisat).
}

set action to "".
set actions TO list("KomSat launch","KomSat release orbit","SciSat1","SciSat2","Exit").
  
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
  if actions[action] = "KomSat release orbit" { ejection_orbit(4). }
  if actions[action] = "SciSat1" or actions[action] = "SciSat2" { launch_scisat(actions[action]). }
}