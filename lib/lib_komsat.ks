// Put mothership in orbit suited for spaced out satellite launch
// Calculate node, because cooked steering is broken with RemoteTech on long distances
function ejection_orbit {
  parameter number_of_sats.
  
//  lock steering to retrograde.
//  wait until vdot(facing:forevector, retrograde:forevector) >= 0.995.
  
  set ej_orb_period to ship:orbit:period / number_of_sats * (number_of_sats -1) / 2.
  
  clearscreen.
  print "Orbit in seconds: " + ship:orbit:period.
  set hours to floor(ej_orb_period / 3600).
  set minutes_rest to ej_orb_period - hours*3600.
  set minutes to floor(minutes_rest / 60).
  set seconds to round(ej_orb_period - hours*3600 - minutes*60).
  print "Calculated half orbit time: " + hours + " h " + minutes + " m " + seconds + " s".
  // terminal:input:getchar().
  
  set mynode to node(time:seconds + 180, 0, 0, -1).
  add mynode.
  
  print "Calculating node".
  until (mynode:orbit:period < ej_orb_period*2) {
    set mynode:prograde to mynode:prograde - 0.1.
  }
  print "Fine tuning...".
  until (mynode:orbit:period < ej_orb_period*2) {
    set mynode:prograde to mynode:prograde - 0.01.
  }
  
  print "Maneuver node set".
//  lock throttle to tset.
  
//  until 0 {
//    set tset to min(ship:orbit:period / ej_orb_period *10, 1).
//    if ship:orbit:period < ej_orb_period {
//      unlock throttle.
//      set ship:control:pilotmainthrottle to 0.
//      set ship:control:neutralize to true.
//      unlock steering.
//      break.
//    }
//  }  

  unlock steering.
}

// Turn ship in direction of sun
function sun_expose {
  clearscreen.
  set the_sun to SUN.
  set sun_position to sun:position.
  
  print "Sun:  " + sun_position.
  print "Ship: " + ship:facing.
  
  
  return.
  sas off.
  set ship:control:roll to 0.01.
  wait until (ship:facing:roll > 85 and ship:facing:roll < 95) or (ship:facing:roll > 265 and ship:facing:roll < 275).
  set ship:control:roll to 0.
  sas on.
}
