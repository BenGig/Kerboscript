// Interplanetary maneuvers

function mnv_hko {
  clearscreen.
  print "Preparing transfer to high Kerbin orbit".

  sas off.

  lock steering to prograde.
  wait until vdot(facing:forevector, prograde:forevector) >= 0.995.
  
  until ship:apoapsis > 7500000 {
    lock throttle to 1.
  }
  lock throttle to 0.
  unlock throttle.
  unlock steering.
}

// Put mothership in orbit suited for spaced out satellite launch
function ejection_orbit {
  parameter number_of_sats.
  
  lock steering to retrograde.
  wait until vdot(facing:forevector, retrograde:forevector) >= 0.995.
  
  set ej_orb_period to ship:orbit:period / number_of_sats * (number_of_sats -1).
  
  lock throttle to tset.
  
  until 0 {
    set tset to min(ship:orbit:period / ej_orb_period *10, 1).
    if ship:orbit:period < ej_orb_period {
      unlock throttle.
      set ship:control:pilotmainthrottle to 0.
      set ship:control:neutralize to true.
      unlock steering.
      break.
    }
  }  
}
