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

  set job_lf_tick = transferall("liquidfuel", from_tanks, to_tanks.
  set job_lf_tick:active = true.
  
  set job_mp_tick = transferall("monopropellant", from_tanks, to_tanks).
  set job_mp_tick:active = true. 

  wait 3.
  
  if limit > 0 {
    set job_lf_tock = transfer("liquidfuel", to_tanks, from_tanks, limit).
    set job_lf_tock:active = true.
  }
  set job_mp_tock = transfer("monopropellant", to_tanks, from_tanks, 30).
  set job_mp_tock:active = true.
}

runoncepath("lib_list_dialog.ks").

until 0 {
  // List of storage tanks. Always the same.
  set storageTanks to SHIP:PARTSTAGGED("storageTank").
  
  set modeList to list("Refuel UT","Restock","Load shuttle","General refueling").
  if body:name = "Kerbin" { modeList:remove(2). set shuttleName to "Transfer". }
  if body:name = "Mun" { set shuttleName to "Fueler". }

  list elements in eList.

  set dockedShips to list().

  set choice to open_menu("Select mode", modeList).
  if choice = "Refuel UT" {
    for elem in eList {
      if elem:name:startswith("UT") {
        dockedShips:add(elem:name).
      }
    }
    set choice to open_list_dialog("Select UT to refuel", dockedShips).
    set targetShip to dockedShips[choice].
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
        dockedShips:add(elem:name).
      }
    }
    set choice to open_list_dialog("Select ship to restock from", dockedShips).
    set refuelerShip to dockedShips[choice].
    set shuttleTanks to list().
    for item in refuelerShip:parts {
      if item:tag = "shuttleTank" {
        shuttleTanks:add(item).
      }
    }
    fuel_transfer(shuttleTanks, storageTanks, 700).
  }
  if choice = "Load shuttle" {
    for elem in eList {
      // are we at mine on Mun?
      if ship:status = "LANDED" {
        if elem:name:contains("Fueler") {          
          dockedShips:add(elem:name).
        }
      } else {
        if elem:name:contains("Transfer") {    
          dockedShips:add(elem:name).
        }
      }
    }
    set choice to open_list_dialog("Select oiler to refuel", dockedShips).
    set shuttleShip to dockedShips[choice].
    set shuttleTanks to list().
    for item in shuttleShip:parts {
      if item:tag = "shuttleTank" {
        shuttleTanks:add(item).
      }
    }
    fuel_transfer(storageTanks, shuttleTanks, 0).
  }
}
