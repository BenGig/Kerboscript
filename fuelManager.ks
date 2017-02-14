// Fuel storage management

// Fuel transfer standard jobs
//
// From fuel shuttle to storage
// from storage to some consumer ship

// Get docked ships
LIST elements in eList.

SET currentShip TO eList:ITERATOR.
currentShip:RESET().
UNTIL NOT currentShip:NEXT {
  print currentShip:INDEX + ": " + currentShip:VALUE:NAME.
}

SET selectedShipNum TO terminal:input:getchar().
PRINT "Selected ship: " + selectedShipNum.
SET selectedShip TO elist[selectedShipNum].
PRINT selectedShip.

// List of storage tanks
SET storage to SHIP:PARTSTAGGED("storageTank").

// all normal consumer ship tanks
SET receiver to SHIP:PARTSTAGGED("receiverTank").

// fuel transporter tanks (used dual way)
SET shuttle to SHIP:PARTSTAGGED("shuttleTank").

FUNCTION fuelLevel {
  PARAMETER tank.
  RETURN tank:mass - tank:drymass.
}

