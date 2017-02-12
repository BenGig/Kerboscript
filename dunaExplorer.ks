runoncepath("0:/lib_list_dialog").

set komSats TO list("KomSat1","KomSat2","KomSat3","KomSat4","KomSat5","KomSat6","KomSat7","Exit").

function do_komSat_undock {
  parameter komSat.
  clearscreen.
  set satParts to ship:partstagged(komSat).
  for item in satParts {
    if item:name = "stackSeparatorMini" {
	  set separator to item.
	} 
	if item:name = "commDish" {
	  set dish to item.
	}
	if item:name = "longAntenna" {
	  set omni to item.
	}
	if item:name = "batteryBank" {
	  set battery to item.
	}
	
	print item:allmodules.
  }
  wait 10.
}

function do_komSat {
  parameter komSat.
  
  set komSatAction to "".
  set komSatActions TO list ("Undock","Exit").
  until 0 {
    set komSatAction to open_list_dialog("Select action", komSatActions).
    if komSatActions[komSatAction] = "Exit" { break. }
	if komSatActions[komSatAction] = "Undock" {
	  do_komSat_undock(komSat).
	}
  }
}

//for elem in eList {
//  elem_names:add(elem:NAME).
//}

set action to "".
until 0 {
  set actions TO list("KomSat","Exit").
  set action to open_list_dialog("Select action", actions).

  if actions[action] = "Exit" { break. }

  if actions[action] = "KomSat" {
    set komSat to open_list_dialog("Select satellite", komSats).
    until 0 {
	  if komSat = "Exit" {
	    break.
	  }
	  do_komSat(komSats[komSat]).
	}
  }
}