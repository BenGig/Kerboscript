SET classname TO "MunProbe".

REQUIRE("class_" + classname + ".ks").
REQUIRE("lib_ascent.ks").

LOCK THROTTLE TO 1. WAIT 1. STAGE.
EXECUTE_ASCENT_PROFILE(90, ASCENT_PROFILE).

// Enable Communitron and shutdown
TOGGLE LIGHTS.

// Finalize orbit
POST_ASCENT().

PRINT "All done, shutting down.".
DELETE ("lib_ascent.ks").