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


FUNCTION fuelLevel {
  PARAMETER tank.
  RETURN tank:mass - tank:drymass.
}

function shuttle_restock_amount {
  if body:name = "Kerbin" {
    // Fuel transporter Mun - Kerbin
    return 450.
  }
  if body:name = "Mun" {
    // Fuel lifter Mun Mine - Mun Fuel Station
    return 250.
  }
}

runoncepath("lib_list_dialog.ks").

set remainingFuel TO 50.

until 0 {
    clearscreen.
	print "Press key to start fueling menu, 'q' to quit".
	if terminal:input:getchar() = "q" { break. }
	
	set receiverTanks TO list().
	set shuttleTanks TO list().

	// List of storage tanks
	set storage to SHIP:PARTSTAGGED("storageTank").

	// Get docked ships, select vessel
	list elements in eList.
	set elem_names TO list().
	for elem in eList {
	  elem_names:add(elem:NAME).
	}

	set choice to open_list_dialog("Select docked vessel", elem_names).
	set selectedShip to elist[choice].

	FOR item IN selectedShip:PARTS {
	  IF item:TAG = "receiverTank" {
		receiverTanks:ADD(item).
	  } 
	  IF item:TAG = "shuttleTank" {
		shuttleTanks:ADD(item).
	  } 
	}

	set choice to open_menu("Select resource", list("liquidfuel","monopropellant","oxidizer")).

	IF receiverTanks:LENGTH > 0 {
	  SET job TO TRANSFERALL(choice, storage, receiverTanks).
	} ELSE {
	  SET job TO TRANSFERALL(choice, shuttleTanks, storage).
	}

	SET job:ACTIVE TO true.
}
