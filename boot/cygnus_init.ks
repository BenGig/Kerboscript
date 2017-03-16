clearscreen.

PRINT "Initializing...".

copypath("0:/missions/cygnus_land.ks", "1:/land.ks").
copypath("0:/generic_launch.ks", "1:/launch.ks").
copypath("0:/lib/circ.ks", "1:/").
copypath("0:/lib/node.ks", "1:/").
copypath("0:/lib/node_peri.ks", "1:/").
copypath("0:/lib/node_apo.ks", "1:/").
copypath("0:/lib/lib_ui.ks", "1:/").


PRINT "Landing script for Cygnus installed.".

cd("1:/").

print "Select target now.".
terminal:input:getchar().

if not hastarget {
  runpath("0:/lib/lib_enter_string").
  print "Enter apoapsis:".
  set apo to enter_string().
  set apo to apo:tonumber.
} else {
  set apo to target:orbit:periapsis.
}
print "".
print "Target apoapsis: ".
print apo.
print "".
print ">>> Check staging! <<<".
print "".
print "Then press key to init launch.".
terminal:input:getchar().

runpath("launch", apo).
