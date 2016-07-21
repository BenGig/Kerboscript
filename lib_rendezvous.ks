// Rendezvous Library v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION RDV_STEER {
  PARAMETER vector.

  LOCK STEERING TO vector.
  WAIT UNTIL VANG(SHIP:FACING:FOREVECTOR, vector) < 2.
}

FUNCTION RDV_APPROACH {
  PARAMETER craft, speed.

  LOCK relativeVelocity TO craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(craft:POSITION). LOCK STEERING TO craft:POSITION.

  LOCK maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE TO MIN(1, ABS(speed - relativeVelocity:MAG) / maxAccel).

  WAIT UNTIL relativeVelocity:MAG > speed - 0.1.
  LOCK THROTTLE TO 0.
  LOCK STEERING TO relativeVelocity.
}

FUNCTION RDV_CANCEL {
  PARAMETER craft.

  LOCK relativeVelocity TO craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(relativeVelocity). LOCK STEERING TO relativeVelocity.

  LOCK maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE TO MIN(1, relativeVelocity:MAG / maxAccel).

  WAIT UNTIL relativeVelocity:MAG < 0.1.
  LOCK THROTTLE TO 0.
}

FUNCTION RDV_AWAIT_NEAREST {
  PARAMETER craft, minDistance.

  UNTIL 0 {
    SET lastDistance TO craft:DISTANCE.
    WAIT 0.5.
    IF craft:distance > lastDistance OR craft:distance < minDistance { BREAK. }
  }
}


// Loop until our distance from the target is increasing
FUNCTION AWAIT_CLOSEST_APPROACH {
  UNTIL FALSE {
    SET lastDistance TO TARGET:DISTANCE.
    WAIT 1.
    IF TARGET:DISTANCE > lastDistance {
      BREAK.
    }
  }
}

// Throttle against our relative velocity vector until we're increasing it
FUNCTION CANCEL_RELATIVE_VELOCITY {
  LOCK STEERING TO TARGET:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  WAIT 5.

  LOCK THROTTLE TO 0.5.
  UNTIL FALSE {
    SET lastDiff TO (TARGET:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT):MAG.
    WAIT 1.
    IF (TARGET:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT):MAG > lastDiff {
      LOCK THROTTLE TO 0. BREAK.
    }
  }
}

// Throttle for five seconds toward the target
FUNCTION APPROACH {
  LOCK STEERING TO TARGET:POSITION.
  WAIT 5. LOCK THROTTLE TO 0.1. WAIT 5.
  LOCK THROTTLE TO 0.
}

// Throttle prograde or retrograde to change our orbital period
FUNCTION CHANGE_PERIOD {
  PARAMETER victim.
  SET targetAngle TO TARGET_ANGLE(victim).
  SET newPeriod   TO TARGET:OBT:PERIOD * (1 + ((360 - targetAngle) / 360)).

  SET currentPeriod TO SHIP:OBT:PERIOD.
  SET boost         TO newPeriod > currentPeriod.

  IF boost {
    LOCK STEERING TO PROGRADE.
  } ELSE {
    LOCK STEERING TO RETROGRADE.
  }

  WAIT 5.
  LOCK THROTTLE TO 0.5.

  IF boost {
    WAIT UNTIL SHIP:OBT:PERIOD > newPeriod.
  } ELSE {
    WAIT UNTIL SHIP:OBT:PERIOD < newPeriod.
  }

  LOCK THROTTLE TO 0.
}
