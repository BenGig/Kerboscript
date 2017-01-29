clearscreen.

PRINT "Initializing...".
copypath("0:/cygnus_land.ks", "1:/land.ks").

PRINT "Landing script for Cygnus installed.".

cd("0:/").

print "Select target now.".
terminal:input:getchar().

if not hastarget {
  runpath("0:/lib_enter_string").
  print "Enter apoapsis:".
  set apo to enter_string().
  set apo to apo:tonumber.
} else {
  set apo to target:orbit:periapsis.
}
print apo.

print "Press key to init launch.".
terminal:input:getchar().

runpath("0:/lib_launch_asc", apo).

