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
  set separator to satRoot.
  gatherParts(satRoot, satParts).

  for item in satParts {
    if item:name = "commDish" {
      set dish to item.
      print item:getmodule("ModuleRTAntenna"):allfields.
      wait 5. 
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
}

function do_komSat {
  parameter komSat.
  
  set komSatAction to "".
  set komSatActions TO list ("Undock","Exit").
  until 0 {
    set komSatAction to open_list_dialog("Select action", komSatActions).
    if komSatActions[komSatAction] = "Exit" { return. }
    if komSatActions[komSatAction] = "Undock" {
      do_komSat_undock(komSat).
    }
  }
}

//for elem in eList {
//  elem_names:add(elem:NAME).
//}

set action to "".
set actions TO list("KomSat","Maneuver","Exit").
  
until 0 {
  set action to open_list_dialog("Select action", actions).

  if actions[action] = "Exit" { break. }
  if actions[action] = "KomSat" {
    until 0 {
      set komSat to open_list_dialog("Select satellite", komSats).
      if komSats[komSat] = "Exit" {
        break.
      }
      do_komSat(komSat).
	  }
  }
  if actions[action] = "Maneuver" {
    until 0 {
      set maneuver to open_list_dialog("Select action", maneuvers).
      if maneuvers[maneuver] = "Exit" { break. }
      if maneuvers[maneuver] = "Launch" {
        runpath("0:/lib_launch_asc", 100000).
        stage.
        ship:partsdubbed("coreAntenna")[0]:getmodule("ModuleRTAntenna"):doaction("activate", true).
        ship:partsdubbed("coreAntenna")[0]:getmodule("ModuleRTAntenna"):setfield("target", "Kerbin").
        ship:partsdubbed("coreAntenna")[1]:getmodule("ModuleRTAntenna"):doaction("activate", true).
        ship:partsdubbed("coreAntenna")[1]:getmodule("ModuleRTAntenna"):setfield("target", "Kerbin").
      }
      if maneuvers[maneuver] = "KomSat release orbit" { ejection_orbit(4). }
    }
  }
}