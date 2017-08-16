// Fuel storage management

// Fuel transfer standard jobs
//
// From fuel shuttle to storage
// from storage to some consumer ship

if not exists("1:/lib_list_dialog.ks") {
  copypath("0:/lib/lib_list_dialog.ks", "1:").
}
if not exists("1:/lib_menu.ks") {
  copypath("0:/lib/lib_menu.ks", "1:").
}
if not exists("1:/lib_gui_box.ks") {
  copypath("0:/lib/lib_gui_box.ks", "1:").
}
if not exists("1:/spec_char.ksm") {
  copypath("0:/lib/spec_char.ksm", "1:").
}

function fuel_transfer {
  parameter from_tanks, to_tanks, limit is 0.

  set job_lf_tick to transferall("liquidfuel", from_tanks, to_tanks).
  set job_lf_tick:active to true.
  set job_lf_tick to transferall("oxidizer", from_tanks, to_tanks).
  set job_lf_tick:active to true.
  
  set job_mp_tick to transferall("monopropellant", from_tanks, to_tanks).
  set job_mp_tick:active to true. 

  return.
  
  wait 10.
  
  if limit > 0 {
    set job_lf_tock to transfer("liquidfuel", to_tanks, from_tanks, limit).
    set job_lf_tock:active to true.
    set job_mp_tock to transfer("monopropellant", to_tanks, from_tanks, 50).
    set job_mp_tock:active to true.
  }
}

runoncepath("lib_list_dialog.ks").

  // List of storage tanks. Always the same.
  set storageTanks to SHIP:PARTSTAGGED("storageTank").
  set remainingFuel to 0.
  set modeList to list("Refuel UT","Restock","Load shuttle","General refueling").
  if body:name = "Kerbin" { modeList:remove(2). set shuttleName to "Shuttle". set remainingFuel to 400. }
  if body:name = "Mun" { set shuttleName to "Fueler". }

  list elements in eList.

  set dockedShips to list().
  set dockedShipNames to list().

  clearscreen.
  set choice to open_menu("Select mode", modeList).
  if choice = "Refuel UT" {
    for elem in eList {
      if elem:name:startswith("UT") {
        dockedShipNames:add(elem:name).
        dockedShips:add(elem).
      }
    }
    set choice to open_list_dialog("Select UT to refuel", dockedShipNames).
    set targetShip to dockedShips[choice].
	set receiverTanks to list().
    FOR item IN targetShip:PARTS {
      IF item:TAG = "receiverTank" {
        receiverTanks:ADD(item).
      } 
    }
    fuel_transfer(storageTanks, receiverTanks, 0).
  }
  if choice = "Restock" {
    for elem in eList {
      if elem:name:contains(shuttleName) {    
        dockedShips:add(elem).
        dockedShipNames:add(elem:name).
      }
    }
    set choice to open_list_dialog("Select ship to restock from", dockedShipNames).
	clearscreen.
    set refuelerShip to dockedShips[choice].
    set shuttleTanks to list().
    for item in refuelerShip:parts {
      if item:tag = "shuttleTank" {
        shuttleTanks:add(item).
      }
    }
    print "Initiating fuel transfer.".
	
    fuel_transfer(shuttleTanks, storageTanks, 0).
	if remainingFuel > 0 {
	  fuel_transfer(storageTanks, shuttleTanks, remainingFuel).
	}
  }
  if choice = "Load shuttle" {
    for elem in eList {
      // are we at mine on Mun?
      if ship:status = "LANDED" {
        if elem:name:contains("Fueler") {          
          dockedShips:add(elem).
		  dockedShipNames:add(elem:name).
        }
      } else {
        if elem:name:startswith("Fuel Shuttle") {    
          dockedShips:add(elem).
          dockedShipNames:add(elem:name).
        }
      }
    }
    set choice to open_list_dialog("Select oiler to refuel", dockedShipNames).
    set shuttleShip to dockedShips[choice].
    set shuttleTanks to list().
    for item in shuttleShip:parts {
      if item:tag = "shuttleTank" {
        shuttleTanks:add(item).
      }
      if item:tag = "privateTank" {
        shuttleTanks:add(item).
      }
      if item:tag = "receiverTank" {
        shuttleTanks:add(item).
      }
    }
    fuel_transfer(storageTanks, shuttleTanks, 0).
  }

