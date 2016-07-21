// Execute Ascent Profile v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION EXECUTE_ASCENT_STEP {
  PARAMETER direction.
  PARAMETER minAlt.
  PARAMETER newAngle.
  PARAMETER newThrust.

  SET prevThrust TO MAXTHRUST.

  UNTIL FALSE {

    IF MAXTHRUST < (prevThrust - 10) {
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      WAIT 1. STAGE. WAIT 1.
      LOCK THROTTLE TO currentThrottle.
      SET prevThrust TO MAXTHRUST.
    }

    IF ALTITUDE > minAlt {
      LOCK STEERING TO HEADING(direction, newAngle).
      LOCK THROTTLE TO newThrust.
      BREAK.
    }

    WAIT 0.1.
  }
}

FUNCTION EXECUTE_ASCENT_PROFILE {
  PARAMETER direction.
  PARAMETER profile.

  SET step TO 0.
  UNTIL step >= profile:length - 1 {
    EXECUTE_ASCENT_STEP(
      direction,
      profile[step],
      profile[step+1],
      profile[step+2]
    ).
    SET step TO step + 3.
  }
}

FUNCTION POST_ASCENT {
  // Start circularization
  WAIT UNTIL ETA:APOAPSIS < ASCENT_CIRCULARIZE_ETA.
  LOCK THROTTLE TO 1.

   // Ditch drive section during circularization when empty
  WHEN MAXTHRUST = 0 THEN {
    LOCK THROTTLE TO 0. WAIT 1. STAGE. WAIT 1. STAGE. LOCK THROTTLE TO 1.
  }
   
  // Complete circularization
  WAIT UNTIL PERIAPSIS > 80000.

  LOCK THROTTLE TO 0.
  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
}