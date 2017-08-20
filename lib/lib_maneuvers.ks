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
  set target to sun.
  return.
  
  clearscreen.
  print "SAS off".
  sas off.

  print "Freeze ship".
  set ship:control:neutralize to true.
  
  print "Eliminating rotation".
  if ship:facing:roll > 180 {
      set ship:control:roll to 0.005.
  } else {
      set ship:control:roll to -0.005.
  }
  wait until ((ship:facing:roll > 355 and ship:facing:roll < 359) or (ship:facing:roll > 5 and ship:facing:roll < 10)).
  set ship:control:roll to 0.

  print "SAS on".
  sas on.
  wait 10.
  print "SAS off".
  sas off.
  
  print "Eliminating yaw".
  set ship:control:yaw to 0.005.
  wait until (ship:facing:yaw > sun:direction:yaw-5 and ship:facing:yaw < sun:direction:yaw+5).
  set ship:control:yaw to 0.  

  print "SAS on".
  sas on.
  wait 10.
  print "SAS off".
  sas off.
  
  print "Eliminating pitch".
  set ship:control:pitch to 0.005.
  wait until (ship:facing:pitch > sun:direction:pitch-5 and ship:facing:pitch < sun:direction:pitch+5).
  set ship:control:pitch to 0.  
  
  sas on.
  return.
}
